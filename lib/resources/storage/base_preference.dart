import 'dart:convert';

import 'package:limcad/features/auth/models/login_response.dart';
import 'package:limcad/features/auth/models/signup_response.dart';
import 'package:limcad/resources/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BasePreference {
  static BasePreference? instance;
  SharedPreferences preferences;

  BasePreference({required this.preferences});

  static Future<BasePreference> getInstance() async {
    if (instance != null) {
      return instance!;
    } else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      return BasePreference(preferences: preferences);
    }
  }

  static const _token = "token";
  static const _loginResponse = "loginResponse";
  static const _profile = "profile";
  static const _isRegistered = "isRegistered";
  static const _businessLoginResponse = "businessloginResponse";
  static const _hasAddedAnAboutUs = "hasAddedAnAboutUs";

  void saveIsRegistered(bool isRegistered) {
    preferences.setBool(_isRegistered, isRegistered);
  }

  void saveHasAddedAnAboutUs(bool value) {
    preferences.setBool(_hasAddedAnAboutUs, value);
  }

  bool getHasAddedAnAboutUs() {
    bool? value = preferences.getBool(_hasAddedAnAboutUs);
    if (value != null) {
      return value;
    }
    return false;
  }

  bool getIsRegistered() {
    bool? isRegistered = preferences.getBool(_isRegistered);
    if (isRegistered != null) {
      return isRegistered;
    }
    return false;
  }

  void saveLoginDetails(User profile) {
    preferences.setString(_loginResponse, json.encode(profile.toJson()));
  }

  void saveBusinessLoginDetails(User profile) {
    preferences.setString(
        _businessLoginResponse, json.encode(profile.toJson()));
  }

  User? getBusinessLoginDetails() {
    String? string = preferences.getString(_businessLoginResponse);
    if (string != null) {
      return User().fromJson(json.decode(string));
    }
    return null;
  }

  User? getLoginDetails() {
    String? string = preferences.getString(_loginResponse);
    if (string != null) {
      return User().fromJson(json.decode(string));
    }
    return null;
  }

  void saveProfileDetails(ProfileResponse profile) {
    preferences.setString(_profile, json.encode(profile.toJson()));
  }

  ProfileResponse? getProfileDetails() {
    String? string = preferences.getString(_profile);
    if (string != null) {
      return ProfileResponse().fromJson(json.decode(string));
    }
    return null;
  }

  void saveToken(Tokens tokens) {
    preferences.setString(_token, json.encode(tokens.toJson()));
  }

  Tokens? getTokens() {
    String? string = preferences.getString(_token);
    if (string != null) {
      return Tokens.fromJson(json.decode(string));
    }
    return null;
  }
}
