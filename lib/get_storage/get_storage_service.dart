import 'package:get_storage/get_storage.dart';

class PreferenceManager {
  static GetStorage getStorage = GetStorage();

  static String loginStatus = "loginStatus";

  /// LogIn
  static Future setLogin(bool value) async {
    await getStorage.write(loginStatus, value);
  }

  static getLogin() {
    return getStorage.read(loginStatus);
  }

  static Future getClear() {
    return getStorage.erase();
  }
}
