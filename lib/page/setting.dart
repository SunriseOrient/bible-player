import 'package:bible_player/notifier/setting_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../entity/setting_data.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  SettingData settings = SettingData();

  @override
  void initState() {
    super.initState();

    SettingModel settingModel = Get.find<SettingModel>();
    setState(() {
      settings = settingModel.settings!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('离线模式'),
            trailing: Switch(
              value: settings.isOfflineMode,
              onChanged: (value) {
                setState(() {
                  settings.isOfflineMode = value;
                });
                Get.find<SettingModel>().updateSetting(settings);
              },
            ),
          ),
        ],
      ),
    );
  }
}
