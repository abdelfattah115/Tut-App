import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:udvanced_flutter/presentation/onboarding/view/onboarding_view.dart';
import 'package:udvanced_flutter/presentation/resources/string_manager.dart';

import '../../app/di.dart';
import '../forgot_password/view/forgot_password_view.dart';
import '../login/view/login_view.dart';
import '../main/main_view.dart';
import '../register/view/register_view.dart';
import '../splash/splash_view.dart';
import '../store_details/view/store_details_view.dart';

class Routes{
  static const String splashRoute = '/';
  static const String onBoardingRoute = '/onBoarding';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String forgotPasswordRoute = '/forgotPassword';
  static const String storeDetailsRoute = '/storeDetails';
  static const String mainRoute = '/main';
}

class RouteGenerator{
  static Route<dynamic> getRoute(RouteSettings settings){
    switch(settings.name){
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_)=> const SplashView());
      case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (_)=> const OnBoardingView());
      case Routes.loginRoute:
        initLoginModule();
        return MaterialPageRoute(builder: (_)=> const LoginView());
      case Routes.registerRoute:
        initRegisterModule();
        return MaterialPageRoute(builder: (_)=> const RegisterView());
      case Routes.mainRoute:
        initHomeModule();
        return MaterialPageRoute(builder: (_)=> const MainView());
      case Routes.forgotPasswordRoute:
        initForgotPasswordModule();
        return MaterialPageRoute(builder: (_)=> const ForgotPasswordView());
      case Routes.storeDetailsRoute:
        initStoreDetailsModule();
        return MaterialPageRoute(builder: (_)=> const StoreDetailsView());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute(){
    return MaterialPageRoute(builder: (_)=> Scaffold(
      appBar: AppBar(title: Text(AppString.noRouteFound.tr()),),
      body:  Center(child: Text(AppString.noRouteFound.tr()),),
    ));
  }
}