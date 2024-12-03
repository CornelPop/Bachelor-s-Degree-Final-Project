import 'package:flutter/material.dart';
import 'package:hand_controller_app/AuthFeature/services/AuthService.dart';
import 'package:hand_controller_app/ProfileFeature/screens/ProfileScreen.dart';
import 'package:hand_controller_app/ProgressTrackingFeature/screens/ProgressTrackingScreen.dart';
import 'package:hand_controller_app/SettingsFeature/screens/SettingsScreen.dart';
import 'package:hand_controller_app/TrainingProgramsFeature/screens/TrainingProgramScreen.dart';

import '../../AuthFeature/screens/SignInScreen.dart';
import '../../AuthFeature/services/UserService.dart';
import '../../DisplayingValuesFeature/screens/DisplayValuesScreen.dart';
import '../../GlobalThemeData.dart';

class ProgressTrackingDashboardDrawer extends StatelessWidget {
  final String name;
  final String email;
  final AuthService authService;
  final UserService userService;

  ProgressTrackingDashboardDrawer({
    Key? key,
    required this.name,
    required this.authService,
    required this.userService,
    required this.email,
  }) : super(key: key);

  Widget buildListTilesTitle(Icon icon, String text) {
    return Row(
      children: [
        icon,
        SizedBox(width: 8), // Add some spacing between the icon and the text
        Text(
          text,
          style: TextStyle(color: Colors.white), // Apply your desired text style
        ),
      ],
    );
  }


  @override
  Drawer build(BuildContext context) {
    return Drawer(
      width: 275,
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
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20)
          )
        ),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(5),
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.person_outline, size: 50, color: Colors.white),
                    SizedBox(width: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(fontSize: 20, color: Colors.white)),
                        SizedBox(height: 10,),
                        Text(email, style:  TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.5))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Divider(color: Colors.white), // Separation line
            ListTile(
              title: buildListTilesTitle(Icon(Icons.dashboard, color: Colors.white), 'Dashboard Programs'),
              onTap: () async {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => TrainingProgramScreen()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
            ListTile(
              title: buildListTilesTitle(Icon(Icons.assessment, color: Colors.white), 'Dashboard Values'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DisplayValuesScreen(),
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ListTile(
                title: buildListTilesTitle(Icon(Icons.track_changes, color: Colors.white), 'Progress Tracking'),
                onTap: () {}
              ),
            ),
            ListTile(
              title: buildListTilesTitle(Icon(Icons.person, color: Colors.white), 'Profile'),
              onTap: () async {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
            ListTile(
              title: buildListTilesTitle(Icon(Icons.settings, color: Colors.white), 'Settings'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: buildListTilesTitle(Icon(Icons.exit_to_app, color: Colors.white), 'Sign out'),
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
