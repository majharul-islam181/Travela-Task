class ApiConstants {
  ApiConstants._();

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);

  static  String locationSearchEndpoint( String query) => '/api/popular-locations?q=$query';

}
