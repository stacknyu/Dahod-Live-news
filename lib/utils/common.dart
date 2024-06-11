import 'package:country_picker/country_picker.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tab;
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/main.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import 'colors.dart';
import 'constant.dart';

Future<FirebaseRemoteConfig> setupFirebaseRemoteConfig() async {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  remoteConfig.setConfigSettings(RemoteConfigSettings(fetchTimeout: Duration.zero, minimumFetchInterval: Duration.zero));
  await remoteConfig.fetch();
  await remoteConfig.fetchAndActivate();

  return remoteConfig;
}

SystemUiOverlayStyle defaultSystemUiOverlayStyle(BuildContext context, {Color? color, Brightness? statusBarIconBrightness}) {
  return SystemUiOverlayStyle(statusBarColor: color ?? context.scaffoldBackgroundColor, statusBarIconBrightness: statusBarIconBrightness ?? (appStore.isDarkMode ? Brightness.light : Brightness.dark));
}

void getDisposeStatusBarColor({Color? colors}) {
  setStatusBarColor(colors ?? (appStore.isDarkMode.validate() ? scaffoldDarkColor : scaffoldLightColor), statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark);
}

String convertDate(date) {
  try {
    return date != null ? DateFormat(dateFormat).format(DateTime.parse(date)) : '';
  } catch (e) {
    print(e);
    return '';
  }
}

String duration2String(Duration? dur, {showLive = 'Live'}) {
  Duration duration = dur ?? Duration();
  if (duration.inSeconds < 0)
    return showLive;
  else {
    return duration.toString().split('.').first.padLeft(8, "0");
  }
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

void redirectUrl(url) async {
  await url_launcher.launchUrl(Uri.parse(url));
}

Future<void> launchUrl(String url) async {
  try {
    await custom_tab.launchUrl(
      Uri.parse(url.validate()),
      customTabsOptions: custom_tab.CustomTabsOptions(
        colorSchemes: custom_tab.CustomTabsColorSchemes.defaults(toolbarColor: primaryColor),
        animations: custom_tab.CustomTabsSystemAnimations.slideIn(),
        urlBarHidingEnabled: true,
        shareState: custom_tab.CustomTabsShareState.on,
        browser: custom_tab.CustomTabsBrowserConfiguration(
          fallbackCustomTabs: [
            'org.mozilla.firefox',
            'com.microsoft.emmx',
          ],
          headers: {'key': 'value'},
        ),
      ),
      safariVCOptions: custom_tab.SafariViewControllerOptions(
        barCollapsingEnabled: true,
        dismissButtonStyle: custom_tab.SafariViewControllerDismissButtonStyle.close,
        entersReaderIfAvailable: false,
        preferredControlTintColor: Colors.white,
        preferredBarTintColor: primaryColor,
      ),
    );
  } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
  }
}

InputDecoration inputDecoration(
  BuildContext context, {
  String? hint,
  Widget? prefixIcon,
  Widget? suffixIcon,
  bool prefix = false,
  bool suffix = false,
  VoidCallback? onIconTap,
  double? borderRadius,
  TextStyle? hintStyle,
  String? labelText,
  TextStyle? labelStyle,
  String? hintText,
  EdgeInsets? contentPadding,
}) {
  return InputDecoration(
    contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    prefix: prefix ? prefixIcon.paddingOnly(right: 8) : null,
    suffix: suffixIcon,
    labelText: labelText ?? hint,
    labelStyle: secondaryTextStyle(),
    hintText: hintText,
    hintStyle: secondaryTextStyle(),
    alignLabelWithHint: true,
    enabledBorder: OutlineInputBorder(
      gapPadding: 0,
      borderRadius: radius(borderRadius ?? editTextRadius),
      borderSide: BorderSide.none,
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? editTextRadius),
      borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? editTextRadius),
      borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? editTextRadius),
      borderSide: BorderSide(color: primaryColor, width: 1.0),
    ),
    fillColor: context.cardColor,
    filled: true,
  );
}

int findMiddleFactor(int n) {
  List<int?> num = [];
  for (int i = 1; i <= n; i++) {
    if (n % i == 0 && i > 1 && i < 20) {
      num.add(i);
    }
  }
  return num[num.length ~/ 2]!;
}

String getWishes() {
  if (DateTime.now().hour > 0 && DateTime.now().hour < 12) {
    return language.goodMorning;
  } else if (DateTime.now().hour >= 12 && DateTime.now().hour < 16) {
    return language.goodAfternoon;
  } else {
    return language.goodEvening;
  }
}

String getPostContent(String? postContent) {
  return postContent
      .validate()
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('[embed]', '<embed>')
      .replaceAll('[/embed]', '</embed>')
      .replaceAll('[caption]', '<caption>')
      .replaceAll('[/caption]', '</caption>')
      .replaceAll('[blockquote]', '<blockquote>')
      .replaceAll('[/blockquote]', '</blockquote>');
}

Country defaultCountry() {
  return Country(
    phoneCode: '91',
    countryCode: 'IN',
    e164Sc: 91,
    geographic: true,
    level: 1,
    name: 'India',
    example: '9123456789',
    displayName: 'India (IN) [+91]',
    displayNameNoCountryCode: 'India (IN)',
    e164Key: '91-IN-0',
    fullExampleWithPlusSign: '+919123456789',
  );
}

void ifNotTester(BuildContext context, VoidCallback callback) {
  if (appStore.userEmail != demoUserEmail) {
    callback.call();
  } else {
    toast(language.lblUnAuthorized);
  }
}
