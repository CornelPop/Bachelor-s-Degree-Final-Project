import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hand_controller_app/AlertDialogs/ErrorDialogWidget.dart';
import 'package:hand_controller_app/AuthFeature/models/Patient.dart';
import 'package:hand_controller_app/AuthFeature/services/SharedPrefService.dart';
import 'package:hand_controller_app/ProfileFeature/models/MedicalHistory.dart';
import 'package:hand_controller_app/ProfileFeature/services/ConsultationService.dart';
import 'package:hand_controller_app/ProfileFeature/services/RatingService.dart';
import 'package:hand_controller_app/ProfileFeature/widgets/ProfileDashboardDrawer.dart';
import 'package:hand_controller_app/ProfileFeature/widgets/ProfileDoctorContentWidget.dart';
import 'package:hand_controller_app/TrainingProgramsFeature/screens/EntireMedicalHistoryScreen.dart';
import '../../AuthFeature/services/AuthService.dart';
import '../../AuthFeature/services/UserService.dart';
import '../../AlertDialogs/ExitDialogWidget.dart';
import '../../GlobalThemeData.dart';
import '../widgets/EntireMedicalHistoryContentWidget.dart';

class ConsultationDetailsScreen extends StatefulWidget {
  final String doctorId;
  final Patient patient;
  final bool create;

  const ConsultationDetailsScreen(
      {super.key, required this.patient, required this.doctorId, required this.create});

  @override
  _ConsultationDetailsScreenState createState() =>
      _ConsultationDetailsScreenState();
}

class _ConsultationDetailsScreenState extends State<ConsultationDetailsScreen> {
  final ConsultationService consultationService = ConsultationService();

  DateTime? _selectedDate;

  final TextEditingController dateController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController treatmentPlanController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            CustomTheme.mainColor2,
                            CustomTheme.mainColor
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            children: [
                              SizedBox(height: 20,),
                              const Text(
                                'Create consultation',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: CustomTheme.secondaryColor,
                                ),
                              ),
                              SizedBox(height: 30),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      CustomTheme.accentColor4,
                                      CustomTheme.accentColor2
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2), // Shadow color
                                      blurRadius: 20, // Blur radius
                                      offset: Offset(0, 0), // Offset of the shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: TextFormField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                    labelText: widget.patient.name,
                                    prefixIcon: Icon(Icons.account_circle, color: Colors.white),
                                    border: InputBorder.none,
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 20),
                              InkWell(
                                onTap: () {
                                  _selectDate(context);
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        CustomTheme.accentColor4,
                                        CustomTheme.accentColor2
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2), // Shadow color
                                        blurRadius: 20, // Blur radius
                                        offset: Offset(0, 0), // Offset of the shadow
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: TextFormField(
                                    enabled: false,
                                    controller: dateController,
                                    decoration: InputDecoration(
                                      labelText: 'Date',
                                      prefixIcon: Icon(Icons.calendar_month, color: Colors.white),
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(color: Colors.white),
                                    ),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      CustomTheme.accentColor4,
                                      CustomTheme.accentColor2
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2), // Shadow color
                                      blurRadius: 20, // Blur radius
                                      offset: Offset(0, 0), // Offset of the shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: TextFormField(
                                  controller: titleController,
                                  decoration: InputDecoration(
                                    labelText: 'Title',
                                    prefixIcon: Icon(Icons.title, color: Colors.white),
                                    border: InputBorder.none,
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                height: 140,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      CustomTheme.accentColor4,
                                      CustomTheme.accentColor2
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2), // Shadow color
                                      blurRadius: 20, // Blur radius
                                      offset: Offset(0, 0), // Offset of the shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: TextFormField(
                                  maxLines: 5,
                                  controller: treatmentPlanController,
                                  decoration: InputDecoration(
                                    labelText: 'Treatment plan',
                                    prefixIcon: Icon(Icons.content_paste, color: Colors.white),
                                    border: InputBorder.none,
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                height: 140,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      CustomTheme.accentColor4,
                                      CustomTheme.accentColor2
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2), // Shadow color
                                      blurRadius: 20, // Blur radius
                                      offset: Offset(0, 0), // Offset of the shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: TextFormField(
                                  maxLines: 5,
                                  controller: notesController,
                                  decoration: InputDecoration(
                                    labelText: 'Notes',
                                    prefixIcon: Icon(Icons.notes, color: Colors.white),
                                    border: InputBorder.none,
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 40,),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      CustomTheme.accentColor4,
                                      CustomTheme.accentColor2
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2), // Shadow color
                                      blurRadius: 20, // Blur radius
                                      offset: Offset(0, 0), // Offset of the shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    print('object');

                                    String errors = '';
                                    if (dateController.text.isEmpty) {
                                      errors += 'Please enter a date\n';
                                    }

                                    if (titleController.text.isEmpty) {
                                      errors += 'Please enter a title\n';
                                    }

                                    if (treatmentPlanController.text.isEmpty) {
                                      errors += 'Please enter a Treatment Plan\n';
                                    }

                                    if (notesController.text.isEmpty) {
                                      errors += 'Please enter some notes\n';
                                    }

                                    if (errors.isNotEmpty) {
                                      ErrorDialogWidget(message: errors.trim())
                                          .showErrorDialog(context);
                                      return;
                                    } else {

                                      consultationService.addConsultation(Consultation(consultationId: '',
                                          doctorId: widget.doctorId,
                                          patientId: widget.patient.uid,
                                          date: dateController.text,
                                          title: titleController.text,
                                          notes: notesController.text,
                                          treatmentPlan: treatmentPlanController.text));
                                    }

                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => EntireMedicalHistoryScreen(patient: widget.patient),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shadowColor: Colors.transparent,
                                    primary: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30,),
                            ],
                          ),
                        ),
                      )
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dateController.text = '${_selectedDate!.toLocal()}'.split(' ')[0];
      });
    }
  }
}
