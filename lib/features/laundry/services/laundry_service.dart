
import 'package:limcad/features/auth/services/signup_service.dart';
import 'package:limcad/features/laundry/model/about_response.dart';
import 'package:limcad/features/laundry/model/laundry_orders_response.dart';
import 'package:limcad/features/laundry/model/laundry_service_response.dart';
import 'package:limcad/resources/api/api_client.dart';
import 'package:limcad/resources/api/route.dart';
import 'package:limcad/resources/locator.dart';
import 'package:limcad/resources/models/no_object_response.dart';
import 'package:stacked/stacked.dart';

import '../../../resources/api/base_response.dart';

class LaundryService with ListenableServiceMixin {
  final apiService = locator<APIClient>();


  Future<AboutResponse?> getAbout() async {
    var response = await apiService.request(
        route: ApiRoute(ApiType.laundyAbout, routeParams: "1"),
        create: () => BaseResponse<AboutResponse>(create: () => AboutResponse()));
    return response.response.data;
  }


  Future<BaseResponse<LaundryServiceResponse>?> getLaundryServiceItems() async {
    var response = await apiService.request(
        route: ApiRoute(ApiType.laundyServiceItems, routeParams: "organizationId=1&page=1&size=4"),
        create: () => BaseResponse<LaundryServiceResponse>(create: () => LaundryServiceResponse()));
    return response.response;
  }


  Future<BaseResponse<LaundryOrders>?> getLaundryOrders() async {
    var response = await apiService.request(
        route: ApiRoute(ApiType.laundyOrders),
        create: () => BaseResponse<LaundryOrders>(create: () => LaundryOrders()));
    return response.response;
  }


  Future<BaseResponse<NoObjectResponse>> submitOrder(Map<String, dynamic> orderItemJson) async {
    final orderRequest = {
      "organizationId": 1,
      "orderDetails":  // Use a list instead of a set
        orderItemJson,
      "deliveryDetails": {
        "addressId": locator<AuthenticationService>().profile?.address?[0].id,
        "pickupDate": "2024-08-20"
      }
    };
    var loginResponse = await apiService.request(
        route: ApiRoute(ApiType.submitOrder, routeParams: "paymentMode=CASH"),
        data: orderRequest,
        create: () =>
            BaseResponse<NoObjectResponse>(create: () => NoObjectResponse())
    );
    return loginResponse.response;
  }




}