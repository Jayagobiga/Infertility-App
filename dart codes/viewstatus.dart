import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'twelfth_page.dart';

class ViewStatusPage extends StatefulWidget {
  final String userId;

  ViewStatusPage({required this.userId});

  @override
  _ViewStatusPageState createState() => _ViewStatusPageState();
}

class _ViewStatusPageState extends State<ViewStatusPage> {
  List<Map<String, dynamic>> statusList = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromDatabase(widget.userId);
  }

  Future<void> fetchDataFromDatabase(String userId) async {
    final url = 'http://192.168.1.27:80/infertility/viewreports.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {'userid': userId},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status']) {
          List<Map<String, dynamic>> sortedStatusList = List<Map<String, dynamic>>.from(responseData['viewreport']);
          sortedStatusList.sort((a, b) => b['date'].compareTo(a['date'])); // Sort by date in descending order
          setState(() {
            statusList = sortedStatusList.take(5).toList(); // Take the first 3 elements
          });
        } else {
          // Handle error if no data found
          print(responseData['message']);
        }
      } else {
        // Handle HTTP error
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors
      print('Error fetching data: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Color(0xffed4662),
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              GestureDetector(
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
              SizedBox(width: 20),
              Text(
                'View Status',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
            statusList.length,
                (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 30.0),
              child: Container(
                height: 184,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.black),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      Text(
                        '             Day       ${statusList[index]['day']}', // Display fetched day
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '             Date     ${statusList[index]['date']}', // Display fetched date
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '             LO         ${statusList[index]['Leftovery']}', // Display fetched LO
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '             RO         ${statusList[index]['Rightovery']}', // Display fetched RO
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
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
