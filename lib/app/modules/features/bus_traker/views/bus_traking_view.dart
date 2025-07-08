import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/bus_traking_controller.dart';

class BusTrakingView extends GetView<BusTrakingController> {
  const BusTrakingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BusTrakingView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BusTrakingView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
