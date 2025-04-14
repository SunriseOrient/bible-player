import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service/local_pack.dart';
import '../../service/toast.dart';

String isLocalModeKey = "IS_LOCAL_MODE";

class LocalMode extends StatefulWidget {
  const LocalMode({super.key});

  @override
  State<LocalMode> createState() => _LocalModeState();
}

class _LocalModeState extends State<LocalMode> {
  bool isLocalMode = false;
  bool isAction = true;
  String prossess = "";

  late SharedPreferences prefs;

  _LocalModeState() {
    _init();
  }

  _init() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isLocalMode = prefs.getBool(isLocalModeKey) ?? false;
    });
  }

  void onChanged(bool value) async {
    try {
      setState(() {
        isAction = false;
      });
      if (value) {
        await enableLocalMode();
      } else {
        await closeLocalMode();
      }
    } catch (e) {
      Toast.showMessage("操作失败，请稍后再试！");
    } finally {
      setState(() {
        isAction = true;
      });
    }
  }

  // 开启
  Future enableLocalMode() async {
   await LocalPack.download();
    prefs.setBool(isLocalModeKey, true);
    setState(() {
      isLocalMode = true;
    });
  }

  // 关闭
  Future closeLocalMode() async {
    prefs.setBool(isLocalModeKey, false);
    setState(() {
      isLocalMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('离线模式'),
      subtitle: const Text('数据本地存储，断网也能使用'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(prossess),
          const SizedBox(width: 10),
          Switch(
            value: isLocalMode,
            onChanged: isAction ? onChanged : null,
          ),
        ],
      ),
    );
  }
}
