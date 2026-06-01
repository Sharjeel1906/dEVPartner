import 'package:dev_partner/View/widgets/cp_ui_helper.dart';
import 'package:dev_partner/View/widgets/profile_avatar.dart';
import 'package:dev_partner/model_view/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/theme.dart';

class ChatScreenUI extends StatefulWidget {
  final int userId;
  final String name;
  final String imageUrl;
  final int currentUserId;
  final bool isOnline;
  const ChatScreenUI({
    super.key,
    required this.userId,
    required this.name,
    required this.imageUrl,
    required this.currentUserId,
    this.isOnline = false,
  });

  @override
  State<ChatScreenUI> createState() => _ChatScreenUIState();
}

class _ChatScreenUIState extends State<ChatScreenUI> {
  final TextEditingController msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _msgFocusNode = FocusNode();
  int _lastMessagesLength = 0;
  late ChatProvider _chatProvider;
  bool _selectionMode = false;
  final Set<int> _selectedMessageIds = {};

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _onMessagesChanged() {
    if (!mounted) return;
    final cp = Provider.of<ChatProvider>(context, listen: false);
    if (cp.messages.length != _lastMessagesLength) {
      _lastMessagesLength = cp.messages.length;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _onFocusChanged() {
    if (_msgFocusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          _scrollToBottom();
        }
      });
    }
  }

  void _clearSelection() {
    setState(() {
      _selectionMode = false;
      _selectedMessageIds.clear();
    });
  }

  void _enterSelection(int messageId) {
    setState(() {
      _selectionMode = true;
      _selectedMessageIds.add(messageId);
    });
  }

  void _toggleSelection(int messageId) {
    setState(() {
      if (_selectedMessageIds.contains(messageId)) {
        _selectedMessageIds.remove(messageId);
        if (_selectedMessageIds.isEmpty) {
          _selectionMode = false;
        }
      } else {
        _selectedMessageIds.add(messageId);
      }
    });
  }

  Future<void> _deleteSelectedMessages() async {
    if (_selectedMessageIds.isEmpty) return;
    final confirmed = await showConfirmDeleteDialog(
      context,
      message: "Delete selected messages?",
    );
    if (!mounted || !confirmed) return;
    await _chatProvider.deleteMessages(_selectedMessageIds.toList());
    _clearSelection();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _chatProvider = Provider.of<ChatProvider>(context, listen: false); // 👈 Save here
  }

  @override
  void initState() {
    super.initState();
    final cp = Provider.of<ChatProvider>(context, listen: false);
    cp.addListener(_onMessagesChanged);
    _msgFocusNode.addListener(_onFocusChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await cp.initUser();
      cp.currentUserId = cp.currentUserId ?? widget.currentUserId;
      cp.clearMessages();
      await cp.getConversationMessages(widget.userId);
      await cp.markConversationAsRead(widget.userId); // ← add this line
      final senderId = cp.currentUserId ?? widget.currentUserId;
      await cp.connectSocket(widget.userId, senderId);
      
      // Initialize length and scroll to bottom
      _lastMessagesLength = cp.messages.length;
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _chatProvider.removeListener(_onMessagesChanged);
    _chatProvider.disconnectSocket();
    _msgFocusNode.removeListener(_onFocusChanged);
    _msgFocusNode.dispose();
    msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final provider = context.watch<ChatProvider>();
    final messages = provider.messages;
    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(
        backgroundColor: C.bg,
        elevation: 0,
        iconTheme: IconThemeData(color: C.green),
        leading: _selectionMode
            ? IconButton(
                icon: Icon(Icons.close, color: C.green),
                onPressed: _clearSelection,
              )
            : null,
        automaticallyImplyLeading: !_selectionMode,
        actions: [
          if (_selectionMode && _selectedMessageIds.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_outline, color: C.green),
              onPressed: _deleteSelectedMessages,
            ),
        ],
        titleSpacing: 0,
        title: Row(
          children: [
            ProfileAvatar(
              imageUrl: widget.imageUrl,
              radius: width * 0.055,
              showGradientRing: true,
            ),

            SizedBox(width: width * 0.03),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (widget.name.isNotEmpty ? widget.name : "Unknown"),
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.042,
                  ),
                ),
                Text(
                  widget.isOnline ? "Online" : "Offline",
                  style: TextStyle(
                    color: widget.isOnline ? C.green : C.textMuted,
                    fontSize: width * 0.028,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : messages.isEmpty
            // ✅ Empty state instead of bouncing user away
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline_rounded,
                      color: C.textMuted, size: width * 0.15),
                  SizedBox(height: height * 0.02),
                  Text(
                    "No messages yet.\nSay hello!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      color: C.textMuted,
                      fontSize: width * 0.038,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: height * 0.02,
              ),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final myId = widget.currentUserId.toString();
                final senderId = msg['sender_id'].toString();
                final bool isMe = senderId == myId;
                final String text = msg['text'] ?? msg['content'] ?? "";
                final String time = msg['time'] ?? msg['timestamp'] ?? "";
                final messageId = msg['id'] is int
                    ? msg['id'] as int
                    : int.tryParse(msg['id']?.toString() ?? "");
                final isSelected = messageId != null &&
                    _selectedMessageIds.contains(messageId);
                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: GestureDetector(
                    onLongPress: () {
                      if (messageId == null) return;
                      _enterSelection(messageId);
                    },
                    onTap: () {
                      if (!_selectionMode || messageId == null) return;
                      _toggleSelection(messageId);
                    },
                    child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: height * 0.006,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.045,
                      vertical: height * 0.01,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: width * 0.72,
                    ),
                    decoration: BoxDecoration(
                      gradient: isMe
                          ? LinearGradient(
                        colors: [C.green, C.cyan],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                          : null,
                      color: isMe
                          ? null
                          : Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: isMe
                            ? Radius.circular(20)
                            : Radius.circular(6),
                        bottomRight: isMe
                            ? Radius.circular(6)
                            : Radius.circular(20),
                      ),
                      border: isSelected
                          ? Border.all(
                        color: Colors.white,  // ✅ White border is visible on gradient
                        width: 3,
                      )
                          : isMe
                          ? null
                          : Border.all(color: Colors.white10),
                      boxShadow: [
                        BoxShadow(
                          color: isMe
                              ? C.green.withOpacity(0.25)
                              : Colors.black.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          text,
                          style: TextStyle(
                            color: isMe ? Colors.black : Colors.white,
                            fontSize: width * 0.036,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: height * 0.003),
                        Text(
                          time,
                          style: TextStyle(
                            color: (isMe ? Colors.black : Colors.white)
                                .withOpacity(0.6),
                            fontSize: width * 0.025,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),
                );
              },
            ),
          ),

          SafeArea(
            top: false,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                width * 0.04,
                height * 0.010,
                width * 0.04,
                height * 0.015,
              ),
              decoration: BoxDecoration(
                color: C.surface.withOpacity(0.12),
                border: Border(top: BorderSide(color: Colors.white12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04,
                        vertical: height * 0.008,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(width * 0.06),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: TextField(
                        controller: msgController,
                        focusNode: _msgFocusNode,
                        minLines: 1,
                        maxLines: 4,
                        style: const TextStyle(color: Colors.white),
                        cursorColor: C.green,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: TextStyle(color: C.textLabel),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: height * 0.012,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.025),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [C.green, C.cyan]),
                      boxShadow: [
                        BoxShadow(
                          color: C.green.withOpacity(0.5),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        final text = msgController.text.trim();
                        if (text.isEmpty) return;
                        provider.sendMessage(text);
                        msgController.clear();
                      },
                      icon: Icon(
                        Icons.send_rounded,
                        color: C.bg,
                        size: width * 0.055,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}