import 'package:flutter/widgets.dart';

class NavigationApp {
  static navigate(String route, BuildContext context) {
    Navigator.of(context).pushNamed(route);
  }
  static backOneRoute(BuildContext context) {
    Navigator.of(context).pop();
  }
  static forcedNavigation(String route, BuildContext context) {
    Navigator.of(context).pushReplacementNamed(route);
  }
}