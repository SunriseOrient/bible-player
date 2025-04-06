import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:app_version_compare/app_version_compare.dart';
import 'package:bible_player/service/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../config.dart';
import '../entity/update_info.dart';
import 'package:http/http.dart' as http;

class UpdateCheck {
  static final ReceivePort _port = ReceivePort();
  static String? taskId;
  static String? localPath;

  static Future<void> checkUpdate() async {
    UpdateInfo? updateInfo = await _getUpdateInfo();
    if (updateInfo == null) return;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    AppVersion remoteVersion = AppVersion.fromString(updateInfo.version);
    AppVersion appCurrentVersion = AppVersion.fromString(packageInfo.version);
    print("当前版本: ${packageInfo.version}");
    print("远程版本: ${updateInfo.version}");
    if (appCurrentVersion >= remoteVersion) {
      print("当前版本为最新版本");
      return;
    }
    _showUpdateDialog(updateInfo);
  }

  // 获取更新信息 release-data.json
  static Future<UpdateInfo?> _getUpdateInfo() async {
    try {
      http.Response response = await http
          .get(Uri.parse('${Config.httpBase}/update_data/release-data.json'));
      dynamic jsonMap =
          jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
      UpdateInfo updateInfo = UpdateInfo.fromJson(jsonMap);
      print("获取更新信息成功: ${updateInfo.toJson()}");
      return updateInfo;
    } catch (e) {
      print("获取更新信息失败: $e");
      return null;
    }
  }

  // 显示更新提示对话框
  static void _showUpdateDialog(UpdateInfo updateInfo) {
    Toast.showDialog((overlayEntry) => AlertDialog(
          title: Text(
            "V${updateInfo.version} 新版来袭！",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
          backgroundColor: Colors.white,
          shadowColor: const Color.fromARGB(80, 0, 0, 0),
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Color.fromARGB(10, 0, 0, 0)),
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          elevation: 10,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: updateInfo.upgradeInstructions
                .map((item) => Text(item))
                .toList(),
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            TextButton(
              onPressed: () {
                overlayEntry.remove();
              },
              child: const Text(
                "稍后更新",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                _downloadUpdate(updateInfo);
                overlayEntry.remove();
              },
              child: const Text(
                "立即更新",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ));
  }

  // 下载更新
  static void _downloadUpdate(UpdateInfo updateInfo) async {
    await Permission.notification.request();

    PermissionStatus status = await Permission.requestInstallPackages.request();
    if (!status.isGranted) return;

    await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
    initPort();

    Directory? downloadsDir = Directory("/storage/emulated/0/Download");
    if (!downloadsDir.existsSync()) {
      downloadsDir = await getDownloadsDirectory();
    }
    if (downloadsDir == null) return;
    print("下载目录: ${downloadsDir.path}");

    localPath = "${downloadsDir.path}/${updateInfo.fileName}";
    File localFile = File(localPath!);
    if (localFile.existsSync()) {
      localFile.deleteSync();
    }

    taskId = await FlutterDownloader.enqueue(
      url:
          '${Config.httpBase}/update_data/v${updateInfo.version}/${updateInfo.fileName}',
      savedDir: downloadsDir.path,
      fileName: updateInfo.fileName,
      saveInPublicStorage: true,
    );
  }

  // 初始化隔离管道
  static void initPort() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      if (id != taskId) return;
      if (data[2] != 100) return;
      if (DownloadTaskStatus.fromInt(data[1]) == DownloadTaskStatus.complete) {
        sleep(const Duration(seconds: 1));
        FlutterDownloader.open(taskId: id);
        IsolateNameServer.removePortNameMapping('downloader_send_port');
      }
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }
}
