import 'package:dev_partner/View/screens/chat_screen.dart';
import 'package:dev_partner/View/widgets/cp_ui_helper.dart';
import 'package:dev_partner/View/widgets/profile_avatar.dart';
import 'package:dev_partner/model_view/chat_provider.dart';
import 'package:dev_partner/model_view/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/theme.dart';
import 'package:provider/provider.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController searchController = TextEditingController();
  bool _selectionMode = false;
  final Set<int> _selectedConversationIds = {};

  void _clearSelection() {
    setState(() {
      _selectionMode = false;
      _selectedConversationIds.clear();
    });
  }

  void _enterSelection(int conversationId) {
    setState(() {
      _selectionMode = true;
      _selectedConversationIds.add(conversationId);
    });
  }

  void _toggleSelection(int conversationId) {
    setState(() {
      if (_selectedConversationIds.contains(conversationId)) {
        _selectedConversationIds.remove(conversationId);
        if (_selectedConversationIds.isEmpty) {
          _selectionMode = false;
        }
      } else {
        _selectedConversationIds.add(conversationId);
      }
    });
  }

  Future<void> _deleteSelectedConversations() async {
    if (_selectedConversationIds.isEmpty) return;
    final confirmed = await showConfirmDeleteDialog(
      context,
      message: "Delete selected conversations?",
    );
    if (!mounted || !confirmed) return;
    final cp = context.read<ChatProvider>();
    await cp.deleteConversations(_selectedConversationIds.toList());
    _clearSelection();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final cp = Provider.of<ChatProvider>(context, listen: false);
      await cp.initUser();
      if (cp.conversations.isEmpty) {
        await cp.getAllConversations();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final up = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(
        iconTheme: IconThemeData(color: C.green),
        backgroundColor: C.bg,
        elevation: 0,
        leading: _selectionMode
            ? IconButton(
                icon: Icon(Icons.close, color: C.green),
                onPressed: _clearSelection,
              )
            : null,
        actions: [
          if (_selectionMode && _selectedConversationIds.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_outline, color: C.green),
              onPressed: _deleteSelectedConversations,
            ),
        ],
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [C.green, C.cyan],
          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
          child: Text(
            "Messages",
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: width * 0.06,
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            /// 🔍 Search Field
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: searchController,
                style: TextStyle(color: C.textPrimary),
                cursorColor: C.green,
                decoration: InputDecoration(
                  hintText: "Search by name or domain",
                  prefixIcon: Icon(Icons.search, color: C.textPrimary),
                  hintStyle: TextStyle(color: C.textLabel),
                  filled: true,
                  fillColor: C.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: C.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: C.borderFocus, width: 1.5),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, provider, child) {
                  final chats = provider.conversations.where((chat) {
                    if (chat == null) return false;
                    final user = chat["user"];
                    if (user == null) return false;
                    // ✅ check username too
                    final hasName = user["name"] != null || user["username"] != null;
                    return hasName;
                  }).toList();

                  if (provider.isLoading && chats.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (chats.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(width * 0.06),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: C.surface.withOpacity(0.08),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: width * 0.18,
                              color: C.textMuted,
                            ),
                          ),
                          SizedBox(height: height * 0.035),
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [Colors.white, C.textMuted],
                            ).createShader(bounds),
                            child: Text(
                              "No conversations yet",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(
                                fontSize: width * 0.065,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.018),
                          Text(
                            "Start connecting with teammates and your chats will appear here.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSans(
                              color: C.textMuted,
                              fontSize: width * 0.036,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      final user = chat["user"] ?? {};
                      final profileImage = user["profile_image"] ?? "";
                      final name =
                          user["username"] ?? user["name"] ?? "Unknown";
                      final lastMessage = chat["last_message"] ?? "";
                      final conversationId = chat["id"] is int
                          ? chat["id"] as int
                          : int.tryParse(chat["id"]?.toString() ?? "");
                      final isSelected = conversationId != null &&
                          _selectedConversationIds.contains(conversationId);
                      final unreadCount = chat["unread_count"] is int
                          ? chat["unread_count"] as int
                          : int.tryParse(chat["unread_count"]?.toString() ?? "") ?? 0;

                      debugPrint("Chat ${chat["id"]} unread_count raw: ${chat["unread_count"]} → parsed: $unreadCount"); // 👈 add this

                      return GestureDetector(
                        onLongPress: () {
                          if (conversationId == null) return;
                          _enterSelection(conversationId);
                        },
                        onTap: () {
                          if (_selectionMode) {
                            if (conversationId == null) return;
                            _toggleSelection(conversationId);
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreenUI(
                                userId: user["id"],
                                name: name,
                                imageUrl: profileImage,
                                currentUserId: up.currentUserId ?? 0,
                                isOnline: user["is_online"] == true,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: height * 0.015),
                          padding: EdgeInsets.all(width * 0.04),
                          decoration: BoxDecoration(
                            color: C.surface.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(width * 0.04),
                            border: Border.all(
                              color: isSelected ? C.green : Colors.white12,
                              width: isSelected ? 1.5 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: C.surface.withOpacity(0.1),
                                blurRadius: width * 0.02,
                                spreadRadius: 0.5,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  ProfileAvatar(
                                    imageUrl: profileImage,
                                    radius: width * 0.08,
                                  ),
                                  if (user["is_online"] == true)
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        width: width * 0.03,
                                        height: width * 0.03,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.greenAccent,
                                          border: Border.all(
                                            color: C.bg,
                                            width: width * 0.007,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                              SizedBox(width: width * 0.04),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: width * 0.045,
                                      ),
                                    ),
                                    SizedBox(height: height * 0.005),
                                    Text(
                                      lastMessage,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: width * 0.035,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    chat["time"] ?? "",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: width * 0.03,
                                    ),
                                  ),
                                  if (unreadCount > 0)
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: height * 0.005,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.025,
                                        vertical: height * 0.003,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.greenAccent,
                                        borderRadius: BorderRadius.circular(
                                          width * 0.03,
                                        ),
                                      ),
                                      child: Text(
                                        unreadCount.toString(),
                                        style: TextStyle(
                                          color: C.bg,
                                          fontSize: width * 0.028,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
