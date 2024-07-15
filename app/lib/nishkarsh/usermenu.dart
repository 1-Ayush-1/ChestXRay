// import 'package:cognix_chest_xray/Nishkarsh/profileheader.dart';
import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // const ProfileHeader(),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMenuItem(Icons.person, 'Profile', context, onTap: () {
                  Navigator.pushNamed(context, 'patient_profile/');
                }),
                _buildMenuItem(Icons.notifications, 'Chat', context, onTap: () {
                  Navigator.pushNamed(context, 'dummy-screen/');
                }),
                _buildMenuItem(Icons.settings, 'App Settings', context,
                    onTap: () {
                  Navigator.pushNamed(context, 'dummy-screen/');
                }),
                _buildMenuItem(Icons.privacy_tip, 'Privacy', context,
                    onTap: () {
                  Navigator.pushNamed(context, 'dummy-screen/');
                }),
                _buildMenuItem(Icons.help, 'Help & Support', context,
                    onTap: () {
                  Navigator.pushNamed(context, 'dummy-screen/');
                }),
                _buildMenuItem(Icons.question_answer, 'FAQs', context,
                    onTap: () {
                  Navigator.pushNamed(context, 'dummy-screen/');
                }),
                _buildMenuItem(Icons.exit_to_app, 'Logout', context, onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    'login/', // The route name of the new page you want to go to
                    (Route<dynamic> route) =>
                        false, // Remove all previous routes
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, BuildContext context,
      {Function()? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(color: Colors.black54)),
        onTap: onTap ?? () {},
      ),
    );
  }
}