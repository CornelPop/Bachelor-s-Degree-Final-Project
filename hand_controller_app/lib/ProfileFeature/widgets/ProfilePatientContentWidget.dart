import 'package:flutter/material.dart';
import 'package:hand_controller_app/AuthFeature/screens/ShowAllDoctorsOrTherapistsScreen.dart';
import 'package:hand_controller_app/ProfileFeature/services/PdfProfileService.dart';
import 'package:hand_controller_app/ProfileFeature/widgets/DoneMedicalHistoryContainer.dart';
import '../../AuthFeature/services/AuthService.dart';

import '../../AuthFeature/services/UserService.dart';
import '../../GlobalThemeData.dart';
import '../models/MedicalHistory.dart';

class ProfilePatientContentWidget extends StatefulWidget {
  const ProfilePatientContentWidget(
      {super.key,
      required this.name,
      required this.email,
      required this.consultations,
      required this.authService,
      required this.userService});

  final String name;
  final String email;
  final List<Consultation> consultations;
  final AuthService authService;
  final UserService userService;

  @override
  _ProfilePatientContentWidgetState createState() =>
      _ProfilePatientContentWidgetState();
}
class _ProfilePatientContentWidgetState
    extends State<ProfilePatientContentWidget> {

  final PdfProfileService pdfProfileService = PdfProfileService();
  List<bool> _isExpandedList = [];

  @override
  void initState() {
    super.initState();
    _isExpandedList = List.generate(widget.consultations.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
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
              'Patient',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Assigned Doctor / Therapist',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: CustomTheme.accentColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Email',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Rating',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ShowAllDoctorsOrTherapistsScreen()),
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
                    'Choose Doctor / Therapist',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Medical History',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.consultations.length,
                itemBuilder: (context, index) {
                  final medicalHistory = widget.consultations[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: CustomTheme.accentColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.only(left: 15),
                      backgroundColor: Colors.transparent,
                      onExpansionChanged: (bool expanded) {
                        setState(() {
                          _isExpandedList[index] = expanded;
                        });
                      },
                      title: Text(
                        medicalHistory.title,
                        style: TextStyle(color: Colors.white),
                      ),
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: CustomTheme.accentColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Date:',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  medicalHistory.date,
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                SizedBox(height: 8),
                                const Text(
                                  'Plan:',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  medicalHistory.treatmentPlan,
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                SizedBox(height: 8),
                                const Text(
                                  'Notes:',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  medicalHistory.notes,
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
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
                                      onPressed: () async {
                                        pdfProfileService.generateAndSavePDFSpecificConsultation(widget.name, medicalHistory);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        elevation: 0, // Remove elevation
                                      ),
                                      child: const Text(
                                        "Download Consultation",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white, // Set text color to white
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
