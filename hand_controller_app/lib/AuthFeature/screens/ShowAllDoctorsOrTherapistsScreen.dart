import 'package:flutter/material.dart';
import 'package:hand_controller_app/AuthFeature/models/Doctor.dart';
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

  late Future<void> _fetchDoctorsFuture;

  late List<Doctor> doctors;
  List<Doctor> filteredDoctors = [];
  List<bool> _isExpandedList = [];
  TextEditingController searchController = TextEditingController();

  bool _isFilterTileExpended = false;

  late String userId;

  String _searchByField = 'name'; // Default search by
  String _orderByField = 'name'; // Default order by
  bool _isAscending = true; // Default sorting order
  String _searchedString = ''; // Search text entered

  @override
  void initState() {
    super.initState();
    _fetchDoctorsFuture = fetchDoctors();
  }

  void _applyFilters() {
    setState(() {
      filteredDoctors = doctors.where((doctor) {
        String valueToSearch = '';
        switch (_searchByField) {
          case 'name':
            valueToSearch = doctor.name;
            break;
          case 'specialization':
            valueToSearch = doctor.specialization;
            break;
        }
        return valueToSearch.toLowerCase().contains(_searchedString.toLowerCase());
      }).toList();

      if (_orderByField.isNotEmpty) {
        filteredDoctors.sort((a, b) {
          var valueA = '';
          var valueB = '';
          switch (_orderByField) {
            case 'name':
              valueA = a.name.toLowerCase();
              valueB = b.name.toLowerCase();
              break;
            case 'rating':
              valueA = a.rating.toString();
              valueB = b.rating.toString();
              break;
          }
          return _isAscending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
        });
      }
    });
  }

  Widget _buildSearchByButton(String field, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _searchByField = field;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: _searchByField == field
              ? CustomTheme.accentColor2
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: _searchByField == field ? Colors.white : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _filterBySearchField(String searchText) {
    setState(() {
      filteredDoctors = doctors.where((doctor) {
        String valueToSearch = '';
        switch (_searchByField) {
          case 'name':
            valueToSearch = doctor.name;
            break;
          case 'specialization':
            valueToSearch = doctor.specialization;
            break;
        }
        return valueToSearch.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    });
  }

  Widget _buildOrderByButton(String field, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_orderByField == field) {
            _isAscending = !_isAscending; // Toggle sorting order
          } else {
            _orderByField = field; // Set the new sort field
            _isAscending = true; // Default to ascending order
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: _orderByField == field
              ? CustomTheme.accentColor2
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: _orderByField == field ? Colors.white : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (_orderByField == field)
              Icon(
                _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchDoctors() async {
    String? uid = await userService.getUserUid();
    if (uid != null) {
      List<dynamic>? doctorsLocal = await userService.getUsersByRole('Doctor');
      if (doctorsLocal.isNotEmpty) {
        setState(() {
          userId = uid;
          doctors = doctorsLocal.cast<Doctor>();
          filteredDoctors = doctors;
        });
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
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: _fetchDoctorsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  CustomTheme.mainColor2,
                                  CustomTheme.mainColor
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: const Center(
                                child: CircularProgressIndicator()));
                      } else {
                        _isExpandedList =
                            List.generate(doctors.length, (index) => false);
                        return showAllDoctorsContentWidget();
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

  Widget showAllDoctorsContentWidget() {
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
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "These are the Doctors / Specialists available",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search doctors...',
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    border: InputBorder.none,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    _searchedString = value;
                    _filterBySearchField(value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: CustomTheme.accentColor4,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  backgroundColor: Colors.transparent,
                  onExpansionChanged: (bool expanded) {
                    setState(() {
                      _isFilterTileExpended = expanded;
                    });
                  },
                  title: const Text(
                    'Filters',
                    style: TextStyle(color: Colors.white),
                  ),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: CustomTheme.accentColor4,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Search by:',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildSearchByButton('name', 'Name'),
                                      _buildSearchByButton('rating', 'Rating'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                const Text(
                                  'Order By:',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildOrderByButton('name', 'Name'),
                                      _buildOrderByButton('rating', 'Rating'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
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
                                      searchController.clear();
                                      filteredDoctors = doctors;
                                      _applyFilters();
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
                                      "Clear All",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color:
                                        Colors.white, // Set text color to white
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
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
                                    onPressed: () {
                                      _applyFilters();
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
                                      "Apply",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Colors.white, // Set text color to white
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = filteredDoctors[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: CustomTheme.accentColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      backgroundColor: Colors.transparent,
                      onExpansionChanged: (bool expanded) {
                        setState(() {
                          _isExpandedList[index] = expanded;
                        });
                      },
                      title: Text(
                        doctor.name,
                        style: TextStyle(color: Colors.white),
                      ),
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: CustomTheme.accentColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Specialization:',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  doctor.specialization,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                                SizedBox(height: 8),
                                const Text(
                                  'Rating:',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  doctor.rating.toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                                SizedBox(height: 8),
                                const Text(
                                  'Email:',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  doctor.email,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
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
                                        userService.updateUserField(userId, 'doctorId', doctor.uid);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        elevation: 0, // Remove elevation
                                      ),
                                      child: const Text(
                                        "Choose",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors
                                              .white, // Set text color to white
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
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
