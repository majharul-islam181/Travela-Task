import '../../core/di/core_di.dart' as core_di;
import '../../features/property_search/di/dashboard_di.dart';

Future<void> init() async {
  await core_di.initDependencies();
  initDashboard();
}
