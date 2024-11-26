import 'package:flutter/material.dart';
import 'package:hand_controller_app/AuthFeature/services/AuthService.dart';
import 'package:hand_controller_app/SettingsFeature/screens/SettingsScreen.dart';

import '../../AuthFeature/screens/SignInScreen.dart';
import '../../AuthFeature/services/UserService.dart';
import '../../DisplayingValuesFeature/screens/DisplayValuesScreen.dart';
import '../../GlobalThemeData.dart';

class TrainingProgramDashboardDrawer extends StatelessWidget {
  final String name;
  final AuthService authService;
  final UserService userService;

  TrainingProgramDashboardDrawer({
    Key? key,
    required this.name,
    required this.authService,
    required this.userService,
  }) : super(key: key);

  @override
  Drawer build(BuildContext context) {
    return Drawer(
      width: 250,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [CustomTheme.mainColor2, CustomTheme.mainColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.transparent, // Keep transparent to show gradient
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person_outline, size: 70, color: Colors.white),
                    Text(name, style: const TextStyle(fontSize: 30, color: Colors.white)),
                  ],
                ),
              ),
            ),
            const Divider(color: Colors.white), // Separation line
            ListTile(
              title: const Text('Dashboard Programs', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Dashboard Values', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DisplayValuesScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Progress Tracking', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Profile', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Sign out', style: TextStyle(color: Colors.white)),
              onTap: () async {
                await authService.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
