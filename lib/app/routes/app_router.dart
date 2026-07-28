import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/property_search/presentation/pages/dashbaord_page.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.dashboard,
    routes: [
      GoRoute(
        path: AppRoutes.dashboard,
        name: AppRouteNames.dashboard,
        builder: (final BuildContext context, final GoRouterState state) {
          return const DashboardPage();
        },
      ),
    ],
    errorBuilder: (final BuildContext context, final GoRouterState state) {
      return const _RouteNotFoundPage();
    },
  );
}

class _RouteNotFoundPage extends StatelessWidget {
  const _RouteNotFoundPage();

  @override
  Widget build(final BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(
        child: Text('Route not found', style: textTheme.titleMedium),
      ),
    );
  }
}
