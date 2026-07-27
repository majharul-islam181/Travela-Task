import '../core/constants/app_constants.dart';
import 'app_flavor.dart';

void configureProduction() {
  AppFlavorConfig.initialize(
    flavor: Flavor.production,
    appName: 'TravelaApp',
    baseUrl: AppConstants.apiBaseUrl,
    enableLogging: false,
  );
}
