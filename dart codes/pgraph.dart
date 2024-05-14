import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert';

class PGraphPage extends StatefulWidget {
  final String userId;
  final int dayDifference;

  PGraphPage({required this.userId, required this.dayDifference});

  @override
  _PGraphPageState createState() => _PGraphPageState();
}

class _PGraphPageState extends State<PGraphPage> {
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
          SizedBox(height: 60),
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
      backgroundColor: Color(0xfffddbdc),
    );
  }
}
