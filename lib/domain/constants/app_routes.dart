import 'package:flutter/cupertino.dart';

import '../../ui/dashboard/dashboard_page.dart';
import '../../ui/on_boarding/login/login_page.dart';
import '../../ui/on_boarding/sign_up/signup_page.dart';
import '../../ui/splash/splash_page.dart';

class AppRoutes{

  static const String splash = "/";
  static const String login = "/login";
  static const String signUp = "/sign_up";
  static const String dashboard = "/dashboard";

  static Map<String, WidgetBuilder> mRoutes = {
    splash: (context) => SplashPage(),
    login: (context) => LoginPage(),
    signUp: (context) => SignUpPage(),
    dashboard: (context) => DashBoardPage()
  };

}