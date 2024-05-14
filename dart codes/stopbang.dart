import 'package:flutter/material.dart';

class SquareRadio extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  SquareRadio({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? Colors.blue : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: selected
            ? Icon(
          Icons.check,
          size: 16,
          color: Colors.blue,
        )
            : null,
      ),
    );
  }
}

class StopBang extends StatefulWidget {
  @override
  _StopBangState createState() => _StopBangState();
}

class _StopBangState extends State<StopBang> {
  List<int?> _selectedOptions = List.filled(8, null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'STOP-BANG',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyan.shade300, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.5, 1.0],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 170.0),
              child: Text(
                'STOP',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Question 1
            buildQuestion(
              'Do you snore loudly?',
              0,
            ),
            SizedBox(height: 10),
            // Question 2
            buildQuestion(
              'Do you often feel TIRED,\nfatigue, or sleepy during\ndaytime?',
              1,
            ),
            SizedBox(height: 10),
            // Question 3
            buildQuestion(
              'Has anyone OBSERVED\nyou stop breathing during\nyour sleep?',
              2,
            ),
            SizedBox(height: 10),
            // Question 4
            buildQuestion(
              'Do you have or are you\nbeing treated for high blood\nPRESSURE?',
              3,
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 170.0),
              child: Text(
                'BANG',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Question 5
            buildQuestion(
              'BMI more than 35kg/m2?',
              4,
            ),
            SizedBox(height: 20),
            // Question 6
            buildQuestion(
              'AGE over 50 years old?',
              5,
            ),
            SizedBox(height: 20),
            // Question 7
            buildQuestion(
              'NECK circumference>16\ninches?',
              6,
            ),
            SizedBox(height: 20),
            // Question 8
            buildQuestion(
              'GENDER: Male?',
              7,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SizedBox(
          width: double.infinity, // Make button stretch horizontally
          height: 40,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF66D0D0), // Change the button color here
            ),
            child: Text(
              'SUBMIT',
              style: TextStyle(color: Colors.white, fontSize: 17), // Change the text color here
            ),
          ),
        ),
      ),
    );
  }

  // Function to build each question
  Widget buildQuestion(String question, int index) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedOptions[index] = 1; // Yes
                  });
                },
                child: SquareRadio(
                  selected: _selectedOptions[index] == 1,
                  onTap: () {
                    setState(() {
                      _selectedOptions[index] = 1;
                    });
                  },
                ),
              ),
              SizedBox(width: 10),
              Text('Yes'),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedOptions[index] = 2; // No
                  });
                },
                child: SquareRadio(
                  selected: _selectedOptions[index] == 2,
                  onTap: () {
                    setState(() {
                      _selectedOptions[index] = 2;
                    });
                  },
                ),
              ),
              SizedBox(width: 10),
              Text('No'),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StopBang(),
  ));
}
