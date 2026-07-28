class ApiConstants {
  ApiConstants._();

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);

  static const String popularLocationsEndpoint = '/api/popular-locations';
}
