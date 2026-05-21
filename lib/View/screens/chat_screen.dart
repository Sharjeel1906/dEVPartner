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
  late ChatProvider _chatProvider; // 👈 Add this

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _chatProvider = Provider.of<ChatProvider>(context, listen: false); // 👈 Save here
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final cp = Provider.of<ChatProvider>(context, listen: false);
      await cp.initUser(forceRefresh: true);
      cp.currentUserId = cp.currentUserId ?? widget.currentUserId;
      cp.clearMessages();
      await cp.getConversationMessages(widget.userId);
      final senderId = cp.currentUserId ?? widget.currentUserId;
      await cp.connectSocket(widget.userId, senderId);
    });
  }

  @override
  void dispose() {
    _chatProvider.disconnectSocket(); // 👈 Use saved reference, NOT context.read()
    msgController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final provider = context.watch<ChatProvider>();
    final messages = provider.messages;
    final hasImage = (widget.imageUrl).toString().isNotEmpty;
    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(
        backgroundColor: C.bg,
        elevation: 0,
        iconTheme: IconThemeData(color: C.green),
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [C.green, C.cyan]),
              ),
              child: CircleAvatar(
                radius: width * 0.055,
                backgroundColor: C.surface,
                backgroundImage: hasImage
                    ? NetworkImage(widget.imageUrl)
                    : null,
              ),
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
                final bool isUnread = !isMe && (msg['is_read'] == false);
                int unreadCount = messages.where((msg) {
                  final senderId = int.tryParse(msg['sender_id'].toString()) ?? -1;
                  return senderId != widget.currentUserId && msg['is_read'] == false;
                }).length;
                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
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
                      border: isMe
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
                );
              },
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.035,
              vertical: height * 0.012,
            ),
            decoration: BoxDecoration(
              color: C.surface.withOpacity(0.08),
              border: Border(top: BorderSide(color: Colors.white12)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(width * 0.06),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: TextField(
                      controller: msgController,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: C.green,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: TextStyle(color: C.textLabel),
                        border: InputBorder.none,
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
        ],
      ),
    );
  }
}