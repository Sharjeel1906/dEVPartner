import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/theme.dart';

class ChatScreenUI extends StatelessWidget {
  const ChatScreenUI({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final List<Map<String, dynamic>> messages = [
      {"text": "Hey! How are you?", "isMe": false, "time": "2:30 PM"},
      {"text": "I'm good, you?", "isMe": true, "time": "2:31 PM"},
      {
        "text": "Doing well. Working on Flutter project.",
        "isMe": false,
        "time": "2:32 PM",
      },
      {"text": "That's great!", "isMe": true, "time": "2:35 PM"},
      {"text": "Let's meet tomorrow.", "isMe": false, "time": "Yesterday"},
    ];

    return Scaffold(
      backgroundColor: C.bg,

      appBar: AppBar(
        backgroundColor: C.bg,
        elevation: 0,
        iconTheme: IconThemeData(color: C.green),
        titleSpacing: 0,
        title: Row(
          children: [
            /// Avatar with gradient border
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [C.green, C.cyan]),
              ),
              child: CircleAvatar(
                radius: width * 0.055,
                backgroundImage: NetworkImage(
                  "https://randomuser.me/api/portraits/women/44.jpg",
                ),
              ),
            ),

            SizedBox(width: width * 0.03),

            /// Name + status
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Alisha M.",
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.042,
                  ),
                ),
                Text(
                  "Online",
                  style: TextStyle(color: C.green, fontSize: width * 0.028),
                ),
              ],
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          /// 💬 CHAT AREA
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: height * 0.02,
              ),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final bool isMe = msg['isMe'] as bool;
                final String text = msg['text'] as String;
                final String time = msg['time'] as String;

                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: height * 0.006),
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.045,
                      vertical: height * 0.01,
                    ),
                    constraints: BoxConstraints(maxWidth: width * 0.72),

                    decoration: BoxDecoration(
                      gradient: isMe
                          ? LinearGradient(
                              colors: [C.green, C.cyan],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isMe ? null : Colors.white.withOpacity(0.04),

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

                      border: isMe ? null : Border.all(color: Colors.white10),

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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        /// Message text
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

          /// ✨ INPUT BAR (PREMIUM STYLE)
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
                /// Input Field
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(width * 0.06),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: TextField(
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

                /// 🔥 Gradient Send Button with Glow
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
                    onPressed: () {},
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
