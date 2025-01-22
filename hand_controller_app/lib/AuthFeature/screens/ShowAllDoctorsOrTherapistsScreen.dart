import 'package:flutter/material.dart';
import 'package:hand_controller_app/ProgressTrackingFeature/widgets/DoneProgramContainerWidget.dart';
import 'package:hand_controller_app/ProgressTrackingFeature/widgets/ProgressTrackingDashboardDrawer.dart';
import '../../AuthFeature/services/AuthService.dart';
import '../../AuthFeature/services/UserService.dart';
import '../../AlertDialogs/ExitDialogWidget.dart';
import '../../GlobalThemeData.dart';
import '../../TrainingProgramsFeature/models/TrainingProgram.dart';

class ShowAllDoctorsOrTherapistsScreen extends StatefulWidget {
  const ShowAllDoctorsOrTherapistsScreen({Key? key}) : super(key: key);

  @override
  _ShowAllDoctorsOrTherapistsScreenState createState() =>
      _ShowAllDoctorsOrTherapistsScreenState();
}

class _ShowAllDoctorsOrTherapistsScreenState
    extends State<ShowAllDoctorsOrTherapistsScreen> {
  final UserService userService = UserService();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [CustomTheme.mainColor2, CustomTheme.mainColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            )
        )
    );
  }
}
