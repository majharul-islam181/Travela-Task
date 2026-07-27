import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
// import '../../flavors/app_flavor.dart';
import '../network/api_interceptor.dart';
import '../network/api_constants.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  _initNetwork();
}

void _initNetwork() {
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // sl.registerLazySingleton<Dio>(
  //   () => Dio(
  //     BaseOptions(
  //       baseUrl: AppFlavorConfig.instance.baseUrl,
  //       connectTimeout: ApiConstants.connectTimeout,
  //       receiveTimeout: ApiConstants.receiveTimeout,
  //       headers: const {
  //         'Accept': 'application/json',
  //         'Content-Type': 'application/json',
  //       },
  //     ),
  //   ),
  // );

  // final Dio dio = sl<Dio>();
  // if (AppFlavorConfig.instance.enableLogging) {
  //   dio.interceptors.add(
  //     PrettyDioLogger(
  //       requestHeader: true,
  //       requestBody: true,
  //       responseHeader: false,
  //     ),
  //   );
  // }

  sl.registerLazySingleton<DioClient>(() => DioClient(sl<Dio>()));
}
