import 'dart:convert'; // Add this line to import the 'json' library
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Add this line to import the 'http' library
import 'package:infertilityapp/adddoctor.dart';
import 'package:infertilityapp/admin.dart';
import 'package:infertilityapp/second_page.dart';
import 'package:infertilityapp/viewdoctor.dart';

class ALogin extends StatefulWidget {
  @override
  State<ALogin> createState() => _ALoginState();
}

class _ALoginState extends State<ALogin> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double buttonWidth = screenWidth * 0.7;
    double buttonHeight = screenHeight * 0.148;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Admin()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfffddbdc),
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Admin()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 25,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondPage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/logout.png',
                  width: 26,
                  height: 26,
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 5),
              ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                      Size(buttonWidth, buttonHeight)),
                  padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                  backgroundColor: MaterialStateProperty.all(Color(0xffed4662)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  )),
                  elevation: MaterialStateProperty.all(5),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewDoctor()),
                  );
                },
                child: const Text(
                  'View Doctor List',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(height: 80),
              ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                      Size(buttonWidth, buttonHeight)
                  ),
                  padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                  backgroundColor: MaterialStateProperty.all(Color(0xffed4662)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  )),
                  elevation: MaterialStateProperty.all(5),
                ),
                onPressed: () async {
                  // Make the HTTP request to your PHP script
                  final response = await http.post(Uri.parse('http://192.168.1.27:80/infertility/adddocterid.php'));

                  if (response.statusCode == 200) {
                    // Parse the JSON response
                    var jsonData = json.decode(response.body);
                    if (jsonData['status']) {
                      // Extract the dr_userid
                      String drUserId = jsonData['dr_userid'].toString();

                      // Navigate to AddDoctor page with drUserId
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddDoctor(drUserId: drUserId),
                        ),
                      );
                    } else {
                      // Handle the case when status is false
                      print('Error: ${jsonData['message']}');
                    }
                  } else {
                    // Handle HTTP errors
                    print('HTTP Error: ${response.statusCode}');
                  }
                },
                child: Text(
                  'Add Doctor',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Color(0xfffddbdc),
      ),
    );
  }
}
