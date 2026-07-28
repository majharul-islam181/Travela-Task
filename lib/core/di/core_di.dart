import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../flavors/app_flavor.dart';
import '../../features/dashbaord/data/datasources/location_remote_data_source.dart';
import '../../features/dashbaord/presentation/cubit/location_search_cubit.dart';
import '../network/api_constants.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../storage/local_storage.dart';
import '../theme/theme_manager.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await _initStorage();
  _initNetwork();
  _initTheme();
  _initDashboard();
}

Future<void> _initStorage() async {
  final LocalStorage localStorage = await SharedPreferencesImpl.create();
  sl.registerLazySingleton<LocalStorage>(() => localStorage);
}

void _initNetwork() {
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: AppFlavorConfig.instance.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    ),
  );

  final Dio dio = sl<Dio>();
  if (AppFlavorConfig.instance.enableLogging) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
      ),
    );
  }

  sl.registerLazySingleton<DioClient>(() => DioClient(sl<Dio>()));
}

void _initTheme() {
  sl.registerFactory<ThemeBloc>(() => ThemeBloc(sl<LocalStorage>()));
}

void _initDashboard() {
  sl.registerLazySingleton<LocationRemoteDataSource>(
    () => LocationRemoteDataSource(sl<DioClient>()),
  );
  sl.registerFactory<LocationSearchCubit>(
    () => LocationSearchCubit(sl<LocationRemoteDataSource>()),
  );
}
