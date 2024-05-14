import 'package:flutter/material.dart';
import 'package:infertilityapp/pplogin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:infertilityapp/fourth_page.dart';
import 'package:infertilityapp/padvice.dart';
import 'package:infertilityapp/pcycle.dart';
import 'package:infertilityapp/pgraph.dart';
import 'package:infertilityapp/pmedication.dart';
import 'package:infertilityapp/pprofile.dart';
import 'package:infertilityapp/preports.dart';
import 'dart:io';

class PLoginPage extends StatefulWidget {
  final String userId;
  final String name;
  final int dayDifference;

  PLoginPage({required this.userId, required this.name, required this.dayDifference});

  @override
  _PLoginPageState createState() => _PLoginPageState();
}

class _PLoginPageState extends State<PLoginPage> {
  String days = '';

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    fetchDays();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      fetchDays();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Uri whatsApp = Uri.parse('http://wasap.my/918903705958');
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => FourthPage()),
          ModalRoute.withName('/'),
        );
        return false;
      },
      child: Scaffold(
        key:_scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xffed4662),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();// Open drawer when menu icon is tapped
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Image.asset(
                        'assets/menu.png',
                        width: 35,
                        height: AppBar().preferredSize.height,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () async {
                      launchUrl(whatsApp);
                    },
                    child: Image.asset(
                      'assets/whats.png',
                      width: 35,
                      height: 35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        drawer: Container(
          height: 550,
          width: 260,
          child:Drawer(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/girlbg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Container(
                      height: 80,
                      child: DrawerHeader(
                        decoration: BoxDecoration(
                          color: Color(0xffed4662),
                        ),
                        child: Text(
                          'Drawer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Image.asset('assets/bprofile.png',width: 40,height: 40), // Profile icon
                      title: Text('Patient Profile'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PProfilePage(userId: widget.userId, name: widget.name, dayDifference: widget.dayDifference)),
                        );
                      },
                    ),
                    ListTile(
                      leading: Image.asset('assets/plus.png', width: 40, height: 40), // Add Reports icon
                      title: Text('Add Reports'),
                      onTap: () {
                        _launchWhatsApp();
                      },
                    ),
                    ListTile(
                      leading: Image.asset('assets/logout.png',width: 40,height: 40), // Logout icon
                      title: Text('Logout'),
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => FourthPage()),
                          ModalRoute.withName('/'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/girlbg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                children: [
                  SizedBox(height:30),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/girl4.png',
                          width: 280,
                          height: 280,
                        ),
                        SizedBox(height:10),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: 'Period Day ',
                                style: TextStyle(
                                   fontWeight: FontWeight.normal,
                                  fontSize: 24,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: ' $days',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 29,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Material(
                          color: Color(0xffed4662),
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PCyclePage(userId: widget.userId, name: widget.name)),
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 9, horizontal: 50),
                              child: Text(
                                'Edit Period Date',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                            onTap: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PAdvicePage(userId: widget.userId)),
                            );

                              },
                              // child: Container(
                              //   width: 95,
                              //   height: 95,
                              //   decoration: BoxDecoration(
                              //     color: Color(0xffffc0cb),
                              //     borderRadius: BorderRadius.circular(15),
                                  // border: Border.all(
                                  //   color: Color(0xffed4662), // Add black color for the border
                                  //   width: 3, // Adjust the width as needed
                                  // ),
                                // ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/advices.png',
                                    width: 70,
                                    height: 80,
                                  ),
                                ),
                                // padding: EdgeInsets.all(20),
                              ),
                            // ),
                            SizedBox(height: 5),
                            Text(
                              'Advices',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffed4662),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width:60),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PReportsPage(userId: widget.userId, name: widget.name, dayDifference: widget.dayDifference)),
                                );
                              },
                              // child: Container(
                              //   width: 95,
                              //   height: 95,
                              //   decoration: BoxDecoration(
                              //     color: Color(0xffffc0cb),
                              //     borderRadius: BorderRadius.circular(15),
                                  // border: Border.all(
                                  //   color: Color(0xffed4662), // Add black color for the border
                                  //   width: 3, // Adjust the width as needed
                                  // ),
                                // ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/medical-report.png',
                                    width: 70,
                                    height: 80,
                                  ),
                                ),
                                // padding: EdgeInsets.all(20),
                              // ),
                             ),
                            SizedBox(height: 5),
                            Text(
                              'Reports',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffed4662),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height:10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 55),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PGraphPage(userId: widget.userId, dayDifference: widget.dayDifference)),
                                );
                              },
                              // child: Container(
                              //   width: 95,
                              //   height: 95,
                              //   decoration: BoxDecoration(
                              //     color: Color(0xffffc0cb),
                              //     borderRadius: BorderRadius.circular(15),
                                  // border: Border.all(
                                  //   color: Color(0xffed4662), // Add black color for the border
                                  //   width: 3, // Adjust the width as needed
                                  // ),
                                // ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/analytic.png',
                                    width: 70,
                                    height: 80,
                                  ),
                                ),
                                // padding: EdgeInsets.all(20),
                              ),
                            // ),
                            SizedBox(height:10),
                            Text(
                              'Graphs',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffed4662),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 100),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PMedicationPage(userId: widget.userId)),
                                );
                              },
                              // child: Container(
                              //   width: 95,
                              //   height: 95,
                              //   decoration: BoxDecoration(
                              //     color: Color(0xffffc0cb),
                              //     borderRadius: BorderRadius.circular(15),
                                  // border: Border.all(
                                  //   color: Color(0xffed4662), // Add black color for the border
                                  //   width: 3, // Adjust the width as needed
                                  // ),
                                // ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/medicine.png',
                                    width: 70,
                                    height: 80,
                                  ),
                                ),
                                // padding: EdgeInsets.all(20),
                              ),
                            // ),
                            SizedBox(height: 5),
                            Text(
                              'Medicals',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color:Color(0xffed4662),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height:10),
                  // Column(
                  //   children: [
                  //     GestureDetector(
                  //       onTap: () {
                  //         _launchWhatsApp();
                  //       },
                  //       child: Container(
                  //         width: 280,
                  //         decoration: BoxDecoration(
                  //           color: Color(0xffffc0cb),
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Row(
                  //             mainAxisSize: MainAxisSize.min,
                  //             children: [
                  //               SizedBox(width:55),
                  //               Image.asset(
                  //                 'assets/plus.png',
                  //                 width: 35,
                  //                 height: 35,
                  //               ),
                  //               SizedBox(width: 5),
                  //               Text(
                  //                 'Add Reports',
                  //                 style: TextStyle(
                  //                   fontSize: 16,
                  //                   fontWeight: FontWeight.bold,
                  //                   color:Color(0xffed4662),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<void> _launchWhatsApp() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                onTap: () {
                  _pickImage(ImageSource.camera, widget.userId);
                  Navigator.pop(context);
                },
                title: Text('Take Photo'),
              ),
              ListTile(
                onTap: () {
                  _pickImage(ImageSource.gallery, widget.userId);
                  Navigator.pop(context);
                },
                title: Text('Choose from Gallery'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source, String userId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      uploadImage(imageFile, userId);
    }
  }

  Future<void> uploadImage(File imageFile, String userId) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.27:80/infertility/uploadimg.php'),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );
      request.fields['Userid'] = userId;

      var streamedResponse = await request.send();

    } catch (error) {
      print('Error: $error');
    }
  }
}
