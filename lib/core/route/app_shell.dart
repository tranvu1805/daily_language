import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/extension/extension_method.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  static final List<Icon> _icons = [
    Icon(Icons.home_outlined),
    Icon(Icons.edit_calendar_rounded),
    Icon(Icons.menu_book_rounded),
    Icon(Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final curIndex = widget.navigationShell.currentIndex;
    final label = [context.l10n.home, context.l10n.diary, context.l10n.words, context.l10n.profile];
    return Scaffold(
      backgroundColor: ColorApp.pureWhite,
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {},
        backgroundColor: ColorApp.primary,
        elevation: 4,
        child: const Icon(Icons.add, color: ColorApp.pureWhite),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //Todo: use bottom app bar to create notch for floating action button
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: ColorApp.pureWhite,
        selectedItemColor: ColorApp.primary,
        currentIndex: curIndex,
        items: List.generate(
          _icons.length,
          (index) => BottomNavigationBarItem(icon: _icons[index], label: label[index]),
        ),
        onTap: (index) => widget.navigationShell.goBranch(index, initialLocation: true),
      ),
      body: widget.navigationShell,
    );
  }
}
