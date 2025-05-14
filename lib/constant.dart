import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:leads_management_app/theme/colors.dart';

class AppData {
  static String appName = "Leads Manager";
  static String domainname = "gomotires.com";
  static String platform = "mobile";
  static String apiBaseUrl = "http://95.216.18.133:8076";

  // static String apiBaseUrl = "https://gomobile.firebridge.co.za/";

  static const profile = "assets/images/user.jpg";
  static String poppinsRegular = "PoppinsRegular";
  static String poppinsSemiBold = "PoppinsSemiBold";
  static String poppinsMedium = "PoppinsMedium";
  static String poppinsItalic = "PoppinsItalic";
  static String poppinsBold = "PoppinsBold";
  static String poppinsLight = "PoppinsLight";

  static String imageBaseUrl = apiBaseUrl;

  static String dbName = "firebridge_crm_v17";
  static String session = "session";
  static String userId = "userId";
  static String userDetials = "userDetials";
  static String role = "role";
  static String firstName = "firstName";
  static String lastName = "lastName";

  static showSnackBar(BuildContext context, String message,
      {Color backgroundColor = Colors.green}) {
    final snackBar =
        SnackBar(content: Text(message), backgroundColor: backgroundColor);

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static bool isPasswordValid(String password) {
    return !RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{8,}$',
    ).hasMatch(password);
  }

  static bool isInvalidEmail(String email) {
    // Renamed to be clearer
    return !RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email.trim());
  }

  static bool isInvalidPhoneNo(String phoneNo) {
    // Renamed to be clearer
    return !RegExp(r'^[1-9][0-9]{8}$').hasMatch(phoneNo.trim());
  }

  static isEmptyCheck(String val) {
    if (val.isEmpty) {
      return true;
    }
    return false;
  }

  static isEmptyErrorMsg(String val, String name) {
    if (val.isEmpty) {
      return "$name is required";
    }
    return "";
  }

  static nameValidation(String val) {
    if (val.isEmpty) {
      return true;
    } else if (val.length > 25) {
      return true;
    }
    return false;
  }

  static nameErrorMsg(String val, String name) {
    if (val.isEmpty) {
      return "$name is required";
    } else if (val.length > 25) {
      return "${name}must be less than 25 character";
    }
    return "";
  }

  static bool lengthValidation(String val, int maxChar) {
    if (val.isEmpty) {
      return true;
    } else if (val.length > maxChar) {
      return true;
    }
    return false;
  }

  static bool addressValidation(String val) {
    if (val.isEmpty) {
      return true;
    } else if (val.length > 25) {
      return true;
    }
    return false;
  }

  static String addressErrorMsg(String val) {
    if (val.isEmpty) {
      return "Address is required";
    } else if (val.length > 25) {
      return "Address must be less than 25 character";
    }
    return "";
  }

  static String invalidErrorMsg(String errorName) {
    return "Please enter a valid $errorName";
  }

  static bool phoneValidation(String val) {
    final phoneRegex = RegExp(r'^\+?1?\d{10}$');
    if (!phoneRegex.hasMatch(val)) {
      return true;
    }
    return false;
  }

  static String phoneErrorMsg(String val) {
    if (val.isEmpty) {
      return "Phone number is required";
    } else if (!RegExp(r'^\+?1?\d{10}$').hasMatch(val)) {
      return "Enter a valid 10-digit US phone number";
    }
    return "";
  }

  static bool zipCodeValidation(String val) {
    final zipCodeRegex = RegExp(r'^\d{5}$');
    if (!zipCodeRegex.hasMatch(val)) {
      return true;
    }
    return false;
  }

  static String zipCodeErrorMsg(String val) {
    if (val.isEmpty) {
      return "ZIP code is required";
    } else if (!RegExp(r'^\d{5}$').hasMatch(val)) {
      return "Enter a valid 5-digit ZIP code";
    }
    return "";
  }

  static descriptionValidation(String val) {
    if (val.isEmpty) {
      return true;
    } else if (val.length > 150) {
      return true;
    }
    return false;
  }

  static otpValidation(String val, bool isMesssage) {
    if (val.isEmpty) {
      return isMesssage ? "Otp is required" : true;
    } else if (!RegExp(r'^\d{4}$').hasMatch(val)) {
      return isMesssage ? "Invalid otp" : true;
    }
    return isMesssage ? "" : false;
  }

  static handleHtmlResponse(BuildContext context, String html) {
    final document = html_parser.parse(html);
    final h2Text = document.querySelector('h2')?.text;
    final errorMessage = h2Text ?? "Something went wrong";
    if (h2Text != null) {
      showSnackBar(
        context,
        errorMessage,
        backgroundColor: AppColor.errorColor,
      );
      return;

      // Example: show a dialog in Flutter
    }
  }
}

// Move the extension OUTSIDE the class
extension ColorExtensions on Color {
  Color withAlphaDouble(double opacity) {
    return withAlpha((opacity * 255).round());
  }
}
