import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:infertilityapp/advice.dart';

class GraphPage extends StatefulWidget {
  final String userId;
  final String name;
  final int dayDifference;

  GraphPage({required this.userId, required this.name, required this.dayDifference});

  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  List<charts.Series<dynamic, String>> _chartData = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    String url = 'http://192.168.1.27:80/infertility/graph.php?userid=${widget.userId}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status']) {
          List<dynamic> sortedData = List<dynamic>.from(data['data']);
          sortedData.sort((a, b) => b['date'].compareTo(a['date'])); // Sort by date in descending order
          setState(() {
            _chartData = _createChartData(sortedData.take(5).toList()); // Take the first 5 elements
          });
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to connect to the server.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  List<charts.Series<dynamic, String>> _createChartData(List<dynamic> data) {
    return [
      charts.Series<dynamic, String>(
        id: 'Endometrium',
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        domainFn: (dynamic sales, _) => sales['date'],
        measureFn: (dynamic sales, _) => sales['endometrium'],
        data: data,
        labelAccessorFn: (dynamic sales, _) => '${sales['endometrium'].toStringAsFixed(2)}',
      ),
      charts.Series<dynamic, String>(
        id: 'Left Ovary',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (dynamic sales, _) => sales['date'],
        measureFn: (dynamic sales, _) => sales['leftOvary'],
        data: data,
        labelAccessorFn: (dynamic sales, _) => '${sales['leftOvary'].toStringAsFixed(2)}',
      ),
      charts.Series<dynamic, String>(
        id: 'Right Ovary',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (dynamic sales, _) => sales['date'],
        measureFn: (dynamic sales, _) => sales['rightOvary'],
        data: data,
        labelAccessorFn: (dynamic sales, _) => '${sales['rightOvary'].toStringAsFixed(2)}',
      ),
    ];
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
              'View Graph',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 10),
          Expanded(
            child: Image.asset(
              'assets/ovule.png',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 90),
          SizedBox(
            height: 300,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 700,
                    child: charts.BarChart(
                      _chartData,
                      animate: true,
                      barGroupingType: charts.BarGroupingType.grouped,
                      behaviors: [
                        charts.SeriesLegend(),
                        charts.ChartTitle('Date', behaviorPosition: charts.BehaviorPosition.bottom, titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
                        charts.ChartTitle('Values', behaviorPosition: charts.BehaviorPosition.start, titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
                      ],
                      defaultRenderer: charts.BarRendererConfig<String>(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        color: Color(0xffed4662),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: GestureDetector(
            onTap: () async {
              // After data is sent, navigate to the next page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdvicePage(userId: widget.userId, name: widget.name, dayDifference: widget.dayDifference)),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add Advices',
                  style: TextStyle(
                    color: Colors.white,
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
