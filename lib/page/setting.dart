import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  // 离线模式开关状态
  bool _isOfflineMode = false;

  // 离线模式切换逻辑
  void _toggleOfflineMode(bool value) {
    setState(() {
      _isOfflineMode = value;
      // 在这里添加保存设置的逻辑，例如保存到本地存储
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
              value: _isOfflineMode,
              onChanged: (value) {
                _toggleOfflineMode(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
