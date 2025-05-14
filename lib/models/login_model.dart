class login {
  String? message;
  bool? error;
  int? code;
  Results? results;

  login({this.message, this.error, this.code, this.results});

  login.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    error = json['error'];
    code = json['code'];
    results =
        json['results'] != null ? new Results.fromJson(json['results']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['error'] = this.error;
    data['code'] = this.code;
    if (this.results != null) {
      data['results'] = this.results!.toJson();
    }
    return data;
  }
}

class Results {
  Data? data;

  Results({this.data});

  Results.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  User? user;

  Data({this.user});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? mobileNo;
  Null? status;
  Null? createdBy;
  Null? countryCode;
  UserInformation? userInformation;
  String? role;
  Null? companyId;
  Null? userFranchiseId;

  User(
      {this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.mobileNo,
      this.status,
      this.createdBy,
      this.countryCode,
      this.userInformation,
      this.role,
      this.companyId,
      this.userFranchiseId});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobileNo = json['mobileNo'];
    status = json['status'];
    createdBy = json['createdBy'];
    countryCode = json['countryCode'];
    userInformation = json['UserInformation'] != null
        ? new UserInformation.fromJson(json['UserInformation'])
        : null;
    role = json['role'];
    companyId = json['companyId'];
    userFranchiseId = json['userFranchiseId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['mobileNo'] = this.mobileNo;
    data['status'] = this.status;
    data['createdBy'] = this.createdBy;
    data['countryCode'] = this.countryCode;
    if (this.userInformation != null) {
      data['UserInformation'] = this.userInformation!.toJson();
    }
    data['role'] = this.role;
    data['companyId'] = this.companyId;
    data['userFranchiseId'] = this.userFranchiseId;
    return data;
  }
}

class UserInformation {
  Null? profileImagePath;

  UserInformation({this.profileImagePath});

  UserInformation.fromJson(Map<String, dynamic> json) {
    profileImagePath = json['profileImagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileImagePath'] = this.profileImagePath;
    return data;
  }
}
