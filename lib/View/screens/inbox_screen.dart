import 'package:dev_partner/View/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/theme.dart';
import '../models/chat.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final List<Chat> chats = [
    Chat(
      name: "Alisha M.",
      lastMessage: "Hey! Are you free for a call?",
      imageUrl: "https://randomuser.me/api/portraits/women/44.jpg",
      time: "2:30 PM",
      isOnline: true,
      unreadCount: 2,
    ),
    Chat(
      name: "Ali Raza",
      lastMessage: "Sent you the Flutter project files.",
      imageUrl: "https://randomuser.me/api/portraits/men/32.jpg",
      time: "1:15 PM",
      unreadCount: 0,
    ),
    Chat(
      name: "Sara Khan",
      lastMessage: "Looking forward to our meeting tomorrow.",
      imageUrl: "https://randomuser.me/api/portraits/women/68.jpg",
      time: "Yesterday",
      unreadCount: 1,
    ),
    Chat(
      name: "Usman Tariq",
      lastMessage: "Let's discuss AI/ML techniques.",
      imageUrl: "https://randomuser.me/api/portraits/men/75.jpg",
      time: "Monday",
      isOnline: true,
    ),
    Chat(
      name: "Hina Sheikh",
      lastMessage: "Can you review my Figma design?",
      imageUrl: "https://randomuser.me/api/portraits/women/21.jpg",
      time: "Sunday",
    ),
  ];

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(
        iconTheme: IconThemeData(color: C.green),
        backgroundColor: C.bg,
        elevation: 0,
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
                  prefixIcon:
                  Icon(Icons.search, color: C.textPrimary),
                  hintStyle: TextStyle(color: C.textLabel),
                  filled: true,
                  fillColor: C.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: C.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: C.borderFocus, width: 1.5),
                  ),
                ),
              ),
            ),

            /// 💬 Chat List (FIXED)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatScreenUI(),
                        ),
                      );
                    },
                    child: Container(
                      margin:
                      EdgeInsets.only(bottom: height * 0.015),
                      padding: EdgeInsets.all(width * 0.04),
                      decoration: BoxDecoration(
                        color: C.surface.withOpacity(0.05),
                        borderRadius:
                        BorderRadius.circular(width * 0.04),
                        border: Border.all(color: Colors.white12),
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
                              CircleAvatar(
                                radius: width * 0.08,
                                backgroundImage:
                                NetworkImage(chat.imageUrl),
                              ),
                              if (chat.isOnline)
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
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chat.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight:
                                    FontWeight.bold,
                                    fontSize: width * 0.045,
                                  ),
                                ),
                                SizedBox(
                                    height: height * 0.005),
                                Text(
                                  chat.lastMessage,
                                  style: TextStyle(
                                    color: Colors.white
                                        .withOpacity(0.6),
                                    fontSize: width * 0.035,
                                  ),
                                  overflow:
                                  TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.end,
                            children: [
                              Text(
                                chat.time,
                                style: TextStyle(
                                  color: Colors.white
                                      .withOpacity(0.6),
                                  fontSize: width * 0.03,
                                ),
                              ),
                              if (chat.unreadCount > 0)
                                Container(
                                  margin: EdgeInsets.only(
                                      top: height * 0.005),
                                  padding:
                                  EdgeInsets.symmetric(
                                    horizontal:
                                    width * 0.025,
                                    vertical:
                                    height * 0.003,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                    Colors.greenAccent,
                                    borderRadius:
                                    BorderRadius.circular(
                                        width * 0.03),
                                  ),
                                  child: Text(
                                    chat.unreadCount
                                        .toString(),
                                    style: TextStyle(
                                      color: C.bg,
                                      fontSize:
                                      width * 0.028,
                                      fontWeight:
                                      FontWeight.bold,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}