import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'fifth_page.dart'; // Import the fifth page to navigate to it
import 'twelfth_page.dart'; // Import the twelfth page to navigate to it

class EleventhPage extends StatefulWidget {
  final String userId; // Define userId variable
  final int dayDifference;
  // Constructor to receive the userId
  EleventhPage({required this.userId, required this.dayDifference});
  @override
  _EleventhPageState createState() => _EleventhPageState();
}

class _EleventhPageState extends State<EleventhPage> {
  List<dynamic> patients = [];
  List<dynamic> displayedPatients = []; // List to hold displayed patients
  List<dynamic> searchResults = []; // List to hold search results
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch patient data when the widget is initialized
    fetchPatients();
  }

  // Method to fetch patient data from the server
  void fetchPatients() async {
    // Define your API endpoint URL
    String apiUrl = "http://192.168.1.27:80/infertility/patientlist.php";

    try {
      // Make HTTP POST request to fetch patient data
      var response = await http.post(Uri.parse(apiUrl));

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the JSON response
        var data = json.decode(response.body);

        // Extract all patients' details from the response
        List<dynamic> patientsList = data['data'];

        // Take the latest 6 patients for display
        setState(() {
          patients = patientsList;
          displayedPatients = patientsList.reversed.take(6).toList();
        });
      } else {
        // Handle the error
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      // Handle any exceptions
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => FifthPage(userId: widget.userId,dayDifference: widget.dayDifference)),
            ModalRoute.withName('/'),
          );
          return false;
        },
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffed4662),
        automaticallyImplyLeading: false, // Disable automatic leading widget
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FifthPage(
                        userId: widget.userId,
                        dayDifference: widget.dayDifference,
                      )), // Navigate to the fifth page
                );
              },
              child: Icon(
                Icons.arrow_back_ios, // Path to your image asset
                size: 30,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 10), // Add spacing between the image and text
            Text(
              'View Patients',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            height: 70,
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                // Filter the patients list based on the search query
                setState(() {
                  if (value.isEmpty) {
                    // If the search query is empty, display the latest patients
                    displayedPatients = patients.reversed.take(6).toList();
                  } else {
                    // Filter patients by both name and user ID
                    searchResults = patients.where((patient) =>
                    patient['Name']
                        .toLowerCase()
                        .contains(value.toLowerCase()) ||
                        patient['Userid']
                            .toString()
                            .contains(value.toLowerCase())).toList();
                    // Display only older patients when searching
                    displayedPatients = searchResults
                        .where((patient) =>
                    !displayedPatients.contains(patient))
                        .toList();
                  }
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: displayedPatients.length, // Use displayedPatients list here
              itemBuilder: (context, index) {
                return ListTile(
                  title: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/bprofile.png', // Path to your image asset
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 15), // Add spacing between the image and text
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${displayedPatients[index]['Name']}', // Display patient's name
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'User ID: ${displayedPatients[index]['Userid']}', // Display patient's user ID
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.visibility),
                      ],
                    ),
                  ),
                  // Inside the ListTile onTap method in EleventhPage
                  onTap: () {
                    // Get the userId and name of the selected patient
                    String userId =
                    displayedPatients[index]['Userid'].toString();
                    String name = displayedPatients[index]['Name'];

                    // Navigate to the patient's details page and pass the User ID and name as parameters
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TwelfthPage(
                            userId: userId,
                            name: name,
                            dayDifference: widget.dayDifference,
                          )),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xfffddbdc),
    ),
    );
  }
}
