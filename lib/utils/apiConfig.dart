class ApiConfig {
  static const Map<String, String> authApi = {
    "connect": "/odoo_connect",
  };
  static String leadsApi(String action, {required String model, int? id}) {
    switch (action) {
      case "getAll":
        return "/send_request?model=$model";
      case "getById":
        return "/send_request?model=$model&Id=$id";
      case "create":
        return "/send_request?model=$model";
      case "update":
        return "/send_request?model=$model&Id=$id";
      case "delete":
        return "/send_request?model=$model&Id=$id";
      default:
        throw Exception("Invalid action type");
    }
  }
}
