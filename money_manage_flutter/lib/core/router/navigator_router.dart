import 'package:go_router/go_router.dart';
import '../../export/ui_external.dart';

class NavigatorRouter {
  static Future<void> pushTo(
    BuildContext context,
    String routeName, {
    Object? extra,
  }) async {
    await context.push(routeName, extra: extra);
  }

  static Future<void> pushNamed(
    BuildContext context,
    String routeName, {
    Map<String, String>? pathParameters,
    Object? extra,
  }) async {
    await context.pushNamed(
      routeName,
      pathParameters: pathParameters ?? {},
      extra: extra,
    );
  }

  static void pushReplacement(
    BuildContext context,
    String routeName, {
    Object? extra,
  }) {
    context.pushReplacement(routeName, extra: extra);
  }

  static void popUntil(BuildContext context, String routeName) {
    final router = GoRouter.of(context);

    String? currentLocation() {
      final config = router.routerDelegate.currentConfiguration;
      if (config.isNotEmpty) {
        return config.last.matchedLocation;
      }
      return null;
    }

    while (currentLocation() != routeName && router.canPop()) {
      router.pop();
    }
  }

  static void popFullRouteAndGo(BuildContext context, String routeName) {
    context.go(routeName);
  }

  static void popAndSwitchTabMainBranch(BuildContext context, int branchIndex) {
    final shell = NavigationShellHolder.shell;

    if (shell == null) return;

    // Branch == -1 tức là không cần phải chuyển tab
    if (branchIndex != -1) {
      shell.goBranch(branchIndex, initialLocation: true);
    } else {
      // Quay về main presentation nhưng giữ nguyên tab hiện tại
      shell.goBranch(shell.currentIndex);
    }
  }
}

class NavigationShellHolder {
  static StatefulNavigationShell? shell;
}
