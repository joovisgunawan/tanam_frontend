// ignore_for_file: prefer_final_fields, deprecated_member_use, avoid_print, unused_local_variable, use_super_parameters

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:tanam/screens/airtemperaturedetailscreen.dart';
import 'package:tanam/screens/humiditydetailscreen.dart';
import 'package:tanam/screens/phdetailscreen.dart';
import 'package:tanam/screens/tdsdetailscreen.dart';
import 'package:tanam/screens/watertemperaturedetailscreen.dart';
import 'package:tanam/screens/watervolumedetailscreen.dart';
import 'package:typed_data/src/typed_buffer.dart';

class MyDeviceDetailScreen extends StatefulWidget {
  final int index;
  const MyDeviceDetailScreen({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<MyDeviceDetailScreen> createState() => _MyDeviceDetailScreenState();
}

class _MyDeviceDetailScreenState extends State<MyDeviceDetailScreen> {
  late MqttServerClient client;
  StreamController<String> _messageStreamController =
      StreamController<String>();
  Map<String, dynamic>? sensorData;

  @override
  void initState() {
    super.initState();
    initMqtt();
  }

  @override
  void dispose() {
    _messageStreamController.close();
    super.dispose();
  }

  void initMqtt() async {
    String broker = 'mqtt.tanam.software';
    String username = 'tanam-broker';
    String password = 't4nAm_br0k3r';

    client = MqttServerClient(broker, '');
    client.logging(on: true);
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .authenticateAs(username, password)
        .keepAliveFor(60)
        .startClean();

    client.connectionMessage = connMess;

    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
    }

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String payloadString = MqttPublishPayload.bytesToStringAsString(
        recMess.payload.message,
      );
      print(payloadString);

      try {
        Map<String, dynamic> data = json.decode(payloadString);
        sensorData = data;
        setState(() {});
      } catch (e) {
        print('Error parsing JSON: $e');
      }
    });
  }

  void onConnected() {
    print('Connected');
    client.subscribe(
      'tanam1/publisher',
      MqttQos.atLeastOnce,
    );
  }

  void onDisconnected() {
    print('Disconnected');
  }

  void onSubscribed(String topic) {
    print('Subscribed to $topic');
  }

  void onSubscribeFail(String topic) {
    print('Failed to subscribe to $topic');
  }

  void publishSensorData(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  void publishMessage(String relay_ch, String state) {
    String topic = 'tanam1/subscriber'; // Replace with your actual MQTT topic
    Map<String, dynamic> message = {
      "relay_ch": relay_ch,
      "state": state,
    };
    String mqttMessage = jsonEncode(message);
    // client.publishMessage(topic, MqttQos.exactlyOnce, mqttMessage as Uint8Buffer);

    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(mqttMessage);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  Widget buildSensorTile(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget buildSensorCard(
      String title, String value, Color color, Widget screen) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Container(
          height: 120,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 18, color: Colors.white)),
              const SizedBox(height: 10),
              Text(value,
                  style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Device'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Ensure the Column takes minimum vertical space
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildSensorCard(
                    'Temperature',
                    sensorData != null
                        ? sensorData!['airTempC'].toString()
                        : '0',
                    Colors.green,
                    const AirTemperatureDetailScreen(),
                  ),
                  buildSensorCard(
                    'Humidity',
                    sensorData != null
                        ? sensorData!['humidity'].toString()
                        : '0',
                    Colors.green,
                    const HumidityDetailScreen(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildSensorCard(
                    'TDS',
                    sensorData != null ? sensorData!['tds'].toString() : '0',
                    Colors.green,
                    const TdsDetailScreen(),
                  ),
                  buildSensorCard(
                    'pH',
                    sensorData != null ? sensorData!['pH'].toString() : '0',
                    Colors.green,
                    const PHDetailScreen(),
                    // const HumidityDetailScreen(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildSensorCard(
                    'Water Volume',
                    sensorData != null
                        ? sensorData!['waterVolumeCm'].toString()
                        : '0',
                    Colors.green,
                    const WaterVolumeDetailScreen(),
                    // const HumidityDetailScreen(),
                  ),
                  buildSensorCard(
                    'Water Temp',
                    sensorData != null
                        ? sensorData!['waterTempC'].toString()
                        : '0',
                    Colors.green,
                    const WaterTemperatureDetailScreen(),
                    // const HumidityDetailScreen(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap:
                    true, // Ensure the ListView takes only the space it needs
                physics:
                    NeverScrollableScrollPhysics(), // Disable ListView scrolling
                itemCount: 8, // Adjust this as per your actual item count
                itemBuilder: (context, index) {
                  int relayNumber = index + 1;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Relay $relayNumber',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                publishMessage(relayNumber.toString(), "On");
                              },
                              child: const Text("On"),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xffF7FFF7),
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                side: const BorderSide(
                                  color: Colors.green,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () {
                                publishMessage(relayNumber.toString(), "Off");
                                print("object");
                              },
                              child: Text("Off"),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xffF7FFF7),
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                side: const BorderSide(
                                  color:
                                      Colors.red, // Fixed to red for Off button
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// // ignore_for_file: prefer_final_fields, deprecated_member_use, avoid_print, unused_local_variable, use_super_parameters

// import 'dart:async';
// import 'dart:convert'; // Import for JSON decoding

// import 'package:flutter/material.dart';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';
// import 'package:tanam/screens/airtemperaturedetailscreen.dart';
// import 'package:tanam/screens/humiditydetailscreen.dart';

// class MyDeviceDetailScreen extends StatefulWidget {
//   final int index;
//   const MyDeviceDetailScreen({
//     Key? key,
//     required this.index,
//   }) : super(key: key);

//   @override
//   State<MyDeviceDetailScreen> createState() => _MyDeviceDetailScreenState();
// }

// class _MyDeviceDetailScreenState extends State<MyDeviceDetailScreen> {
//   late MqttServerClient client;
//   StreamController<String> _messageStreamController =
//       StreamController<String>();

//   Map<String, dynamic>? sensorData; // Store received sensor data

//   @override
//   void initState() {
//     super.initState();
//     initMqtt();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Device'),
//         actions: const [],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
//         child: Column(
//           children: [
//             Container(
//               color: Colors.blue,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.amber,
//                       ),
//                       child: InkWell(
//                         onTap: () {
//                           print("object");
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   AirTemperatureDetailScreen(),
//                             ),
//                           );
//                         },
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text('Temperature'),
//                             Text(
//                               sensorData != null
//                                   ? sensorData!['airTempC'].toString()
//                                   : '0',
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   Expanded(
//                     child: Container(
//                       color: Colors
//                           .green, // Optional: Set a different color to distinguish the containers
//                       child: InkWell(
//                         onTap: () {
//                           print("object");
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => HumidityDetailScreen(),
//                             ),
//                           );
//                         },
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text('Humidity'),
//                             Text(
//                               sensorData != null
//                                   ? sensorData!['humidity'].toString()
//                                   : '0',
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Container(
//               color: Colors.blue,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.amber,
//                       ),
//                       child: InkWell(
//                         onTap: () {
//                           print("object");
//                         },
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text('Tds'),
//                             Text(
//                               sensorData != null
//                                   ? sensorData!['tds'].toString()
//                                   : '0',
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   Expanded(
//                     child: Container(
//                       color: Colors
//                           .green, // Optional: Set a different color to distinguish the containers
//                       child: InkWell(
//                         onTap: () {
//                           print("object");
//                         },
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text('pH'),
//                             Text(
//                               sensorData != null
//                                   ? sensorData!['pH'].toString()
//                                   : '0',
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Container(
//               color: Colors.blue,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     child: TextButton(
//                       onPressed: () {
//                         publishSensorData(
//                             'tanam1/subscriber', '{"relayCh[0]":"1"}');
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.amber,
//                         ),
//                         child: const Text('relay 1'),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   Expanded(
//                     child: TextButton(
//                       onPressed: () {
//                         publishSensorData(
//                             'tanam1/subscriber', '{"relayCh[0]":"1"}');
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.amber,
//                         ),
//                         child: Column(
//                           children: [
//                             const Text('relay 1'),
//                             const Text('Status'),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Container(
//               color: Colors.blue,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     child: TextButton(
//                       onPressed: () {
//                         publishSensorData(
//                             'tanam1/subscriber', '{"relayCh[0]":"1"}');
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.amber,
//                         ),
//                         child: const Text('relay 1'),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   Expanded(
//                     child: TextButton(
//                       onPressed: () {
//                         publishSensorData(
//                             'tanam1/subscriber', '{"relayCh[0]":"1"}');
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.amber,
//                         ),
//                         child: Column(
//                           children: [
//                             const Text('relay 1'),
//                             const Text('Status'),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Container(
//               color: Colors.blue,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     child: TextButton(
//                       onPressed: () {
//                         publishSensorData(
//                             'tanam1/subscriber', '{"relayCh[0]":"1"}');
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.amber,
//                         ),
//                         child: const Text('relay 1'),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   Expanded(
//                     child: TextButton(
//                       onPressed: () {
//                         publishSensorData(
//                             'tanam1/subscriber', '{"relayCh[0]":"1"}');
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.amber,
//                         ),
//                         child: Column(
//                           children: [
//                             const Text('relay 1'),
//                             const Text('Status'),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Container(
//               color: Colors.blue,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     child: TextButton(
//                       onPressed: () {
//                         publishSensorData(
//                             'tanam1/subscriber', '{"relayCh[0]":"1"}');
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.amber,
//                         ),
//                         child: const Text('relay 1'),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   Expanded(
//                     child: TextButton(
//                       onPressed: () {
//                         publishSensorData(
//                             'tanam1/subscriber', '{"relayCh[0]":"1"}');
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.amber,
//                         ),
//                         child: Column(
//                           children: [
//                             const Text('relay 1'),
//                             const Text('Status'),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildSensorTile(String title, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(title),
//         Text(value),
//       ],
//     );
//   }

//   void initMqtt() async {
//     String broker = 'mqtt.tanam.software';
//     // int port = 1883;
//     String username = 'tanam-broker';
//     String password = 't4nAm_br0k3r';

//     client = MqttServerClient(broker, '');
//     client.logging(on: true);
//     client.onDisconnected = onDisconnected;
//     client.onConnected = onConnected;
//     client.onSubscribed = onSubscribed;
//     client.onSubscribeFail = onSubscribeFail;

//     final MqttConnectMessage connMess = MqttConnectMessage()
//         .withClientIdentifier('flutter_client')
//         .authenticateAs(username, password)
//         .keepAliveFor(60)
//         .startClean();

//     client.connectionMessage = connMess;

//     try {
//       await client.connect();
//     } catch (e) {
//       print('Exception: $e');
//     }

//     // Listen for messages, so this will update the value when there is update from mqtt
//     client.updates!.listen((List<MqttReceivedMessage<MqttMessage>>? c) {
//       final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
//       //convert the payload to string, becuase mqtt send data in bytes
//       final String payloadString = MqttPublishPayload.bytesToStringAsString(
//         recMess.payload.message,
//       );
//       // _messageStreamController.add(payload); // Add received message to stream
//       print(payloadString);

//       // Parse JSON and update sensor data
//       try {
//         //map the payload to json, because it just a long of string, make it to object again
//         //then set state
//         Map<String, dynamic> data = json.decode(payloadString);
//         sensorData = data;

//         setState(() {});
//       } catch (e) {
//         print('Error parsing JSON: $e');
//       }
//     });
//   }

//   void onConnected() {
//     print('Connected');
//     client.subscribe(
//       'tanam1/publisher',
//       MqttQos.atLeastOnce,
//     ); // Subscribe to a topic
//   }

//   void onDisconnected() {
//     print('Disconnected');
//   }

//   void onSubscribed(String topic) {
//     print('Subscribed to $topic');
//   }

//   void onSubscribeFail(String topic) {
//     print('Failed to subscribe to $topic');
//   }

//   @override
//   void dispose() {
//     _messageStreamController.close(); // Close stream controller when not needed
//     super.dispose();
//   }

//   void publishSensorData(String topic, String message) {
//     // Your code to publish sensor data as JSON to the MQTT broker
//     final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
//     builder.addString(message);
//     client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
//   }
// }

// // // ignore_for_file: unused_local_variable, prefer_final_fields, use_super_parameters, deprecated_member_use, avoid_print

// // import 'dart:async';
// // import 'dart:convert'; // Import for JSON decoding

// // import 'package:flutter/material.dart';
// // import 'package:mqtt_client/mqtt_client.dart';
// // import 'package:mqtt_client/mqtt_server_client.dart';

// // class IotDeviceDetailScreen extends StatefulWidget {
// //   final int index;
// //   const IotDeviceDetailScreen({
// //     Key? key,
// //     required this.index,
// //   }) : super(key: key);

// //   @override
// //   State<IotDeviceDetailScreen> createState() => _IotDeviceDetailScreenState();
// // }

// // class _IotDeviceDetailScreenState extends State<IotDeviceDetailScreen> {
// //   String airTempC = "3";
// //   late MqttServerClient client;
// //   StreamController<String> _messageStreamController =
// //       StreamController<String>();

// //   Map<String, dynamic>? sensorData; // Store received sensor data

// //   @override
// //   void initState() {
// //     super.initState();
// //     initMqtt();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('My Device'),
// //         actions: const [],
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
// //         child: Column(
// //           children: [
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //               children: [
// //                 Column(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     const Text('Air temperature'),
// //                     Text(sensorData != null
// //                         ? sensorData!['airTempC'].toString()
// //                         : '0'),
// //                   ],
// //                 ),
// //                 Column(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     const Text('Air temperature'),
// //                     Text(sensorData != null
// //                         ? sensorData!['airTempC'].toString()
// //                         : '0'),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //               children: [
// //                 Column(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     const Text('Air temperature'),
// //                     Text(airTempC),
// //                   ],
// //                 ),
// //                 Column(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     const Text('Air temperature'),
// //                     Text(sensorData != null
// //                         ? sensorData!['airTempC'].toString()
// //                         : '0'),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //               children: [
// //                 Column(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     const Text('Air temperature'),
// //                     Text(sensorData != null
// //                         ? sensorData!['airTempC'].toString()
// //                         : '0'),
// //                   ],
// //                 ),
// //                 Column(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     const Text('Air temperature'),
// //                     Text(sensorData != null
// //                         ? sensorData!['airTempC'].toString()
// //                         : '0'),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //             // buildSensorTile(
// //             //     'Air temperature', sensorData!['airTempC']?.toString() ?? '0'),
// //             // buildSensorTile(
// //             //     'Humidity', sensorData!['humidity']?.toString() ?? '0'),
// //             // buildSensorTile('Water temperature',
// //             //     sensorData!['water_temperature']?.toString() ?? '0'),
// //             // buildSensorTile('TDS', sensorData!['tds']?.toString() ?? '0'),
// //             // buildSensorTile('pH', sensorData!['ph']?.toString() ?? '0'),
// //             // if (sensorData != null) ...[
// //             //   buildSensorTile(
// //             //       'Air temperature', sensorData!['airTempC']?.toString() ?? '0'),
// //             //   buildSensorTile(
// //             //       'Humidity', sensorData!['humidity']?.toString() ?? '0'),
// //             //   buildSensorTile('Water temperature',
// //             //       sensorData!['water_temperature']?.toString() ?? '0'),
// //             //   buildSensorTile('TDS', sensorData!['tds']?.toString() ?? '0'),
// //             //   buildSensorTile('pH', sensorData!['ph']?.toString() ?? '0'),
// //             // ],
// //             TextButton(
// //               onPressed: () {
// //                 publishSensorData('tanam1/subscriber', '{"relayCh[0]":"1"}');
// //               },
// //               child: const Text('relay 1'),
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget buildSensorTile(String title, String value) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Text(title),
// //         Text(value),
// //       ],
// //     );
// //   }

// //   void initMqtt() async {
// //     String broker = 'mqtt.tanam.software';
// //     // int port = 1883;
// //     String username = 'tanam-broker';
// //     String password = 't4nAm_br0k3r';

// //     client = MqttServerClient(broker, '');
// //     client.logging(on: true);
// //     client.onDisconnected = onDisconnected;
// //     client.onConnected = onConnected;
// //     client.onSubscribed = onSubscribed;
// //     client.onSubscribeFail = onSubscribeFail;

// //     final MqttConnectMessage connMess = MqttConnectMessage()
// //         .withClientIdentifier('flutter_client')
// //         .authenticateAs(username, password)
// //         .keepAliveFor(60)
// //         .startClean();

// //     client.connectionMessage = connMess;

// //     try {
// //       await client.connect();
// //     } catch (e) {
// //       print('Exception: $e');
// //     }

// //     // Listen for messages, so this will update the value when there is update from mqtt
// //     client.updates!.listen((List<MqttReceivedMessage<MqttMessage>>? c) {
// //       final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
// //       final String payload =
// //           MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
// //       // _messageStreamController.add(payload); // Add received message to stream
// //       print(payload);

// //       // Parse JSON and update sensor data
// //       try {
// //         Map<String, dynamic> data = json.decode(payload);
// //         setState(() {
// //           // sensorData = data;
// //           airTempC = "4";
// //         });
// //       } catch (e) {
// //         print('Error parsing JSON: $e');
// //       }
// //     });
// //   }

// //   void onConnected() {
// //     print('Connected');
// //     client.subscribe(
// //         'tanam1/publisher', MqttQos.atLeastOnce); // Subscribe to a topic
// //   }

// //   void onDisconnected() {
// //     print('Disconnected');
// //   }

// //   void onSubscribed(String topic) {
// //     print('Subscribed to $topic');
// //   }

// //   void onSubscribeFail(String topic) {
// //     print('Failed to subscribe to $topic');
// //   }

// //   @override
// //   void dispose() {
// //     _messageStreamController.close(); // Close stream controller when not needed
// //     super.dispose();
// //   }

// //   void publishSensorData(String topic, String message) {
// //     // Your code to publish sensor data as JSON to the MQTT broker
// //     final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
// //     builder.addString(message);
// //     client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
// //   }
// // }
