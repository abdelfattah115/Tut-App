import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'pages/home/view/home_page.dart';
import 'pages/notification/notification_page.dart';
import '../resources/color_manager.dart';
import '../resources/string_manager.dart';
import '../resources/values_manager.dart';
import 'pages/search/search_page.dart';
import 'pages/setting/setting_page.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<Widget> pages = [
     HomePage(),
    const SearchPage(),
    const NotificationPage(),
    const SettingPage(),
  ];

  List<String> titles = [
    AppString.home.tr(),
    AppString.search.tr(),
    AppString.notifications.tr(),
    AppString.settings.tr(),
  ];

  String _title = AppString.home.tr();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          _title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar:
      BottomNavigationBar(
          elevation: AppSize.s4,
          backgroundColor: ColorManager.white,
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined), label: AppString.home.tr()),
            BottomNavigationBarItem(
                icon: const Icon(Icons.search), label: AppString.search.tr()),
            BottomNavigationBarItem(
                icon: const Icon(Icons.notifications), label: AppString.notifications.tr()),
            BottomNavigationBarItem(
                icon: const Icon(Icons.settings), label: AppString.settings.tr()),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: ColorManager.primary,
          unselectedItemColor: ColorManager.grey,
          onTap: onTap,
        ),
    );
  }

  onTap(int index) {
    setState(() {
      _currentIndex = index;
      _title = titles[index];
    });
  }
}
