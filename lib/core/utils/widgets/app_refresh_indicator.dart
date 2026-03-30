import 'package:daily_language/core/constants/colors_app.dart';
import 'package:flutter/material.dart';

class AppRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const AppRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: ColorApp.primary,
      backgroundColor: Colors.white,
      strokeWidth: 2.5,
      child: child,
    );
  }
}
