import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:infertilityapp/addreports.dart';

class ReportsPage extends StatefulWidget {
  final String userId;
  final String name;
  final int dayDifference;

  ReportsPage({required this.userId, required this.name,required this.dayDifference});

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  List<String> imageUrls = [];
  List<String> dates = [];
  List<String> days = [];

  @override
  void initState() {
    super.initState();
    // Fetch image URLs when the widget is initialized
    fetchImages();
  }

  Future<void> fetchImages() async {
    final Uri url = Uri.parse(
      'http://192.168.1.27:80/infertility/viewimg.php?userid=${widget.userId}',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        imageUrls = List<String>.from(data['images']);
        dates = List<String>.from(data['date']);
        days = List<String>.from(data['day']);
      });
    } else {
      // Handle error
      print('Failed to load images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffed4662),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(
              width: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  'assets/arrow.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 30),
            Text(
              'View Reports',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: List.generate(
              imageUrls.length,
                  (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  height: 70,
                  child: ListTile(
                    title: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddReportsPage(
                              userId: widget.userId,
                              name: widget.name,
                              imageUrl: imageUrls[index],
                              dayDifference: widget.dayDifference,// Pass the image URL
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 330,
                        height: 85,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 90,
                              child: Container(
                                width: 70,
                                height: 70,
                                child: Image.network(
                                  imageUrls[index],
                                  fit: BoxFit.cover, // Maintain aspect ratio and cover the space
                                ),
                              ),
                            ),
                            SizedBox(width: 30),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${dates[index]}', // Display date
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Day: ${days[index]}', // Display day
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xfffddbdc),
    );
  }
}
