import 'dart:io';
import 'dart:typed_data';

import 'package:limcad/features/auth/services/signup_service.dart';
import 'package:limcad/features/laundry/model/about_response.dart';
import 'package:limcad/features/laundry/model/business_order_detail_response.dart';
import 'package:limcad/features/laundry/model/file_response.dart';
import 'package:limcad/features/laundry/model/laundry_order_response.dart';
import 'package:limcad/features/laundry/model/laundry_orders_response.dart';
import 'package:limcad/features/laundry/model/laundry_service_response.dart';
import 'package:limcad/features/laundry/model/review_response.dart';
import 'package:limcad/resources/api/api_client.dart';
import 'package:limcad/resources/api/route.dart';
import 'package:limcad/resources/locator.dart';
import 'package:limcad/resources/models/no_object_response.dart';
import 'package:limcad/resources/models/profile.dart';
import 'package:limcad/resources/storage/base_preference.dart';
import 'package:limcad/resources/widgets/view_utils/view_utils.dart';
import 'package:stacked/stacked.dart';
import 'package:path/path.dart' as p;
import '../../../resources/api/base_response.dart';

class LaundryService with ListenableServiceMixin {
  final apiService = locator<APIClient>();

  Future<AboutResponse?> getAbout() async {
    var response = await apiService.request(
        route: ApiRoute(ApiType.laundyAbout, routeParams: "8"),
        create: () =>
            BaseResponse<AboutResponse>(create: () => AboutResponse()));
    return response.response.data;
  }

  Future<BaseResponse<LaundryServiceResponse>?> getLaundryServiceItems() async {
    var response = await apiService.request(
        route: ApiRoute(ApiType.laundyServiceItems,
            routeParams: "organizationId=6&page=0&size=10"),
        create: () => BaseResponse<LaundryServiceResponse>(
            create: () => LaundryServiceResponse()));
    return response.response;
  }

  Future<BaseResponse<LaundryOrders>?> getLaundryOrders() async {
    var response = await apiService.request(
        route: ApiRoute(ApiType.laundyOrders),
        create: () =>
            BaseResponse<LaundryOrders>(create: () => LaundryOrders()));
    return response.response;
  }

  Future<BaseResponse<NoObjectResponse>> submitOrder(
      Map<String, dynamic> orderItemJson,
      int organizationId,
      ProfileResponse? profile) async {
    // BasePreference basePreference = await BasePreference.getInstance();

    // var profileResponse = await locator<AuthenticationService>().getProfile();
    final orderRequest = {
      "organizationId": organizationId,
      "orderDetails": // Use a list instead of a set
          orderItemJson,
      "deliveryDetails": {
        "addressId": profile?.address?[0].id,
        "pickupDate": "2024-08-20"
      }
    };
// 4,9,11
    // print("Order Request: ${profileResponse.toString()}");

    var loginResponse = await apiService.request(
        route: ApiRoute(ApiType.submitOrder, routeParams: "paymentMode=CASH"),
        data: orderRequest,
        create: () =>
            BaseResponse<NoObjectResponse>(create: () => NoObjectResponse()));
    return loginResponse.response;
  }

  Future<BaseResponse<LaundryOrderResponse>> getBusinessOrder() async {
    var response = await apiService.request(
        route: ApiRoute(ApiType.businessOrders),
        create: () => BaseResponse<LaundryOrderResponse>(
            create: () => LaundryOrderResponse()));

    return response.response;
  }

  Future<BusinessOrderDetailResponse?> getBusinessOrderDetail(int id) async {
    var response = await apiService.request(
        route: ApiRoute(ApiType.businessOrdersDetails, routeParams: "$id"),
        create: () => BaseResponse<BusinessOrderDetailResponse>(
            create: () => BusinessOrderDetailResponse()));
    return response.response.data;
  }

  Future<BaseResponse<BusinessOrderDetailResponse>> updateStatus(
      int id, String status) async {
    var request = {"status": status};
    var response = await apiService.request(
        route:
            ApiRoute(ApiType.updateBusinessOrdersDetails, routeParams: "$id"),
        data: request,
        create: () => BaseResponse<BusinessOrderDetailResponse>(
            create: () => BusinessOrderDetailResponse()));
    return response.response;
  }

  Future<BaseResponse<NoObjectResponse>> uploadFile(File file) async {
    final request = {
      "file": p.basename(file.path),
      "type": determineFileType(file)
    };
    var loginResponse = await apiService.request(
        route: ApiRoute(ApiType.uploadFile),
        data: request,
        create: () =>
            BaseResponse<NoObjectResponse>(create: () => NoObjectResponse()));
    return loginResponse.response;
  }

  Future<BaseResponse<FileResponse>> getFile(int id) async {
    var loginResponse = await apiService.request(
        route: ApiRoute(ApiType.getFile, routeParams: "$id"),
        create: () => BaseResponse<FileResponse>(create: () => FileResponse()));
    return loginResponse.response;
  }

  Future<BaseResponse<NoObjectResponse>> submitReview(
      int star, int id, String text) async {
    final request = {"organizationId": 6, "rating": star, "reviewText": text};
    var loginResponse = await apiService.request(
        route: ApiRoute(ApiType.submitReview),
        data: request,
        create: () =>
            BaseResponse<NoObjectResponse>(create: () => NoObjectResponse()));
    return loginResponse.response;
  }

  Future<BaseResponse<ReviewServiceResponse>> getReview(int id) async {
    var response = await apiService.request(
        route: ApiRoute(ApiType.getReview, routeParams: "$id?page=0&size=10"),
        create: () => BaseResponse<ReviewServiceResponse>(
            create: () => ReviewServiceResponse()));
    return response.response;
  }

  static String determineFileType(File file) {
    String extension = p.extension(file.path);

    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.pdf':
        return 'application/pdf';
      case '.txt':
        return 'text/plain';
      case '.docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case '.xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      default:
        return 'application/octet-stream'; // Generic fallback
    }
  }
}
