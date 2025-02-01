import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hand_controller_app/AuthFeature/services/SharedPrefService.dart';
import 'package:hand_controller_app/ProfileFeature/models/MedicalHistory.dart';
import 'package:hand_controller_app/ProfileFeature/services/ConsultationService.dart';
import 'package:hand_controller_app/ProfileFeature/services/RatingService.dart';
import 'package:hand_controller_app/ProfileFeature/widgets/ProfileDashboardDrawer.dart';
import 'package:hand_controller_app/ProfileFeature/widgets/ProfileDoctorContentWidget.dart';
import '../../AuthFeature/services/AuthService.dart';
import '../../AuthFeature/services/UserService.dart';
import '../../AlertDialogs/ExitDialogWidget.dart';
import '../../GlobalThemeData.dart';
import '../models/Rating.dart';
import '../widgets/ProfilePatientContentWidget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final UserService userService = UserService();
  final ConsultationService consultationService = ConsultationService();
  final AuthService authService = AuthService();
  final RatingService ratingService = RatingService();

  String userId = '';
  String name = '';
  String email = '';
  String role = '';

  String assignedDoctorId = '';
  String assignedDoctorName = '';
  String assignedDoctorEmail = '';
  String assignedDoctorPhoneNumber = '';
  String assignedDoctorSpecialization = '';
  List<Consultation> consultations = [];
  List<Rating> ratings = [];

  late Future<void> _fetchUserDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchUserDataFuture = fetchUserData();
  }

  Future<void> fetchUserData() async {
    String? uid = await userService.getUserUid();
    if (uid != null) {
      Map<String, dynamic>? userData = await userService.getUserData(uid);
      if (userData != null) {

        List<Consultation> consultationsLocal = await consultationService.getConsultationsByPatientIdAndDoctorId(uid, userData['doctorId'] as String);

        setState(() {
          userId = uid;
          name = userData['name'] as String;
          email = userData['email'] as String;
          role = userData['role'] as String;
          consultations = consultationsLocal;
          assignedDoctorId = userData['doctorId'] as String;
        });

        Map<String, dynamic>? assignedDoctorData = await userService.getUserData(userData['doctorId'] as String);
        List<Rating> ratingsLocal = await ratingService.getRatingsByDoctorId(userData['doctorId'] as String);

        if (assignedDoctorData != null) {
          assignedDoctorName = assignedDoctorData['name'] as String;
          assignedDoctorEmail = assignedDoctorData['email'] as String;
          assignedDoctorPhoneNumber = assignedDoctorData['phoneNumber'] as String;
          assignedDoctorSpecialization = assignedDoctorData['specialization'] as String;
          ratings = ratingsLocal;
        }

      } else {
        print('No user data found.');
      }
    } else {
      print('No UID found in SharedPreferences.');
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await ExitDialog.showExitDialog(context);
      },
      child: Scaffold(
        drawer: FutureBuilder(
          future: _fetchUserDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
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
                  child: const Center(
                      child: CircularProgressIndicator()));
            } else {
              return _buildDrawer();
            }
          },
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [CustomTheme.mainColor2, CustomTheme.mainColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              height: kToolbarHeight + 20,
            ),
            Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  title: const Text('HandHero'),
                  elevation: 0,
                ),
                Expanded(
                  child: FutureBuilder(
                    future: _fetchUserDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [CustomTheme.mainColor2, CustomTheme.mainColor],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: const Center(
                                child: CircularProgressIndicator()));
                      } else {
                        if (role == "Patient") {
                          return ProfilePatientContentWidget(userId: userId,
                            name: name,
                            email: email,
                            consultations: consultations,
                            ratings: ratings,
                            assignedDoctorId: assignedDoctorId,
                            assignedDoctorName: assignedDoctorName,
                            assignedDoctorEmail: assignedDoctorEmail,
                            assignedDoctorPhoneNumber: assignedDoctorPhoneNumber,
                            assignedDoctorSpecialization: assignedDoctorSpecialization,
                            authService: authService,
                            userService: userService,);
                        }
                        else if (role == "Doctor") {
                          return ProfileDoctorContentWidget(name: name,
                            email: email,
                            authService: authService,
                            userService: userService,);
                        }
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ProfileDashboardDrawer _buildDrawer() {
    return ProfileDashboardDrawer(
      name: name,
      email: email,
      authService: authService,
      userService: userService,
    );
  }
}
