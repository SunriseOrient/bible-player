import 'package:flutter/material.dart';

import 'settings/local_mode.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        children: const [
          LocalMode(),
        ],
      ),
    );
  }
}