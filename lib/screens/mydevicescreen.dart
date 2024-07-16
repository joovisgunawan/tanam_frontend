import 'package:flutter/material.dart';
import 'package:tanam/models/iotdevicemodel.dart';
import 'package:tanam/screens/esp32camscreen.dart';
import 'package:tanam/screens/mydevicedetailscreen.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MyDeviceScreen extends StatefulWidget {
  const MyDeviceScreen({super.key});

  @override
  State<MyDeviceScreen> createState() => _MyDeviceScreenState();
}

class _MyDeviceScreenState extends State<MyDeviceScreen> {
  late final MqttServerClient client;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Devices'),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: iotList.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        if (int.parse(iotList[index].deviceId) == 3) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const Esp32CamScreen();
                              },
                            ),
                          );
                          return;
                        }
                        

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return MyDeviceDetailScreen(index: index);
                            },
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.devices,
                            size: 50,
                            color: Colors.green,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                iotList[index].deviceName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                iotList[index].deviceCategory,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.more_vert),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add device action
        },
        tooltip: 'Add Device',
        backgroundColor: Colors.green,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
