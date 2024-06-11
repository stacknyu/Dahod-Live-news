import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/components/back_widget.dart';
import 'package:news_flutter/configs.dart';
import 'package:news_flutter/model/language_model.dart';
import 'package:news_flutter/network/auth_service.dart';
import 'package:news_flutter/network/rest_apis.dart';
import 'package:news_flutter/screens/auth/change_password_screen.dart';
import 'package:news_flutter/screens/dashboard/profile_fragment.dart';
import 'package:news_flutter/screens/settings/about_us_screen.dart';
import 'package:news_flutter/screens/settings/choose_detail_page_variant_screen.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:news_flutter/utils/constant.dart';

import '../../main.dart';
import '../dashboard/dashboard_screen.dart';

class SettingScreen extends StatefulWidget {
  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  List<int> fontSizeList = [8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34];
  int? fontSize = 18;
  bool isAdsLoading = false;
  int selectedLanguage = 0;
  int selectedTTsLang = 0;
  String? lang;
  String? ttsLang;

  BannerAd? myBanner;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    myBanner = buildBannerAd()..load();
    selectedLanguage = getIntAsync(SELECTED_LANGUAGE_INDEX);
    selectedTTsLang = getIntAsync(TTS_SELECTED_LANGUAGE_INDEX);
    lang = getLanguages()[selectedLanguage].name;
    ttsLang = getLanguagesForTTS()[selectedTTsLang].name;
    setState(() {});
    if (await isNetworkAvailable()) {
      setState(
        () {
          isAdsLoading = isAdsLoading;
        },
      );
    }
  }

  BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: BANNER_AD_ID_FOR_ANDROID,
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          //
        },
      ),
      request: AdRequest(),
    );
  }

  void handlePreFetching(bool v) async {
    allowPreFetched = v;

    await setValue(allowPreFetchedPref, allowPreFetched);

    if (!allowPreFetched) {
      await removeKey(dashboardData);
      await removeKey(categoryData);
      await removeKey(videoListData);
      await removeKey(bookmarkData);
    }

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    myBanner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.settings,
        center: true,
        color: appStore.isDarkMode ? card_color_dark : white,
        elevation: 0.2,
        backWidget: BackWidget(color: context.iconColor),
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 80),
            child: Column(
              children: [
                SettingSection(
                  title: Text(language.accountSetting, style: boldTextStyle(size: textSizeMedium)),
                  headingDecoration: BoxDecoration(color: appStore.isDarkMode ? card_color_dark : white),
                  divider: Divider(color: Colors.transparent, height: 0.0),
                  items: [
                    SettingItemWidget(
                      title: language.editProfile,
                      titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                      trailing: Icon(Icons.keyboard_arrow_right, size: 28, color: context.iconColor),
                      onTap: () {
                        ProfileFragment().launch(context);
                      },
                    ),
                    Divider(color: gray.withOpacity(0.2), height: 0, indent: 16, endIndent: 16),
                    SettingItemWidget(
                      title: '${language.changePassword}',
                      titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                      trailing: Icon(Icons.keyboard_arrow_right, size: 28, color: context.iconColor),
                      onTap: () {
                        ChangePasswordScreen().launch(context);
                      },
                    ),
                  ],
                ).visible(appStore.isLoggedIn),
                SettingSection(
                  title: Text(language.notificationSetting, style: boldTextStyle(size: textSizeMedium)),
                  headingDecoration: BoxDecoration(color: appStore.isDarkMode ? card_color_dark : white),
                  divider: Divider(color: Colors.transparent, height: 0.0),
                  items: [
                    Observer(
                      builder: (_) => SettingItemWidget(
                        title: '${appStore.isNotificationOn ? language.disable : language.enable} ${language.pushNotification}',
                        titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                        trailing: Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                            activeColor: primaryColor,
                            value: appStore.isNotificationOn,
                            onChanged: (v) async {
                              appStore.setNotification(v);
                            },
                          ),
                        ),
                        onTap: () async {
                          appStore.setNotification(
                            !getBoolAsync(IS_NOTIFICATION_ON, defaultValue: false),
                          );
                        },
                      ),
                    ),
                  ],
                ).visible(appStore.isLoggedIn),
                SettingSection(
                  title: Text(language.appSetting, style: boldTextStyle(size: textSizeMedium)),
                  headingDecoration: BoxDecoration(color: appStore.isDarkMode ? card_color_dark : white),
                  divider: Divider(color: Colors.transparent, height: 0.0),
                  items: [
                    SettingItemWidget(
                      title: language.nightMode,
                      titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                      trailing: Transform.scale(
                        scale: 0.7,
                        child: CupertinoSwitch(
                          activeColor: primaryColor,
                          value: appStore.isDarkMode,
                          onChanged: (v) async {
                            appStore.setDarkMode(!appStore.isDarkMode);
                          },
                        ),
                      ),
                      onTap: () async {
                        appStore.setDarkMode(!appStore.isDarkMode);
                      },
                    ),
                    Divider(color: gray.withOpacity(0.2), height: 0, indent: 16, endIndent: 16),
                    SettingItemWidget(
                      title: '${language.allowPrefetching}',
                      titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                      trailing: Transform.scale(
                        scale: 0.7,
                        child: CupertinoSwitch(
                          activeColor: primaryColor,
                          value: allowPreFetched,
                          onChanged: (v) async {
                            handlePreFetching(v);
                          },
                        ),
                      ),
                      onTap: () async {
                        handlePreFetching(!allowPreFetched);
                      },
                    ),
                    Divider(color: gray.withOpacity(0.2), height: 0, indent: 16, endIndent: 16),
                    SettingItemWidget(
                      title: '${language.testToSpeechLanguage}',
                      titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                      trailing: Container(
                        decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(8), backgroundColor: context.cardColor),
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isDense: true,
                            icon: Icon(Icons.keyboard_arrow_down_sharp, color: context.iconColor).paddingLeft(10),
                            value: getLanguagesForTTS()[selectedTTsLang].name,
                            dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                            onChanged: (dynamic newValue) async {
                              for (var i = 0; i < getLanguagesForTTS().length; i++) {
                                if (newValue == getLanguagesForTTS()[i].name) {
                                  selectedTTsLang = i;
                                  setState(() {});
                                }
                              }
                              await setValue(TTS_SELECTED_LANGUAGE_INDEX, selectedTTsLang);
                              await setValue(TEXT_TO_SPEECH_LANG, selectedTTsLang.toString());

                              setState(() {});
                              toast("${getLanguagesForTTS()[selectedTTsLang].name} is Default language for Text to Speech");
                            },
                            items: getLanguagesForTTS().map(
                              (ttsLanguage) {
                                return DropdownMenuItem(
                                  child: Row(
                                    children: <Widget>[
                                      8.width,
                                      Text(ttsLanguage.name.validate(), style: primaryTextStyle()),
                                    ],
                                  ),
                                  value: ttsLanguage.name,
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                    ),
                    Divider(color: gray.withOpacity(0.2), height: 0, indent: 16, endIndent: 16),
                    SettingItemWidget(
                      title: '${language.language}',
                      titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                      trailing: Container(
                        decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(8), backgroundColor: context.cardColor),
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isDense: true,
                            icon: Icon(Icons.keyboard_arrow_down_sharp, color: context.iconColor).paddingLeft(10),
                            value: getLanguages()[selectedLanguage].name,
                            dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                            onChanged: (dynamic newValue) async {
                              for (var i = 0; i < getLanguages().length; i++) {
                                if (newValue == getLanguages()[i].name) {
                                  selectedLanguage = i;
                                  setState(() {});
                                }
                              }

                              await setValue(SELECTED_LANGUAGE_CODE, getLanguages()[selectedLanguage].languageCode);
                              await setValue(SELECTED_LANGUAGE_INDEX, selectedLanguage);

                              await setValue(LANGUAGE, selectedLanguage.toString());
                              appStore.setLanguage(getLanguages()[selectedLanguage].languageCode.toString().validate());
                              setState(() {});
                            },
                            items: getLanguages().map(
                              (x) {
                                return DropdownMenuItem(
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(x.flag.validate(), width: 24, height: 24),
                                      SizedBox(width: 10),
                                      Text(x.name.validate(), style: primaryTextStyle()),
                                    ],
                                  ),
                                  value: x.name.validate(),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                    ).visible(isLanguageEnable),
                    Divider(color: gray.withOpacity(0.2), height: 0, indent: 16, endIndent: 16),
                    SettingItemWidget(
                      title: '${language.chooseDetailPageVariant}',
                      titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                      padding: EdgeInsets.all(16),
                      trailing: Row(
                        children: [
                          Icon(Icons.check_circle, color: context.iconColor, size: 16),
                          2.width,
                          Text(language.variant + ' ${getIntAsync(DETAIL_PAGE_VARIANT) == 0 ? '1' : getIntAsync(DETAIL_PAGE_VARIANT)}', style: boldTextStyle()),
                        ],
                      ),
                      onTap: () async {
                        bool? res = await ChooseDetailPageVariantScreen().launch(context);
                        if (res ?? false) {
                          setState(() {});
                        }
                      },
                    ),
                  ],
                ),
                SettingSection(
                  title: Text(language.about, style: boldTextStyle(size: textSizeMedium)),
                  headingDecoration: BoxDecoration(color: appStore.isDarkMode ? card_color_dark : white),
                  divider: Divider(color: Colors.transparent, height: 0.0),
                  items: [
                    SettingItemWidget(
                      title: '${language.about}',
                      titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                      trailing: Icon(Icons.keyboard_arrow_right, size: 28, color: context.iconColor),
                      onTap: () async {
                        AboutUsScreen().launch(context);
                      },
                    ),
                    Divider(color: gray.withOpacity(0.2), height: 0, indent: 16, endIndent: 16),
                    SettingItemWidget(
                      title: '${language.ourWebsite}',
                      titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                      trailing: Icon(Icons.keyboard_arrow_right, size: 28, color: context.iconColor),
                      onTap: () async {
                        launchUrl(SITE_URL).then((value) {
                          setStatusBarColor(
                            appStore.isDarkMode ? card_color_dark : card_color_light,
                            statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
                          );
                        });
                      },
                    ),
                    Divider(color: gray.withOpacity(0.2), height: 0, indent: 16, endIndent: 16),
                    if (appStore.isLoggedIn)
                      SettingItemWidget(
                        title: language.logout,
                        titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                        trailing: Icon(Icons.keyboard_arrow_right, size: 28, color: context.iconColor),
                        onTap: () {
                          showConfirmDialogCustom(
                            context,
                            title: language.logoutConfirmation,
                            primaryColor: primaryColor,
                            onAccept: (c) async {
                              logout(context);

                              DashboardScreen().launch(context, isNewTask: true);
                            },
                            dialogType: DialogType.CONFIRMATION,
                            negativeText: language.no,
                            positiveText: language.yes,
                          );
                        },
                      ),
                  ],
                ),
                24.height,
                SettingSection(
                  title: Text(language.accountSetting, style: boldTextStyle(size: textSizeMedium)),
                  headingDecoration: BoxDecoration(color: appStore.isDarkMode ? card_color_dark : white),
                  divider: Divider(color: Colors.transparent, height: 0.0),
                  items: [
                    SettingItemWidget(
                      title: language.deleteAccount,
                      titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? white : settingTextColor),
                      trailing: Icon(Icons.keyboard_arrow_right, size: 28, color: context.iconColor),
                      onTap: () async {
                        showConfirmDialogCustom(
                          context,
                          dialogType: DialogType.DELETE,
                          title: language.deleteAccount + "?",
                          onAccept: (p0) {
                            ifNotTester(context, () {
                              appStore.setLoading(true);
                              toast(language.waitForAWhile);
                              deleteAccount().then((value) {
                                appStore.setLoading(false);
                                toast(value.message);
                                if (value.status ?? false) {
                                  logout(context);
                                  DashboardScreen().launch(context, isNewTask: true);
                                }
                              }).catchError((e) {
                                appStore.setLoading(false);
                                toast(e.toString());
                              });
                            });
                          },
                        );
                      },
                    ),
                  ],
                ).visible(appStore.isLoggedIn),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: !isAdsDisabled && myBanner != null
                ? Container(
                    color: context.scaffoldBackgroundColor,
                    height: 60,
                    child: myBanner != null ? AdWidget(ad: myBanner!) : SizedBox(),
                  )
                : SizedBox(),
          ),
          Observer(builder: (_) => Loader(color: primaryColor, valueColor: AlwaysStoppedAnimation(Colors.white)).center().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
