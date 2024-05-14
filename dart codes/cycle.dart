import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

class CyclePage extends StatefulWidget {
  final int dayDifference; // Define dayDifference variable
  final String userId; // Define userId variable

  CyclePage({Key? key, required this.dayDifference, required this.userId}) : super(key: key); // Accept dayDifference and userId as parameters

  @override
  _CyclePageState createState() => _CyclePageState();
}

class _CyclePageState extends State<CyclePage> {
  String days = '';

  @override
  void initState() {
    super.initState();
    fetchDays();
  }

  Future<void> fetchDays() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.27:80/infertility/nextmonth.php'),
        body: {'userid': widget.userId},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          setState(() {
            days = data['days']['days'];
          });
        } else {
          // Handle error if user not found or other issue
        }
      } else {
        // Handle HTTP error
      }
    } catch (error) {
      // Handle network or other errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffed4662),
        automaticallyImplyLeading: false, // Remove the elevation
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Navigate to the previous page
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
            SizedBox(width: 20), // Add space between image and text
            Text(
              'Cycle Update',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height, // Set height of SingleChildScrollView
          child: Stack(
            children: [
              // Container(
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //       image: AssetImage('assets/background.png'),
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
              Positioned(
                top: kToolbarHeight + 20, // Position it below the app bar with additional space
                left: 45,
                right: 45,
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 70),
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 6), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Patient on:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none, // Remove border line
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height:40 ),
                                Container(
                                  width: 350,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.pink[200],
                                    borderRadius: BorderRadius.circular(15), // Adjust the radius to change the curve
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: Offset(0, 2), // Shadow position, you can adjust as needed
                                      ),
                                    ],
                                  ),
                                  child:Center(
                                    child:Text(
                                  'Day: $days', // Use dayDifference directly
                                    style: TextStyle(
                                        fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom:120,
                left: 30,
                right: 30,
                child: Image.asset(
                  'assets/cyclephoto.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xfffddbdc),
    );
  }
}
