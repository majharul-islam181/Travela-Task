class AppConstants {
  AppConstants._();

  static const String appName = 'TravelaApp';
  static const String appversion = '1.0.0';

  static const String apiBaseUrl = 'https://search.travela.xyz';
  static  String locationSearchEndpoint( String query) => '/api/popular-locations?q=$query';

}
