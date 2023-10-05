// ignore_for_file: file_names, class_names, non_constant_identifier_names
import "dart:async";

import "SharedPrefs.dart";

class AuthenticationInfo
{
    final bool IsAuthenticated;
    final String? token;
    AuthenticationInfo(this.IsAuthenticated, this.token);
}

class AuthController
{   
    final StreamController<AuthenticationInfo> _authController =
    StreamController<AuthenticationInfo>.broadcast();
    Stream<AuthenticationInfo> get authStream => _authController.stream;
    void initialise()
    {
      _authController.add(AuthenticationInfo(false, null));
    }
    void setAuthentication(bool IsAuthenticated, String? token)
    {
      _authController.add(AuthenticationInfo(IsAuthenticated, token));
    }
    void login()
    {
      setAuthentication(true, SharedPrefs.GetToken() as String?);
    }
    void logoff()
    {
      setAuthentication(false, null);
    }
}
final authController = AuthController();