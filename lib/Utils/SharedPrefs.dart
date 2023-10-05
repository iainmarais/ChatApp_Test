// ignore_for_file: file_names, class_names, non_constant_identifier_names
import "package:shared_preferences/shared_preferences.dart";

//Use this class to handle shared preferences such as authentication token storage
class SharedPrefs
{
  static Future<void> SetToken(String token) async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("authToken", token);
  }
  static Future<String?> GetToken() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("authToken");
  }
  static Future<void> ClearToken() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("authToken");
  }
}