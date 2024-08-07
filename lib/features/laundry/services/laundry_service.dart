
import 'package:limcad/features/laundry/model/about_response.dart';
import 'package:limcad/features/laundry/model/laundry_service_response.dart';
import 'package:limcad/resources/api/api_client.dart';
import 'package:limcad/resources/api/route.dart';
import 'package:limcad/resources/locator.dart';
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
}