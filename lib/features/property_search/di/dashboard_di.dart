import 'package:get_it/get_it.dart';
import '../../../core/network/dio_client.dart';
import '../data/datasources/location_remote_data_source.dart';
import '../data/datasources/property_search_remote_data_source.dart';
import '../data/repositories/location_repository_impl.dart';
import '../data/repositories/property_search_repository_impl.dart';
import '../domain/repositories/location_repository.dart';
import '../domain/repositories/property_search_repository.dart';
import '../domain/usecases/search_locations.dart';
import '../domain/usecases/search_properties_stream.dart';
import '../presentation/bloc/location_search_bloc.dart';
import '../presentation/bloc/property_search_bloc.dart';
import '../presentation/bloc/search_filter_bloc.dart';


final sl = GetIt.instance;

void initDashboard() {
  sl.registerLazySingleton<LocationRemoteDataSource>(
    () => LocationRemoteDataSource(sl<DioClient>()),
  );
  sl.registerLazySingleton<PropertySearchRemoteDataSource>(
    () => PropertySearchRemoteDataSource(sl<DioClient>()),
  );
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(sl<LocationRemoteDataSource>()),
  );
  sl.registerLazySingleton<PropertySearchRepository>(
    () => PropertySearchRepositoryImpl(sl<PropertySearchRemoteDataSource>()),
  );
  sl.registerLazySingleton<SearchLocations>(
    () => SearchLocations(sl<LocationRepository>()),
  );
  sl.registerLazySingleton<SearchPropertiesStream>(
    () => SearchPropertiesStream(sl<PropertySearchRepository>()),
  );
  sl.registerFactory<LocationSearchBloc>(
    () => LocationSearchBloc(sl<SearchLocations>()),
  );
  sl.registerFactory<PropertySearchBloc>(
    () => PropertySearchBloc(sl<SearchPropertiesStream>()),
  );
  sl.registerFactory<SearchFilterBloc>(() => SearchFilterBloc());
}
