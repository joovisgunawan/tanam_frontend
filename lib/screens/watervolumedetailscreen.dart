// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:tanam/config.dart';

class WaterVolumeDetailScreen extends StatefulWidget {
  const WaterVolumeDetailScreen({super.key});

  @override
  State<WaterVolumeDetailScreen> createState() =>
      _WaterVolumeDetailScreenState();
}

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}

class _WaterVolumeDetailScreenState
    extends State<WaterVolumeDetailScreen> {
  List<ChartData> chartData = [];
  bool isLoading = true;
  DateTimeRange? selectedRange;
  double interval = 10;
  double zoomFactor = 1.0;

  @override
  void initState() {
    super.initState();
    fetchSensor();
  }

  fetchSensor() async {
    var db = await mongo.Db.create(Config.mongoUrl);
    await db.open();
    var collection = db.collection('sensor');
    var sensorList = await collection.find().toList();
    await db.close();
    print(sensorList);

    setState(() {
      chartData = sensorList.map((data) {
        // Parse the timestamp and convert it to local time
        DateTime timestamp = DateTime.parse(data['timestamp']).toLocal();
        return ChartData(
          timestamp,
          double.parse(data['waterTempC'].toString()),
        );
      }).toList();
      isLoading = false;
      // Set initial range to the entire dataset
      selectedRange = DateTimeRange(
        start: chartData.first.x,
        end: chartData.last.x,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Volume Chart'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : Column(
                        children: [
                          SfCartesianChart(
                            zoomPanBehavior: ZoomPanBehavior(
                              enablePanning: true,
                              enablePinching: true,
                              zoomMode: ZoomMode.x,
                            ),
                            onTooltipRender: (TooltipArgs args) {
                              if (args.pointIndex != null &&
                                  args.pointIndex! < chartData.length) {
                                final ChartData data =
                                    chartData[args.pointIndex!.toInt()];
                                // Format the date and time in local time zone
                                args.text =
                                    '${DateFormat('MMM d, HH:mm').format(data.x)}: ${data.y}';
                              }
                            },
                            tooltipBehavior: TooltipBehavior(
                              enable: true,
                              textStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            enableAxisAnimation: true,
                            primaryXAxis: DateTimeAxis(
                              dateFormat: DateFormat('MMM d, HH:mm'),
                              intervalType: DateTimeIntervalType.minutes,
                              labelRotation: 45,
                              autoScrollingDelta: 20,
                              autoScrollingMode: AutoScrollingMode.end,
                              autoScrollingDeltaType:
                                  DateTimeIntervalType.minutes,
                              interval: interval,
                              // zoomFactor: zoomFactor,
                              minimum: selectedRange?.start,
                              maximum: selectedRange?.end,
                            ),
                            primaryYAxis: const NumericAxis(),
                            series: <CartesianSeries<ChartData, DateTime>>[
                              LineSeries<ChartData, DateTime>(
                                dataSource: chartData,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                markerSettings: const MarkerSettings(
                                  isVisible: true,
                                ),
                                dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  labelAlignment: ChartDataLabelAlignment.top,
                                ),
                                name: "Volume",
                              ),
                            ],
                            legend: const Legend(
                              isVisible: true,
                            ),
                          ),
                          const SizedBox(height: 20),
                          RangeSlider(
                            values: RangeValues(
                              selectedRange?.start.millisecondsSinceEpoch
                                      .toDouble() ??
                                  chartData.first.x.millisecondsSinceEpoch
                                      .toDouble(),
                              selectedRange?.end.millisecondsSinceEpoch
                                      .toDouble() ??
                                  chartData.last.x.millisecondsSinceEpoch
                                      .toDouble(),
                            ),
                            min: chartData.first.x.millisecondsSinceEpoch
                                .toDouble(),
                            max: chartData.last.x.millisecondsSinceEpoch
                                .toDouble(),
                            onChanged: (values) {
                              setState(() {
                                selectedRange = DateTimeRange(
                                  start: DateTime.fromMillisecondsSinceEpoch(
                                      values.start.toInt()),
                                  end: DateTime.fromMillisecondsSinceEpoch(
                                      values.end.toInt()),
                                );
                              });
                            },
                            labels: RangeLabels(
                              DateFormat('MMM d, HH:mm').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    selectedRange?.start.millisecondsSinceEpoch ??
                                        chartData.first.x.millisecondsSinceEpoch),
                              ),
                              DateFormat('MMM d, HH:mm').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    selectedRange?.end.millisecondsSinceEpoch ??
                                        chartData.last.x.millisecondsSinceEpoch),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Slider(
                            value: interval,
                            min: 1,
                            max: 60,
                            divisions: 59,
                            label: interval.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                interval = value;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Interval: ${interval.round()} minutes',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          // Slider(
                          //   value: zoomFactor,
                          //   min: 0.1,
                          //   max: 1.0,
                          //   divisions: 10,
                          //   label: zoomFactor.toStringAsFixed(1),
                          //   onChanged: (double value) {
                          //     setState(() {
                          //       zoomFactor = value;
                          //     });
                          //   },
                          // ),
                          // const SizedBox(height: 10),
                          // Text(
                          //   'Zoom Factor: ${zoomFactor.toStringAsFixed(1)}',
                          //   style: const TextStyle(fontSize: 16),
                          // ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("Image"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Image.asset(
                'assets/images/sonar.png',
                height: 200,
                // width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("Description"),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "The food production demands are high, especially the crops, fruits, and vegetables so the water demand will continue to rise and due to poor irrigation, a large amount of water is lost, roughly around 40%. Plants need water for every growing stage, from seeding to harvest.",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
