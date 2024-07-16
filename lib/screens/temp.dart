// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:syncfusion_flutter_charts/charts.dart';

class Temp extends StatefulWidget {
  const Temp({super.key});

  @override
  State<Temp> createState() => _TempState();
}

class _TempState extends State<Temp> {
  List<ChartData> chartData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSensor();
  }

  fetchSensor() async {
    var db = await mongo.Db.create(
        "mongodb://tanam:t4nAm_mongodb@tanam.software:27017/?directConnection=true&serverSelectionTimeoutMS=2000&authSource=admin&appName=mongosh+2.2.6");
    await db.open();
    var collection = db.collection('sensor');
    var sensorList = await collection.find().toList();
    await db.close();
    print(sensorList);

    setState(() {
      chartData = sensorList.map((data) {
        return ChartData(
          DateTime.parse(data['timestamp']),
          double.parse(data['waterTempC'].toString()),
        );
      }).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Chart'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: SfCartesianChart(
                        zoomPanBehavior: ZoomPanBehavior(
                          enablePanning: true,
                        ),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        enableAxisAnimation: true,
                        primaryXAxis: DateTimeAxis(
                          dateFormat: DateFormat('MMM d, HH:mm'),
                          intervalType: DateTimeIntervalType.minutes,
                          labelRotation: 45,
                          autoScrollingDelta: 20,
                          autoScrollingMode: AutoScrollingMode.end,
                          autoScrollingDeltaType: DateTimeIntervalType.minutes,
                          interval: 10,
                        ),
                        primaryYAxis: const NumericAxis(),
                        series: <CartesianSeries<ChartData, DateTime>>[
                          LineSeries<ChartData, DateTime>(
                            dataSource: chartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            markerSettings: const MarkerSettings(isVisible: true),
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              labelAlignment: ChartDataLabelAlignment.top,
                            ),
                            name: "Temperature",
                          ),
                        ],
                        legend: const Legend(isVisible: true),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Image",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Image(
                      image: AssetImage('assets/your_image.png'),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Description",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "This is a description of the air temperature data. You can provide detailed information about the data and its significance here.",
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}

