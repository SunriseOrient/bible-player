import 'package:get/get.dart';

import '../entity/setting_data.dart';

class SettingModel extends GetxController {
  SettingData? settings;

  // 更新设置
  void updateSetting(SettingData settings) {
    this.settings = settings;
    update(['settingChange']);
  }
}
