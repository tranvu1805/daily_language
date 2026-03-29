import 'package:daily_language/core/constants/colors_app.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.child, required this.title});
  final Widget child;
  final String title;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: textTheme.titleMedium?.copyWith(color: Colors.white)),
        backgroundColor: ColorApp.primary,
        centerTitle: true,
      ),
      body: child,
    );
  }
}
