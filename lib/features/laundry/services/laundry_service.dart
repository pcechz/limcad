
import 'package:limcad/features/laundry/model/about_response.dart';
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
}