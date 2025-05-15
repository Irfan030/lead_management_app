import 'package:leads_management_app/utils/apiConfig.dart';
import 'package:leads_management_app/utils/apiService.dart';

class Repository {
  Future getLeads(param) async {
    try {
      var url = ApiConfig.leadsApi("getAll", model: param['model']);
      var response = await ApiService.get(url, param['body']);
      return response;
    } catch (e) {
      return e;
    }
  }

  Future getLeadById(param) async {
    try {
      var url =
          ApiConfig.leadsApi("getById", model: param['model'], id: param['id']);
      var response = await ApiService.get(url, param['body']);
      return response;
    } catch (e) {
      print("Error in getLeadById: $e");
      return e;
    }
  }

  Future createLead(param) async {
    try {
      var url = ApiConfig.leadsApi("create", model: param['model']);
      var response = await ApiService.post(url, param['body']);
      return response;
    } catch (e) {
      return e;
    }
  }

  Future updateLead(param) async {
    try {
      var url =
          ApiConfig.leadsApi("update", model: param['model'], id: param['id']);
      var response = await ApiService.put(url, param['body']);
      return response;
    } catch (e) {
      return e;
    }
  }

  Future deleteLead(param) async {
    print("param delete : ${param}");
    try {
      var url =
          ApiConfig.leadsApi("delete", model: param['model'], id: param['id']);
      var response = await ApiService.delete(url);
      return response;
    } catch (e) {
      return e;
    }
  }
}
