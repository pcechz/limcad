import 'package:dio/dio.dart';

enum ApiType { registerUser, requestEmailOtp, validateEmailOtp, states, lgas, login, profile, laundyAbout }

class ApiRoute implements APIRouteConfigurable {
  final ApiType type;
  final String? routeParams;
  final Map<String, dynamic>? data;
  final headers = {
    'accept': 'application/json',
    'content-type': 'application/json'
  };

  ApiRoute(this.type, {this.routeParams, this.data});

  @override
  RequestOptions? getConfig() {
    final authorize = {'Authorize': true};

    switch (type) {
      //register
      case ApiType.registerUser:
        return RequestOptions(
            path: '/users/registration', method: ApiMethod.post, data: data);

      case ApiType.login:
        return RequestOptions(
            path: '/auth/login', method: ApiMethod.post, data: data);

      //
      //states
      case ApiType.states:
        return RequestOptions(
            path: '/states?$routeParams', method: ApiMethod.get);

      case ApiType.profile:
        return RequestOptions(
            path: '/users/profile', method: ApiMethod.get, extra: authorize);

      //lgas
      case ApiType.lgas:
        return RequestOptions(
            path: '/lgas/$routeParams', method: ApiMethod.get);

      //requestOtp
      case ApiType.requestEmailOtp:
        return RequestOptions(
            path: '/auth/email-verification-code-request',
            method: ApiMethod.post,
            data: data);

      case ApiType.validateEmailOtp:
        return RequestOptions(
            path: '/auth/email-verification',
            method: ApiMethod.post,
            data: data,
            extra: authorize);

      case ApiType.laundyAbout:
        return RequestOptions(
            path: '/laundry-about/organizations/$routeParams', method: ApiMethod.get);
      default:
        return null;
    }
  }
}

abstract class APIRouteConfigurable {
  RequestOptions? getConfig();
}

class ApiMethod {
  static const get = 'GET';
  static const post = 'POST';
  static const put = 'PUT';
  static const patch = 'PATCH';
  static const delete = 'DELETE';
}
