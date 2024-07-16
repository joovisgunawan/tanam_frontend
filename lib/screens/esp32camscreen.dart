// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:image/image.dart' as img;

class Esp32CamScreen extends StatefulWidget {
  const Esp32CamScreen({super.key});

  @override
  State<Esp32CamScreen> createState() => _Esp32CamScreenState();
}

class _Esp32CamScreenState extends State<Esp32CamScreen> {
  late MqttServerClient client;

  @override
  void initState() {
    super.initState();
    initMqtt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Esp32 Cam'),
      ),
      body: Column(
        children: [
          Center(
            child: StreamBuilder(
              stream: client.updates,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
                } else {
                  final mqttReceivedMessages =
                      snapshot.data as List<MqttReceivedMessage<MqttMessage?>>?;

                  if (mqttReceivedMessages == null ||
                      mqttReceivedMessages.isEmpty) {
                    return const Center(
                      child: Text(
                        'No data received',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final recMess =
                      mqttReceivedMessages[0].payload as MqttPublishMessage;
                  Uint8List bufferAsUint8List =
                      Uint8List.fromList(recMess.payload.message.toList());

                  try {
                    // Check if the buffer contains valid JPEG SOI marker
                    if (bufferAsUint8List.length >= 2 &&
                        bufferAsUint8List[0] == 0xFF &&
                        bufferAsUint8List[1] == 0xD8) {
                      img.Image? jpegImage = img.decodeJpg(bufferAsUint8List);

                      if (jpegImage != null) {
                        Uint8List encodedImage =
                            Uint8List.fromList(img.encodeJpg(jpegImage));
                        return Image.memory(
                          encodedImage,
                          gaplessPlayback: true,
                        );
                      } else {
                        print("Image decoding failed: JPEG image is null");
                        return const Center(
                          child: Text(
                            'Failed to decode image',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }
                    } else {
                      print(
                          "Invalid JPEG data: Start Of Image marker not found");
                      return const Center(
                        child: Text(
                          'Invalid JPEG data',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }
                  } catch (e) {
                    print("Failed to decode image: $e");
                    return const Center(
                      child: Text(
                        'Failed to decode image',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle("Image"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Image.asset(
              'assets/your_image.png',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle("Description"),
        ],
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
    client.keepAlivePeriod = 20;
    client.port = 8883;
    client.secure = true;
    client.pongCallback = pong;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .authenticateAs(username, password)
        .startClean();

    client.connectionMessage = connMess;

    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
    }

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String payloadString =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print(payloadString);
    });
  }

  void onConnected() {
    const topic = 'esp32/cam_0';
    print('Connected');
    client.subscribe(topic, MqttQos.atLeastOnce);
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

  void pong() {
    print('Ping response client callback invoked');
  }
}
