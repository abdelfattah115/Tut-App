import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import '../../../resources/language_manager.dart';
import '../../../../data/data_source/local_data_source.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/route_manager.dart';
import '../../../resources/string_manager.dart';
import '../../../resources/values_manager.dart';
import '../../../../app/app_prefs.dart';
import '../../../../app/di.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final LocalDataSource _localDataSource = instance<LocalDataSource>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: const EdgeInsets.all(AppPadding.p8),
        children: [
          ListTile(
            leading: SvgPicture.asset(ImageAssets.settingsIc),
            title: Text(
              AppString.changeLanguage.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(isRTL() ? math.pi : 0),
              child:  SvgPicture.asset(ImageAssets.settingArrowIc),
            ),
            onTap: () {
              _changeLanguage();
            },
          ),
          ListTile(
            leading: SvgPicture.asset(ImageAssets.contactusIc),
            title: Text(
              AppString.contactUs.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing:
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(isRTL() ? math.pi : 0),
              child:  SvgPicture.asset(ImageAssets.settingArrowIc),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: SvgPicture.asset(ImageAssets.inviteFriendsIc),
            title: Text(
              AppString.inviteYourFriends.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(isRTL() ? math.pi : 0),
              child:  SvgPicture.asset(ImageAssets.settingArrowIc),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: SvgPicture.asset(ImageAssets.logoutIc),
            title: Text(
              AppString.logout.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              _logout();
            },
          ),
        ],
      ),
    );
  }

  bool isRTL(){
    return context.locale == ARABIC_LOCAL;
  }

  _logout() {
    _appPreferences.logout();
    _localDataSource.clearCache();
    Navigator.pushReplacementNamed(context, Routes.loginRoute);
  }

  _changeLanguage() {
    _appPreferences.changeAppLanguage();
    Phoenix.rebirth(context);
  }
}
