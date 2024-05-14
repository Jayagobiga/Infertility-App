import 'package:flutter/material.dart';
import 'package:infertilityapp/twelfth_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SpousePage extends StatefulWidget {
  final String userId;
  final String name;

  SpousePage({required this.userId, required this.name});

  @override
  _SpousePageState createState() => _SpousePageState();
}

class _SpousePageState extends State<SpousePage> {
  late TextEditingController nameController;
  late TextEditingController mobileNumberController;
  late TextEditingController bloodGroupController;
  late TextEditingController weightController;
  late TextEditingController heightController;
  late TextEditingController ageController;
  late TextEditingController medicalHistoryController;
  late TextEditingController specificationsController; // Added

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    nameController = TextEditingController();
    mobileNumberController = TextEditingController();
    bloodGroupController = TextEditingController();
    ageController = TextEditingController();
    heightController = TextEditingController();
    weightController = TextEditingController();
    medicalHistoryController = TextEditingController();
    specificationsController = TextEditingController(); // Added
    fetchData();
  }

  @override
  void dispose() {
    // Dispose controllers
    nameController.dispose();
    mobileNumberController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    medicalHistoryController.dispose();
    specificationsController.dispose(); // Added
    super.dispose();
  }

  Future<void> fetchData() async {
    // Fetch spouse details
    final spouseResponse = await http.post(
      Uri.parse('http://192.168.1.27:80/infertility/viewspousedetails.php'),
      body: {'userid': widget.userId, 'name': widget.name},
    );

    // Fetch specifications
    final specificationsResponse = await http.post(
      Uri.parse('http://192.168.1.27:80/infertility/viewspecifications.php'),
      body: {'userid': widget.userId},
    );

    if (spouseResponse.statusCode == 200 && specificationsResponse.statusCode == 200) {
      final spouseData = jsonDecode(spouseResponse.body);
      final specificationsData = jsonDecode(specificationsResponse.body);

      if (spouseData['status'] && specificationsData['status']) {
        setState(() {
          nameController.text = spouseData['spouseDetails']['Name'];
          mobileNumberController.text = spouseData['spouseDetails']['Contactnumber'];
          bloodGroupController.text = spouseData['spouseDetails']['Bloodgroup'];
          heightController.text = spouseData['spouseDetails']['Height'];
          weightController.text = spouseData['spouseDetails']['Weight'];
          ageController.text = spouseData['spouseDetails']['Age'];
          medicalHistoryController.text = spouseData['spouseDetails']['Medicalhistory'];
          specificationsController.text = specificationsData['specifications'][0]['Specifications'];
        });
      } else {
        print('Error: ${spouseData['message']}');
        print('Error: ${specificationsData['message']}');
      }
    } else {
      print('Error fetching spouse details: ${spouseResponse.statusCode}');
      print('Error fetching specifications: ${specificationsResponse.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffed4662),
        title: Text(
          'View Spouse',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(
                context); // Navigate to the previous page (SixthPage)
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back_ios, // Path to your image asset
              size: 30,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    controller: nameController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Contact Number',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
                Container(
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
              ],
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Weight',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 92),
                Container(
                  width: 200,
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
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Height',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 94),
                Container(
                  width: 200,
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
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Age',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 117),
                Container(
                  width: 200,
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
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
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
                Text(
                  'Specifications',
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
                    controller: specificationsController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xfffddbdc),
    );
  }
}
