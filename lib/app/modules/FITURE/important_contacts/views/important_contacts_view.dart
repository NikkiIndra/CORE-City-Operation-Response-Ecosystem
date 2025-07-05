import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/important_contacts_controller.dart';

class ImportantContactsView extends GetView<ImportantContactsController> {
  const ImportantContactsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ImportantContactsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ImportantContactsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
