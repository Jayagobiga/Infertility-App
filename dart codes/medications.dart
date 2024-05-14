import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infertilityapp/twelfth_page.dart';
import 'package:intl/intl.dart';

class MedicationsPage extends StatelessWidget {
  final String userId;
  final String name;
  final int dayDifference;

  MedicationsPage({required this.userId, required this.name,required this.dayDifference});

  @override
  Widget build(BuildContext context) {
    TextEditingController medicineNameController = TextEditingController();
    TextEditingController timeController = TextEditingController(); // New controller for Quantity
    TextEditingController quantityController = TextEditingController(); // New controller for Timing
    TextEditingController labelController = TextEditingController();   // New controller for When

    Future<void> sendDataToBackend(BuildContext context) async {
      String medicineName = medicineNameController.text;
      String time = timeController.text; // Retrieve quantity from text field
      String quantity = quantityController.text;   // Retrieve timing from text field
      String label = labelController.text;       // Retrieve when from text field
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final url = 'http://192.168.1.27:80/infertility/medications.php';

      try {
        final response = await http.post(
          Uri.parse(url),
          body: {
            'userId': userId,
            'medicineName': medicineName,
            'time': time,
            'quantity': quantity,
            'label': label,
            'date': currentDate,
          },
        );

        if (response.statusCode == 200) {
          // Successful HTTP POST request
          // Navigate to twelfth page upon successful database insertion
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TwelfthPage(userId: userId, name: name, dayDifference: dayDifference)),
          );
        } else {
          // HTTP request failed
          throw Exception('Failed to save medication details');
        }
      } catch (e) {
        // Error handling
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Failed to save medication details"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Color(0xffed4662),
          automaticallyImplyLeading: false, // Set background color to pink accent
          title: Row(
            children: [
              SizedBox(
                width: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Navigate to the previous page
                  },
                  child: Image.asset(
                    'assets/arrow.png', // Path to your image asset
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(width: 30), // Add some space between image and text
              Text(
                'Medications',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // Container(
          //   width: double.infinity,
          //   height: double.infinity,
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage('assets/background2.png'),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          SingleChildScrollView( // Wrap the Column with SingleChildScrollView
            child: Column(
              children: [
                SizedBox(height: 40), // Spacing from the AppBar
                Center(
                  child: SizedBox(
                    height: 70,
                    width: 330,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(color: Colors.black),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Date',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            width: 1, // Width of the vertical line
                            height: 80, // Height of the vertical line
                            color: Colors.black,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right:30.0),
                            child: Text(
                              DateFormat('dd-MM-yyyy').format(DateTime.now()),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40), // Spacing below the rectangle box
                Padding(
                  padding: const EdgeInsets.only(right:220.0),
                  child: Text(
                    'Medicine Name',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height:10), // Spacing before the TextField
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0),
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextField(
                    controller: medicineNameController,
                    decoration: InputDecoration(
                      hintText: 'Name of the medication',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20), // Spacing below the rectangle box
                Padding(
                  padding: const EdgeInsets.only(right:310.0),
                  child: Text(
                    'Time',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height:10), // Spacing before the TextField
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0),
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextField(
                    controller: timeController,
                    decoration: InputDecoration(
                      hintText: 'Pills/Injection/Drugs/Powder',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20), // Spacing below the rectangle box
                Padding(
                  padding: const EdgeInsets.only(right:290.0),
                  child: Text(
                    'quantity',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height:10), // Spacing before the TextField
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0),
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextField(
                    controller: quantityController,
                    decoration: InputDecoration(
                      hintText: 'Pills/Injection/Drugs/Powder',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20), // Spacing below the rectangle box
                Padding(
                  padding: const EdgeInsets.only(right:310.0),
                  child: Text(
                    'Label',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height:10), // Spacing before the TextField
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0),
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextField(
                    controller: labelController,
                    decoration: InputDecoration(
                      hintText: 'Enter label',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 40), // Spacing below the rectangle box
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                sendDataToBackend(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffed4662), // Background color// Text color
                    ),
                    child: Text('Save', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xfffddbdc),
    );
  }
}




















