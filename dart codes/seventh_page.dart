import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'eight_page.dart';

class SeventhPage extends StatefulWidget {
  final String? userId;
  final int dayDifference;

  SeventhPage({required this.userId, required this.dayDifference});

  @override
  _SeventhPageState createState() => _SeventhPageState();
}

class _SeventhPageState extends State<SeventhPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _marriageYearController = TextEditingController();
  final TextEditingController _bloodgroupController = TextEditingController();
  final TextEditingController _medicalHistoryController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  File? _imageFile;
  final picker = ImagePicker();

  Future<void> _getImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose Image Source"),
          content: Text("Do you want to pick image from camera or gallery?"),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final pickedFile = await picker.getImage(source: ImageSource.camera);
                _setImageFile(pickedFile);
              },
              child: Text("Camera"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final pickedFile = await picker.getImage(source: ImageSource.gallery);
                _setImageFile(pickedFile);
              },
              child: Text("Gallery"),
            ),
          ],
        );
      },
    );
  }

  void _setImageFile(PickedFile? pickedFile) {
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> sendDataToBackend() async {
    var url = 'http://192.168.1.27:80/infertility/addpatient.php';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['userid'] = widget.userId!;
    request.fields['name'] = _nameController.text;
    request.fields['contactno'] = _contactNoController.text;
    request.fields['age'] = _ageController.text;
    request.fields['gender'] = _genderController.text;
    request.fields['height'] = _heightController.text;
    request.fields['weight'] = _weightController.text;
    request.fields['address'] = _addressController.text;
    request.fields['marriageyear'] = _marriageYearController.text;
    request.fields['bloodgroup'] = _bloodgroupController.text;
    request.fields['medicalhistory'] = _medicalHistoryController.text;

    if (_imageFile != null) {
      var pic = await http.MultipartFile.fromPath("image", _imageFile!.path);
      request.files.add(pic);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var data = jsonDecode(responseData);
      if (data['status']) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EightPage(userId: widget.userId ?? '', dayDifference: widget.dayDifference)),
        );
      } else {
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
          'Add Patient',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back_ios,
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
              Center(
                child: GestureDetector(
                  onTap: _getImage,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Change to circle shape
                      color: Colors.white,
                      image: _imageFile != null
                          ? DecorationImage(
                        image: FileImage(_imageFile!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: _imageFile == null
                        ? Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200], // Background color of circle
                      ),
                      child: Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                    )
                        : null,
                  ),
                ),
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
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'ID',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 133),
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: TextEditingController(text: widget.userId),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Mobile Number',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 20),
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
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Year of Marriage',
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
                    child: DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                      items: List.generate(
                        DateTime.now().year - 1969,
                            (index) => DropdownMenuItem<int>(
                          value: DateTime.now().year - index,
                          child: Text((DateTime.now().year - index).toString()),
                        ),
                      ),
                        onChanged: (int? value) {
                          _marriageYearController.text = value?.toString() ?? '';
                          print('Selected year: $value');
                        }
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
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
              SizedBox(height: 10),
              Row(
                  children: [
                    Text(
                      'Age',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 40),
                    Container(
                      width: 80,
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
                    SizedBox(width: 10),
                    SizedBox(width: 10),
                    Text(
                      'Gender',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 20),
                    Container(
                      width: 95,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          items: [
                            DropdownMenuItem<String>(
                              value: 'Female',
                              child: Text('Female'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Other',
                              child: Text('Other'),
                            ),
                          ],
                          onChanged: (String? value) {
                            _genderController.text = value ?? '';// Handle the selected gender here
                            print('Selected Gender: $value');
                          },
                        ),
                      ),
                    ),
                  ]
              ),
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
                      controller: _heightController,
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
                  SizedBox(width: 40),
                  Container(
                    width: 75,
                    height: 33,
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
              SizedBox(height: 20),
              Text(
                'Address',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              // Adjust spacing between the Text and the Container
              Container(
                width: 350,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                child: TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
              SizedBox(height: 10),
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
                  controller: _medicalHistoryController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: GestureDetector(
            onTap: () async {
              await sendDataToBackend();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'NEXT',
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
      backgroundColor: Color(0xfffddbdc),
    );
  }
}