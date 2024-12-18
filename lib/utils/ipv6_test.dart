import 'package:http/http.dart';

import '../config.dart';

Future<bool> ipv6Test() async {
  try {
    Response res = await get(Uri.parse(Config.ipv6TestUrl));
    return res.statusCode == 200;
  } catch (e) {
    return false;
  }
}
