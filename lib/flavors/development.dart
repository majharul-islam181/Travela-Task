import '../core/constants/app_constants.dart';
import 'app_flavor.dart';

void configureDevelopment() {
  AppFlavorConfig.initialize(
    flavor: Flavor.development,
    appName: 'TravelaApp',
    baseUrl: AppConstants.apiBaseUrl,
    enableLogging: true,
  );
}
