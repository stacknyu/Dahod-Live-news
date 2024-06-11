import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/configs.dart';
import 'package:news_flutter/main.dart';
import 'package:news_flutter/network/rest_apis.dart';
import 'package:news_flutter/screens/news/news_detail_screen.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/constant.dart';

import 'dashboard/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  final int? newsId;

  const SplashScreen({this.newsId});
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    _animationController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _animation = Tween<Offset>(begin: Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOutBack),
    );

    _animationController.forward();

    _animationController.addStatusListener((status) async {
      if (_animationController.isCompleted) {
        opacity = 1.0;
        setState(() {});

        await 500.milliseconds.delay;
        if (widget.newsId != null) {
          NewsDetailScreen(newsId: widget.newsId.toString()).launch(context, isNewTask: true);
        } else {
          if (!getBoolAsync(IS_REMEMBERED, defaultValue: true)) {
            logout(context);

            DashboardScreen().launch(context, isNewTask: true);
          } else {
            if (appStore.isLoggedIn) {
              appStore.setUserProfile(getStringAsync(PROFILE_IMAGE));
              appStore.setUserId(getIntAsync(USER_ID));
              appStore.setUserEmail(getStringAsync(USER_EMAIL));
              appStore.setFirstName(getStringAsync(FIRST_NAME));
              appStore.setLastName(getStringAsync(LAST_NAME));
              appStore.setUserLogin(getStringAsync(USER_LOGIN));
            }
            DashboardScreen().launch(context, isNewTask: true);
          }
        }
      }
    });

    setStatusBarColor(primaryColor, statusBarBrightness: Brightness.light);
  }

  @override
  void dispose() {
    setStatusBarColor(appStore.isDarkMode ? appBackGroundColor : Colors.white, statusBarBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: context.height(),
        width: context.width(),
        color: primaryColor,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SlideTransition(
              position: _animation,
              child: Image.asset(APP_ICON_RB, width: 120, height: 120),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedOpacity(
                  opacity: opacity,
                  duration: Duration(milliseconds: 700),
                  child: Text(APP_NAME, style: boldTextStyle(size: 32, color: Colors.white)),
                ),
                4.height,
                AnimatedOpacity(
                  opacity: opacity,
                  duration: Duration(milliseconds: 700),
                  child: Text(language.splashSubTitle, style: boldTextStyle(size: 18, color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
