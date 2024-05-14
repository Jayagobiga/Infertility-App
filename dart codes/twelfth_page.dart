import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infertilityapp/cycle.dart';
import 'package:infertilityapp/eleventh_page.dart';
import 'package:infertilityapp/graph.dart';
import 'dart:convert';
import 'package:infertilityapp/medications.dart';
import 'package:infertilityapp/reports.dart';
import 'package:infertilityapp/spouse.dart';
import 'package:infertilityapp/third_page.dart';
import 'package:infertilityapp/viewadvice2.dart';
import 'package:infertilityapp/viewstatus.dart';

class TwelfthPage extends StatefulWidget {
  final String userId;
  final String name;
  final int dayDifference;

  TwelfthPage({required this.userId, required this.name,required this.dayDifference});

  @override
  _TwelfthPageState createState() => _TwelfthPageState();
}

class _TwelfthPageState extends State<TwelfthPage> {
  late TextEditingController mobileNumberController;
  late TextEditingController yearOfMarriageController;
  late TextEditingController ageController;
  late TextEditingController genderController;
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController addressController;
  late TextEditingController bloodGroupController;
  late TextEditingController medicalHistoryController;
  List<Map<String, dynamic>> medications = [];
  late String imageUrl = '';

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    mobileNumberController = TextEditingController();
    yearOfMarriageController = TextEditingController();
    ageController = TextEditingController();
    genderController = TextEditingController();
    heightController = TextEditingController();
    weightController = TextEditingController();
    addressController = TextEditingController();
    bloodGroupController = TextEditingController();
    medicalHistoryController = TextEditingController();
    fetchMedications(widget.userId);
    fetchData();
  }

  @override
  void dispose() {
    // Dispose controllers
    mobileNumberController.dispose();
    yearOfMarriageController.dispose();
    ageController.dispose();
    genderController.dispose();
    heightController.dispose();
    weightController.dispose();
    addressController.dispose();
    bloodGroupController.dispose();
    medicalHistoryController.dispose();
    super.dispose();
  }


  Future<void> fetchData() async {
    final response = await http.post(
      Uri.parse('http://192.168.1.27:80/infertility/viewpatientdetails.php'),
      body: {'userId': widget.userId},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status']) {
        setState(() {
          mobileNumberController.text = data['patientDetails']['ContactNo'];
          yearOfMarriageController.text = data['patientDetails']['Marriageyear'];
          ageController.text = data['patientDetails']['Age'];
          genderController.text = data['patientDetails']['Gender'];
          heightController.text = data['patientDetails']['Height'];
          weightController.text = data['patientDetails']['Weight'];
          addressController.text = data['patientDetails']['Address'];
          bloodGroupController.text = data['patientDetails']['Bloodgroup'];
          medicalHistoryController.text = data['patientDetails']['Medicalhistory'];
          final image = data['patientDetails']['image'];
          if (image != null && image.isNotEmpty) {
            imageUrl = image.startsWith('http') ? image : 'http://192.168.1.27:80/infertility/$image';
          } else {
            imageUrl = ''; // Set imageUrl to empty if image is null or empty
          }
        });
        print('Image fetched successfully'); // Print statement
      } else {
        print(data['message']);
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  }


  Future<void> fetchMedications(String userId) async {
    try {
      var response = await http.post(
        Uri.parse('http://192.168.1.27:80/infertility/viewmedicaldetails.php'),
        body: {'userid': userId},
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status']) {
          // Sort the medication details by date
          List<Map<String, dynamic>> sortedMedications = List<Map<String, dynamic>>.from(jsonData['patientDetails']);
          sortedMedications.sort((a, b) => b['date'].compareTo(a['date']));
          // Take only the latest 5 medication details
          setState(() {
            medications= sortedMedications.take(5).toList();
          });
        } else {
          print(jsonData['message']);
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => EleventhPage(userId: widget.userId,dayDifference: widget.dayDifference,)),
          ModalRoute.withName('/'),
        );
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            backgroundColor: Color(0xffed4662),
            leading: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EleventhPage(userId: widget.userId, dayDifference: widget.dayDifference)),
                );
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 30,
                color: Colors.black,
              ),
            ),
            title: Row(
              children: [
                SizedBox(width: 1),
                Text(
                  'Patient Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            automaticallyImplyLeading: true,
            actions: [
              GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();// Open drawer when menu icon is tapped
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset(
                    'assets/menu.png',
                    width: 30,
                    height: AppBar().preferredSize.height,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
        drawer: Container(
          height: 650,
          width: 260,
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 100, // Setting height of the drawer header
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color:Colors.pink[100],
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context); // Close the drawer
                          },
                          child: Image.asset(
                            'assets/arrow.png', // Path to your image asset
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          widget.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        Image.asset(
                          'assets/pen.png', // Path to your image asset
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/medications.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  title: Text('Medications'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MedicationsPage(userId: widget.userId, name: widget.name,dayDifference: widget.dayDifference)),
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/report.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  title: Text('View Reports'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReportsPage(userId: widget.userId, name: widget.name,dayDifference: widget.dayDifference)),
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/graph.png', // Path to your image asset for Item 1
                    width: 30, // Set width of the image
                    height: 30, // Set height of the image
                    fit: BoxFit.contain, // Adjust image fit
                  ),
                  title: Text('View Graph'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GraphPage(userId: widget.userId,name:widget.name,dayDifference: widget.dayDifference)), // Replace 'MedicationsPage' with your actual page widget
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/spouse.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  title: Text('Spouse Details'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SpousePage(userId: widget.userId, name: widget.name)),
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/status.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  title: Text('View Status'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewStatusPage(userId: widget.userId)),
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/advice.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  title: Text('View Advice'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewAdvicePage2(userId: widget.userId, name: widget.name,dayDifference:widget.dayDifference)),
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/cycle.png', // Path to your image asset for Item 5
                    width: 30, // Set width of the image
                    height: 30, // Set height of the image
                    fit: BoxFit.contain, // Adjust image fit
                  ),
                  title: Text('Cycle Update'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CyclePage(dayDifference: widget.dayDifference, userId: widget.userId)),
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/logout.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  title: Text('Logout'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ThirdPage()),
                    );// Add logout logic here
                  },
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Centered Placeholder for image
              Center(
                child: imageUrl.isNotEmpty
                    ? Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 2, // Adjust the width of the border as needed
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 70, // Adjust the radius of the CircleAvatar as needed
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                )
                    : CircularProgressIndicator(), // Placeholder for image
              ),
              SizedBox(height: 20), // Adjust height as needed

              // Name row
              Row(
                children: [
                  Text(
                    'Name',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 100),
                  Container(
                    width: 200,
                    height: 33,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: TextEditingController(text: widget.name),
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ],
              ),
              // Mobile Number row
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Mobile Number',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      width: 200,
                      height: 33,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                      ),
                      child: TextField(
                        controller: mobileNumberController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Year of Marriage row
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Year of Marriage',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      width: 200,
                      height: 33,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                      ),
                      child: TextField(
                        controller: yearOfMarriageController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Add rows for other fetched data here...
              SizedBox(height: 10),
              // Blood Group row
              Row(
                children: [
                  Text(
                    'Blood Group',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 45),
                  Container(
                    width: 200,
                    height: 33,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: bloodGroupController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Age and Gender row
              Row(
                children: [
                  Text(
                    'Age',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 40),
                  Container(
                    width: 80,
                    height: 33,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: ageController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Gender',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 96,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: genderController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ],
              ),
              // Height and Weight row
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Height',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 17),
                  Container(
                    width: 80,
                    height: 33,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: heightController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Weight',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 96,
                    height: 33,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: weightController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ],
              ),
              // Address row
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Address',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 350,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: addressController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                  // Medical History row
                  SizedBox(height: 10),
                  Text(
                    'Medical History',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 350,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: medicalHistoryController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Medications section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Widgets for displaying patient details fetched from API
                      SizedBox(height: 20),
                      Text('Medications', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      // ListView for displaying medications
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: medications.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom:0),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Medicine Name: ${medications[index]['MedicineName']}', style: TextStyle(fontSize: 16)),
                                  Text('Quantity: ${medications[index]['quantity']}', style: TextStyle(fontSize: 16)),
                                  Text('Timing: ${medications[index]['Time']}', style: TextStyle(fontSize: 16)),
                                  Text('Label: ${medications[index]['label']}', style: TextStyle(fontSize: 16)),
                                  Text('Date: ${medications[index]['date']}', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
    ),
      ],),
    ),backgroundColor: Color(0xfffddbdc),
      ),
    );
  }
}