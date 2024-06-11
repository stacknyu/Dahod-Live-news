import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/app_theme.dart';
import 'package:news_flutter/language/app_localizations.dart';
import 'package:news_flutter/language/languages.dart';
import 'package:news_flutter/model/dashboard_model.dart';
import 'package:news_flutter/model/post_model.dart';
import 'package:news_flutter/model/weather_model.dart';
import 'package:news_flutter/screens/news/news_detail_screen.dart';
import 'package:news_flutter/screens/notifications/notification_list_screen.dart';
import 'package:news_flutter/screens/notifications/web_view_screen.dart';
import 'package:news_flutter/screens/splash_screen.dart';
import 'package:news_flutter/store/app_store.dart';
import 'package:news_flutter/store/bookmark/bookmark_store.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:news_flutter/utils/constant.dart';
import 'package:news_flutter/utils/one_signal_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'model/language_model.dart';

late PackageInfoData packageInfo;

AppStore appStore = AppStore();
BookmarkStore bookmarkStore = BookmarkStore();

int mInterstitialAdCount = 0;

late BaseLanguage language;

//region Cached Response Variables for Dashboard Tabs
DashboardModel? cachedDashBoardData;
WeatherModel? cachedWeatherData;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialize(aLocaleLanguageList: getLanguages());

  if (isMobile) {
    await Firebase.initializeApp().then((value) async {
      MobileAds.instance.initialize();
      initOneSignal();
    }).catchError(onError);

    await setupFirebaseRemoteConfig().then((remoteConfig) async {
      if (isIOS) {
        await setValue(HAS_IN_REVIEW, remoteConfig.getBool(HAS_IN_APP_STORE_REVIEW));
      } else if (isAndroid) {
        // await setValue(HAS_IN_REVIEW, true);
        await setValue(HAS_IN_REVIEW, remoteConfig.getBool(HAS_IN_PLAY_STORE_REVIEW));
      }
    }).catchError((e) {
      toast(e.toString());
    });
  }

  packageInfo = await getPackageInfo();

  defaultRadius = 12.0;

  appStore.setDarkMode(getBoolAsync(IS_DARK_THEME));
  appStore.setLanguage(getStringAsync(LANGUAGE, defaultValue: defaultLanguage));
  appStore.setTTSLanguage(getStringAsync(TEXT_TO_SPEECH_LANG, defaultValue: defaultTTSLanguage));
  appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN));

  String bookmarkString = getStringAsync(WISHLIST_ITEM_LIST);
  if (bookmarkString.isNotEmpty) {
    bookmarkStore.addAllBookmark(jsonDecode(bookmarkString).map<PostModel>((e) => PostModel.fromJson(e)).toList());
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  StreamSubscription? shareLink;
  @override
  void initState() {
    super.initState();
    setOrientationPortrait();

    Connectivity().onConnectivityChanged.listen((event) {
      appStore.setInternetStatus(event.contains(ConnectivityResult.mobile) || event.contains(ConnectivityResult.wifi) || event.contains(ConnectivityResult.ethernet));
    });

    afterBuildCreated(() {
      OneSignal.Notifications.addClickListener((event) {
        try {
          var notId = event.notification.additionalData!.containsKey('id') ? event.notification.additionalData!['id'] : 0;
          if (notId.toString().isNotEmpty) {
            push(NewsDetailScreen(newsId: notId.toString()));
          } else if (event.notification.launchUrl.validate().isNotEmpty) {
            launchUrl(event.notification.launchUrl.validate());
          } else {
            if (event.notification.additionalData!.containsKey('video_url')) {
              String? videoUrl = event.notification.additionalData!['video_url'];
              String? videoType = event.notification.additionalData!['video_type'];
              push(WebViewScreen(videoUrl: videoUrl, videoType: videoType));
            } else
              NotificationListScreen().launch(context);
          }
        } catch (e) {
          throw errorSomethingWentWrong;
        }
      });
    });
  }

  MaterialPageRoute handleDeepLink(String link) {
    if (link.isDigit()) {
      return MaterialPageRoute(
        builder: (context) {
          return SplashScreen(newsId: link.toInt());
        },
      );
    } else {
      return MaterialPageRoute(builder: (_) => SplashScreen());
    }
  }

  @override
  void dispose() {
    shareLink?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        supportedLocales: LanguageDataModel.languageLocales(),
        localizationsDelegates: [
          AppLocalizations(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) => locale,
        locale: Locale(appStore.selectedLanguageCode.validate(value: defaultLanguage)),
        home: SplashScreen(),
        onGenerateRoute: (settings) {
          String link = settings.name!.split('/').last;
          // Mimic web routing
          return handleDeepLink(link);
        },
      ),
    );
  }
}
