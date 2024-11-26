import 'package:flutter/material.dart';
import 'package:hand_controller_app/AuthFeature/services/AuthService.dart';
import 'package:hand_controller_app/TrainingProgramsFeature/screens/TrainingProgramScreen.dart';

import '../../AuthFeature/screens/SignInScreen.dart';
import '../../AuthFeature/services/UserService.dart';
import '../../DisplayingValuesFeature/screens/DisplayValuesScreen.dart';

class SettingsDrawer extends StatelessWidget {

  final String name;
  final AuthService authService;
  final UserService userService;

  SettingsDrawer({Key? key,
    required this.name,
    required this.authService,
    required this.userService,
  });

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
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                )
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_outline, size: 70),
                  Text(name, style: TextStyle(fontSize: 30)),
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text('Dashboard Programs'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const TrainingProgramScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Dashboard Values'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DisplayValuesScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Progress Tracking'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Sign out'),
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
    );
  }
}