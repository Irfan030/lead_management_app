import 'package:leads_management_app/constant.dart';

import '../screens/auth/sharedPreference.dart';

class HeaderProvider {
  static String? _authToken;
  static String? session;

  static Future<void> setAuthToken(String token) async {
    session = await SharedPreference.getStringValue(AppData.session);
    _authToken = token;
  }

  static void clearAuthToken() {
    _authToken = null;
  }

  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Domainname': AppData.domainname,
        'platform': AppData.platform,
        'login': 'admin',
        'password': 'admin',
        'api-key': session ?? '379d9fab-e005-45cf-9f7b-8eef00358c22',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };
}
