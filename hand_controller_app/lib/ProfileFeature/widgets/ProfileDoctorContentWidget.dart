import 'dart:ffi';

import 'package:flutter/material.dart';

import '../../AuthFeature/services/AuthService.dart';
import '../../AuthFeature/services/UserService.dart';
import '../../GlobalThemeData.dart';

class ProfileDoctorContentWidget extends StatefulWidget {
  const ProfileDoctorContentWidget({super.key, required this.name, required this.email, required this.authService, required this.userService});

  final String name;
  final String email;
  final AuthService authService;
  final UserService userService;

  @override
  _ProfileDoctorContentWidgetState createState() => _ProfileDoctorContentWidgetState();
}

class _ProfileDoctorContentWidgetState extends State<ProfileDoctorContentWidget> {

  Widget build(BuildContext context)
  {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [CustomTheme.mainColor2, CustomTheme.mainColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50, color: CustomTheme.mainColor),
            ),
            const SizedBox(height: 10),
            Text(
              widget.name,
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Text(
              widget.email,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 5),
            Text(
              'Doctor',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            Text(
              'Profile Page content goes here',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}