import 'package:bible_player/service/toast.dart';
import 'package:bible_player/utils/ipv6_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

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

Widget _createNoNetworkTip() {
  return const AlertDialog(
    title: Text(
      "网络连接失败",
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
    content: Text("请检查您的网络设置或联系网络服务提供商以启用网络连接"),
  );
}

Future<bool> networkCheck() async {
  final List<ConnectivityResult> connectivityResult =
      await (Connectivity().checkConnectivity());
  if (connectivityResult.contains(ConnectivityResult.none)) {
    Toast.showDialog((context) => _createNoNetworkTip());
    return false;
  }
  if (!await ipv6Test()) {
    Toast.showDialog((context) => _createIpv6Tip());
    return false;
  }
  return true;
}
