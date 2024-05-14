import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infertilityapp/alogin.dart';
import 'second_page.dart';
import 'comman.dart';
import 'dart:async';

class Admin extends StatefulWidget {

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final TextEditingController passwordController = TextEditingController();
  final String adminId = '1920';
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });

    // Automatically hide the password after 2 seconds
    Timer(Duration(seconds:1), () {
      setState(() {
        _isPasswordVisible = false;
      });
    });
  }

  get userId => userId; // Admin ID constant

  Future<void> loginAdmin() async {
    final Uri uri = Uri.parse(adminlogin);
    final Map<String, dynamic> requestData = {
      'dr_userid': adminId,
      'password': passwordController.text,
    };

    try {
      final http.Response response = await http.post(
        uri,
        body: json.encode(requestData),
        headers: {'Content-Type': 'application/json'},
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        // Navigate to admin login page if login is successful
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ALogin()), // Navigate to admin login page
        );
      } else {
        // Handle login failure
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Invalid email or password.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to AdminPage when back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SecondPage()),
        );
        return false; // Prevent default back button behavior
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
                    MaterialPageRoute(builder: (context) => SecondPage()), // Navigate to the next page
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_back_ios, // Path to your image asset
                    size: 25,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:60.0),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          child: Image.asset(
                            'assets/woman.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Admin ',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xffed4662),
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height:40),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Admin id',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextField(
                          controller: TextEditingController(text: adminId),
                          enabled: false,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextField(
                            controller: passwordController,
                            obscureText: !_isPasswordVisible,
                            style: TextStyle(color: Colors.black), // Set text color to black
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white, // Set background color to white
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                                onPressed: _togglePasswordVisibility,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.black), // Set border color to black
                              ),
                            ),
                          ),
                        SizedBox(height:40),
                        Container(
                          height: 50,
                          width: 130,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              side: MaterialStateProperty.all(BorderSide(width: 1,color: Color(0xffed4662))),
                              backgroundColor: MaterialStateProperty.all(Color(0xffed4662)),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                            ),
                            onPressed: () {
                              loginAdmin(); // Call loginAdmin function when button is pressed
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Color(0xfffddbdc),
      ),
    );
  }
}
