// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class CameraStreamPage extends StatefulWidget {
  @override
  _CameraStreamPageState createState() => _CameraStreamPageState();
}

class _CameraStreamPageState extends State<CameraStreamPage> {
  late WebSocketChannel channel;
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    // Initialize the WebSocket connection with a custom HttpClient
    channel = IOWebSocketChannel.connect(
      'wss://hasya.ujicoba.me:56112',
      customClient: HttpClient()..badCertificateCallback = (X509Certificate cert, String host, int port) => true,
    );
    // Listen for incoming data
    channel.stream.listen((data) {
      if (data is List<int>) {
        setState(() {
          _imageData = Uint8List.fromList(data);
        });
      }
    });
  }

  @override
  void dispose() {
    // Close the WebSocket connection when the widget is disposed
    channel.sink.close(status.goingAway);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ESP32 Camera Stream'),
      ),
      body: Center(
        child: _imageData == null
            ? const CircularProgressIndicator()
            : Image.memory(
                _imageData!,
                gaplessPlayback: true, // This avoids the flicker by enabling gapless playback
              ),
      ),
    );
  }
}
