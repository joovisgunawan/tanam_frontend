import 'package:flutter/material.dart';

class HouseScreen extends StatefulWidget {
  const HouseScreen({super.key});

  @override
  State<HouseScreen> createState() => _HouseScreenState();
}

class _HouseScreenState extends State<HouseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: const Column(children: [Text("body")],),
    );
  }
}
