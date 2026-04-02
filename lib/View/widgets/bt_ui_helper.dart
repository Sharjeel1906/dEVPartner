import 'package:dev_partner/View/screens/create_profile.dart';
import 'package:dev_partner/View/screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/theme.dart';
import '../models/profile.dart';

Widget profileCard(BuildContext context, Profile profile) {
  // MediaQuery values
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  return Container(
    margin: EdgeInsets.symmetric(vertical: screenHeight * 0.012),
    padding: EdgeInsets.all(screenWidth * 0.04),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(screenWidth * 0.05),
      border: Border.all(color: Colors.white.withOpacity(0.1)),
      boxShadow: [
        BoxShadow(
          color: C.surface,
          blurRadius: screenWidth * 0.05,
          spreadRadius: screenWidth * 0.002,
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔹 Top Row (Image + Info)
        Row(
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.008),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.greenAccent, Colors.cyanAccent],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: screenWidth * 0.07,
                    backgroundImage: NetworkImage(profile.imageUrl),
                  ),
                ),
              ],
            ),

            SizedBox(width: screenWidth * 0.03),

            /// Name + Role
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    "${profile.role} / ${profile.semester}",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: screenWidth * 0.03,
                    ),
                  ),
                ],
              ),
            ),

            /// Domain Tag
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.025, vertical: screenHeight * 0.005),
              decoration: BoxDecoration(
                color: Colors.greenAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
              ),
              child: Text(
                profile.domain.toUpperCase(),
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: screenWidth * 0.025,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),

        SizedBox(height: screenHeight * 0.015),

        /// 🔹 Skills Label
        Text(
          "Skills Section",
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: screenWidth * 0.03,
          ),
        ),

        SizedBox(height: screenHeight * 0.01),

        /// 🔹 Skills Chips
        Wrap(
          spacing: screenWidth * 0.02,
          children: profile.skills.map((skill) {
            return Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03, vertical: screenHeight * 0.008),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(screenWidth * 0.025),
                border: Border.all(color: Colors.white12),
              ),
              child: Text(
                skill,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.03,
                ),
              ),
            );
          }).toList(),
        ),

        SizedBox(height: screenHeight * 0.018),

        /// 🔹 Buttons
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.035),
                  gradient: LinearGradient(
                    colors: [Colors.greenAccent, Colors.cyanAccent],
                  ),
                ),
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>UserProfileScreen()));
                  },
                  child: Text(
                    "View Profile",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(width: screenWidth * 0.025),

            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.035),
                  border: Border.all(color: Colors.greenAccent),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        color: Colors.greenAccent, size: screenWidth * 0.04),
                    SizedBox(width: screenWidth * 0.015),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>UserProfileScreen()));
                      },
                      child: Text(
                        "Message",
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    ),
  );
}