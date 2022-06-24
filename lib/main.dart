import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:udvanced_flutter/presentation/resources/language_manager.dart';

import 'app/di.dart';
import 'app/app.dart';
import 'presentation/resources/color_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: ColorManager.primary,

  ));
  await initAppModule();
  runApp(EasyLocalization(
      child: Phoenix(child: MyApp()),
      supportedLocales: const [ENGLISH_LOCAL, ARABIC_LOCAL],
      path: LANGUAGE_LOCAL_PATH));
}
