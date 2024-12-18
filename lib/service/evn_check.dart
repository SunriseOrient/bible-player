import 'package:bible_player/service/toast.dart';
import 'package:bible_player/utils/ipv6_test.dart';
import 'package:flutter/material.dart';

Future<bool> evnCheck() async {
  if (await ipv6Test()) return true;
  Toast.showDialog(_createIpv6Tip());
  return false;
}

Widget _createIpv6Tip() {
  return const AlertDialog(
    title: Text(
      "网络环境不支持",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18),
    ),
    backgroundColor: Colors.white,
    shadowColor: Color.fromARGB(80, 0, 0, 0),
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Color.fromARGB(10, 0, 0, 0)),
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    ),
    elevation: 10,
    content: Text(
        "为了保证应用能够正常运行，您需要连接到IPv6网络。如果您使用手机流量，默认情况下支持IPv6连接。请检查您的网络设置或联系网络服务提供商以启用IPv6连接"),
  );
}
