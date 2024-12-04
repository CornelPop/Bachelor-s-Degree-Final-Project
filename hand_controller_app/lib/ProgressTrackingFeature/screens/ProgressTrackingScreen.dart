import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hand_controller_app/ProgressTrackingFeature/services/PdfService.dart';
import 'package:hand_controller_app/ProgressTrackingFeature/widgets/LastMonthTotalNumberByCategoryPieChart.dart';
import 'package:hand_controller_app/ProgressTrackingFeature/widgets/LastWeekTotalNumberLineChart.dart';
import 'package:intl/intl.dart';
import 'package:hand_controller_app/ProgressTrackingFeature/widgets/DoneProgramContainerWidget.dart';
import 'package:hand_controller_app/ProgressTrackingFeature/widgets/ProgressTrackingDashboardDrawer.dart';
import '../../AuthFeature/services/AuthService.dart';
import '../../AuthFeature/services/UserService.dart';
import '../../AlertDialogs/ExitDialogWidget.dart';
import '../../GlobalThemeData.dart';
import '../../TrainingProgramsFeature/models/TrainingProgram.dart';
import '../../TrainingProgramsFeature/widgets/ProgramContainerWidget.dart';
import '../widgets/TrainingDurationStackedBarChart.dart';
import 'ShowAllProgramsScreen.dart';

class ProgressTrackingScreen extends StatefulWidget {
  const ProgressTrackingScreen({super.key});

  @override
  _ProgressTrackingScreenState createState() => _ProgressTrackingScreenState();
}

class _ProgressTrackingScreenState extends State<ProgressTrackingScreen> {
  final UserService userService = UserService();
  final AuthService authService = AuthService();
  final PdfService pdfService = PdfService();

  String name = '';
  String email = '';
  String role = '';
  List<TrainingProgram> completedPrograms = [];
  String _sortBy = 'Date';
  bool _ascending = false;

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
      List<TrainingProgram> programs = await userService.getCompletedPrograms(uid);
      if (userData != null) {
        setState(() async {
          name = userData['name'] as String;
          email = userData['email'] as String;
          role = userData['role'] as String;
          completedPrograms = programs;
          _sortPrograms();
        });
      } else {
        print('No user data found.');
      }
    } else {
      print('No UID found in SharedPreferences.');
    }
  }

  void _sortPrograms() {
    completedPrograms.sort((a, b) {
      int comparison;
      switch (_sortBy) {
        case 'Name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'Duration':
          comparison = a.duration.compareTo(b.duration);
          break;
        case 'Date':
        default:
          comparison = a.date.compareTo(b.date);
      }
      return _ascending ? comparison : -comparison;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await ExitDialog.showExitDialog(context);
      },
      child: Scaffold(
        drawer: _buildDrawer(),
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
                        return progressTrackingContentWidget();
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

  ProgressTrackingDashboardDrawer _buildDrawer() {
    return ProgressTrackingDashboardDrawer(
      name: name,
      email: email,
      authService: authService,
      userService: userService,
    );
  }

  Widget progressTrackingContentWidget() {
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
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Charts to visualize your progress',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 300,
                child: PageView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: PageController(viewportFraction: 1),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return _buildChartCarouselItem(index);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      CustomTheme.accentColor4,
                      CustomTheme.accentColor2,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: Offset(0, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    pdfService.generateAndSavePDF(name, completedPrograms);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_download, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Download Reports',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Training Programs Completed',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: completedPrograms.length > 5 ? 5 : completedPrograms.length,
                    itemBuilder: (context, index) {
                      final program = completedPrograms[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: DoneProgramContainer(
                          program: program,
                          title: program.name,
                          date: 'Done in ${program.date.day} / ${program.date.month} / ${program.date.year}',
                          subtitle: '${program.duration} MINS  ●  ${program.exercises.length} EXERCISES',
                          difficulty: program.category,
                        ),
                      );
                    },
                  ),
                  if (completedPrograms.length > 5)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              CustomTheme.accentColor4,
                              CustomTheme.accentColor2,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: Offset(0, 0),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowAllProgramsScreen(completedPrograms: completedPrograms),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.list, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Show All Training Programs',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCarouselItem(int index) {
    switch (index) {
      case 0:
        return LastMonthTotalNumberByCategoryPieChart(completedPrograms: completedPrograms);
      case 1:
        return LastWeekTotalNumberLineChart(completedPrograms: completedPrograms);
      case 2:
        return TrainingDurationStackedBarChart(completedPrograms: completedPrograms);
      default:
        return Container();
    }
  }
}
