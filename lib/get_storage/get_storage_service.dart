import 'package:get_storage/get_storage.dart';

class PreferenceManager {
  static GetStorage getStorage = GetStorage();

  static String loginStatus = "loginStatus";
  static String adminPassword = "adminPassword";
  static String adminEmail = "adminEmail";

  /// LogIn
  static Future setLogin(bool value) async {
    await getStorage.write(loginStatus, value);
  }

  static getLogin() {
    return getStorage.read(loginStatus);
  }

  /// Admin Password
  static Future setAdminPassword(String value) async {
    await getStorage.write(adminPassword, value);
  }

  static getAdminPassword() {
    return getStorage.read(adminPassword);
  }

  /// Admin Email
  static Future setAdminEmail(String value) async {
    await getStorage.write(adminEmail, value);
  }

  static getAdminEmail() {
    return getStorage.read(adminEmail);
  }

  static Future getClear() {
    return getStorage.erase();
  }
}
