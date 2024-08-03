import 'dart:async' show Future, Timer;
import 'package:flutter/material.dart';
import 'package:order_booking_shop/Views/HomePage.dart';
import 'package:order_booking_shop/Views/PolicyDBox.dart';
import 'package:order_booking_shop/Views/RSMS_Views/RSM_HomePage.dart';
import 'package:order_booking_shop/Views/SM/sm_homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API/Globals.dart';
import 'NSM/nsm_homepage.dart';
import 'login.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () async {
      bool isLoggedIn = await _checkLoginStatus();

      if (isLoggedIn) {
        // Redirect to the home page if the user is already logged in
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => const RSMHomepage(),
             // settings: RouteSettings(arguments: dataToPass)
          ),
        );
      }  else if (userDesignation == 'SM') {
        // Redirect to the HomePage if the user is an SO
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SMHomepage(),
          ),
        );
      } else if (userDesignation == 'NSM') {
        // Redirect to the HomePage if the user is an SO
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const NSMHomepage(),
          ),
        );
      }else if (userDesignation == 'SO'||userDesignation == 'SPO'||userDesignation == 'ASM'||userDesignation == 'SOS') {
        // Redirect to the HomePage if the user is an SO
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }else {
        // Redirect to the login page if the user is not logged in
        Navigator.of(context).push(
          MaterialPageRoute(
            // builder: (context) => const LoginForm(),
            builder: (context) => const PolicyDialog(),
            // settings: RouteSettings(arguments: dataToPass)
          ),
        );
      }
    });
  }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? userNames = prefs.getString('userNames');
    String? userCitys = prefs.getString('userCitys');
    String? userDesignation = prefs.getString('userDesignation');
    return userId != null && userId.isNotEmpty && userCitys!=null && userCitys.isNotEmpty && userNames!=null && userNames.isNotEmpty && userDesignation!=null && userDesignation.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Image.asset('assets/images/courage.jpeg'))

    );
  }
}
