import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:limcad/config/flavor.dart';
import 'package:limcad/features/auth/services/signup_service.dart';
import 'package:limcad/features/laundry/services/laundry_service.dart';import 'package:limcad/resources/api/api_client.dart';
import 'package:limcad/resources/api/authentication_interceptor.dart';
import 'package:limcad/resources/api/log_interceptor.dart';



GetIt locator = GetIt.I;
void setupLocator({FlavorConfig? instance}) {
  GetIt.I.registerLazySingleton(
        () => APIClient(
      BaseOptions(
        baseUrl: "http://172.187.176.43/api",
        // baseUrl: instance?.envConfig().baseUrl ??
        //     FlavorConfig.instance!.envConfig().baseUrl,
        receiveTimeout: const Duration(milliseconds: 180000),
        // Duration(
        //   milliseconds: instance?.envConfig().readTimeout ??
        //       FlavorConfig.instance!.envConfig().readTimeout,
       // ),
        connectTimeout: Duration(milliseconds: 30000
        ),
      ),
    ),
  );
  final interceptors = [
    APILogInterceptor(),
    AuthenticationInterceptor(client: locator<APIClient>()),
  ];
  locator<APIClient>().instance.interceptors.addAll(interceptors);

  GetIt.I.registerLazySingleton(() => AuthenticationService());
  GetIt.I.registerLazySingleton(() => LaundryService());


}
