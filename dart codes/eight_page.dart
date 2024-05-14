import 'package:flutter/material.dart';
import 'fifth_page.dart';
import 'ninth_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EightPage extends StatefulWidget {
  final String userId;
  final int dayDifference;

  EightPage({required this.userId,required this.dayDifference});

  @override
  _EightPageState createState() => _EightPageState();
}

class _EightPageState extends State<EightPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bloodgroupController = TextEditingController();
  final TextEditingController _medicalhistoryController = TextEditingController();

  Future<void> sendDataToBackend() async {
    var url = 'http://192.168.1.27:80/infertility/addspouse.php';
    var response = await http.post(Uri.parse(url), body: {
      'userid': widget.userId!,
      'name': _nameController.text,
      'contactno': _contactNoController.text,
      'age': _ageController.text,
      'weight': _weightController.text,
      'height': _heightController.text,
      'bloodgroup': _bloodgroupController.text, // Add bloodgroup field
      'medicalhistory': _medicalhistoryController.text,
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status']) {
        // Data successfully sent to backend
        // Show dialog when NEXT is tapped
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Colors.black),
              ),
              title: Text(
                'Do you have undergone this treatment before?',
                style: TextStyle(fontSize: 18),
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NinthPage(userId: widget.userId,dayDifference: widget.dayDifference)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Yes',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FifthPage(userId:widget.userId, dayDifference: widget.dayDifference)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'No',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        // Error occurred
        // Show error message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(data['message']),
              actions: <Widget>[
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
    } else {
      // Error occurred
      // Show error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to connect to the server. Please try again later.'),
            actions: <Widget>[
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffed4662),
        title: Text(
          'Add Spouse',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Navigate to the previous page (SixthPage)
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    'Contact Number',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: _contactNoController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    'Blood Group',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 45),
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: 'A+',
                          child: Text('A+'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'A-',
                          child: Text('A-'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'B+',
                          child: Text('B+'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'B-',
                          child: Text('B-'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'AB+',
                          child: Text('AB+'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'AB-',
                          child: Text('AB-'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'O+',
                          child: Text('O+'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'O-',
                          child: Text('O-'),
                        ),
                      ],
                      onChanged: (String? value) {
                        _bloodgroupController.text = value ?? '';// Handle the selected blood group here
                        print('Selected blood group: $value');
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    'Weight',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 92),
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: _weightController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    'Height',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 94),
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: _heightController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    'Age',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 117),
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                      items: [
                        DropdownMenuItem<int>(
                          value: 18,
                          child: Text('18'),
                        ),
                        DropdownMenuItem<int>(
                          value: 19,
                          child: Text('19'),
                        ),
                        // Add other ages up to 60+
                        for (int i = 20; i <= 60; i++)
                          DropdownMenuItem<int>(
                            value: i,
                            child: Text(i.toString()),
                          ),
                        DropdownMenuItem<int>(
                          value: 61,
                          child: Text('60+'),
                        ),
                      ],
                      onChanged: (int? value) {
                        _ageController.text = value?.toString() ?? '';// Handle the selected age here
                        print('Selected age: $value');
                      },
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Text(
                    'Medical History',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10), // Adjust spacing between the Text and the Container
                  Container(
                    width: 350,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: _medicalhistoryController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                  SizedBox(height:20),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: GestureDetector(
            onTap: () {
              sendDataToBackend();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SAVE',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}