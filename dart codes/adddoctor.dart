import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddDoctor extends StatefulWidget {
  final String drUserId;

  AddDoctor({required this.drUserId});

  @override
  _AddDoctorState createState() => _AddDoctorState();
}

class _AddDoctorState extends State<AddDoctor> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController specController = TextEditingController();
  File? _image;

  Future getImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.camera);
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: Text('Gallery'),
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    ).then((source) async {
      if (source != null) {
        final pickedFile = await ImagePicker().getImage(
          source: source,
        );

        setState(() {
          if (pickedFile != null) {
            _image = File(pickedFile.path);
          } else {
            print('No image selected.');
          }
        });
      }
    });
  }


  Future<void> submitData() async {
    final uri = Uri.parse('http://192.168.1.27:80/infertility/adddoctor.php');

    var request = http.MultipartRequest('POST', uri)
      ..fields['dr_userid'] = widget.drUserId
      ..fields['dr_name'] = nameController.text
      ..fields['contact_no'] = phoneController.text
      ..fields['email'] = emailController.text
      ..fields['designation'] = specController.text;

    if (_image != null) {
      request.files.add(
          await http.MultipartFile.fromPath('doctorimage', _image!.path));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      // Success
      print('Doctor details added successfully.');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Doctor details added successfully.'),
        backgroundColor: Colors.grey,
      ));
      // Navigate to previous page
      Navigator.pop(context);
    } else {
      // Error
      print('Error adding doctor details.');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error adding doctor details.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffed4662),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Text(
              "Add Doctor",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            GestureDetector(
              onTap: getImage,
              child: CircleAvatar(
                key: UniqueKey(), // Add a UniqueKey
                radius: 70,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null ? Icon(Icons.add_a_photo) : null,
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              padding: EdgeInsets.symmetric(horizontal: 95, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.pink[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Text(
                    '${widget.drUserId}',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.pink[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                textAlign: TextAlign.center,
                controller: nameController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Enter Name',
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.pink[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                textAlign: TextAlign.center,
                controller: emailController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Enter Email',
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.pink[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                textAlign: TextAlign.center,
                controller: phoneController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Enter Phone',
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.pink[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                textAlign: TextAlign.center,
                controller: specController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Enter Specification',
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 145),
              child: ElevatedButton(
                onPressed: submitData,
                child: Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: Text('Submit',
                  style:TextStyle(color: Colors.black)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
