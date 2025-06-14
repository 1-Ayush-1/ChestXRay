import 'package:check/main.dart';
import 'package:check/User_Verification/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    // String name;
    // Accessing user data from UserProvider
    final user = userProvider.user;
    
    return Container(
      decoration: const BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: CircleAvatar(
              radius: 30,
              backgroundImage: user!.profilePhoto != null
                ? NetworkImage(user.profilePhoto!) 
                : AssetImage('assets/user.jpg'), // Use a placeholder image asset
              ),
            // child: const CircleAvatar(
            //   radius: 30,
            //   backgroundImage: user!.profilePhoto,
            // //   NetworkImage(
            // //       'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'), // Replace with the actual image URL            ),
            //  ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // name = user.username,
              // name = name.substring(1,14),
              Text(
                (user.username.length >= 14)
                  ? user.username.substring(0, 14)
                  : user.username , // Display username or empty string if null
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              Text(
                '@userhandle',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

