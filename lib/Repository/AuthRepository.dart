import 'package:leads_management_app/utils/apiService.dart';

class Authrepository {
  Future signUp(param) async {
    try {
      var response = await ApiService.post("auth/create-user", param);
      return response.data;
    } catch (e) {
      return e;
    }
  }

  Future login(param) async {
    try {
      var response = await ApiService.login("/odoo_connect", param);
      // api.sendRequest.options.headers['Authorization'] =
      //     response.headers['Authorization']?[0];
      return response;
    } catch (e) {
      return e;
    }
  }
}
