import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/app_widgets.dart';
import 'package:news_flutter/components/bounce_tap_widget.dart';
import 'package:news_flutter/configs.dart';
import 'package:news_flutter/model/setting_item.dart';
import 'package:news_flutter/network/auth_service.dart';
import 'package:news_flutter/network/rest_apis.dart';
import 'package:news_flutter/screens/auth/components/otp_dialog_box.dart';
import 'package:news_flutter/screens/auth/sign_in_screen.dart';
import 'package:news_flutter/screens/dashboard/dashboard_screen.dart';
import 'package:news_flutter/screens/dashboard/profile_fragment.dart';
import 'package:news_flutter/screens/settings/setting_screen.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/constant.dart';
import 'package:news_flutter/utils/images.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../../../main.dart';

class ProfileWidget extends StatefulWidget {
  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    List<SettingItem> settingItem = [
      SettingItem(settingName: language.contactUs, settingImage: ic_email),
      SettingItem(settingName: language.share, settingImage: ic_send),
      SettingItem(settingName: language.settings, settingImage: ic_setting),
    ];

    return SingleChildScrollView(
      child: Container(
        height: context.height() * 0.50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          color: context.cardColor,
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 50,
                  height: 3,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey.shade300),
                ).paddingTop(16),
                if (!appStore.isLoggedIn)
                  Stack(
                    children: [
                      Row(
                        children: [
                          AppButton(
                            color: primaryColor,
                            elevation: 0,
                            text: language.signIn,
                            textStyle: boldTextStyle(color: Colors.white),
                            shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            onTap: () {
                              finish(context);
                              SignInScreen().launch(context);
                            },
                          ).expand(),
                          32.width,
                          CircleAvatar(
                            backgroundColor: Colors.grey.withOpacity(0.1),
                            child: GoogleLogoWidget(size: 20).paddingAll(8).onTap(() async {
                              appStore.setLoading(true);

                              await LogInWithGoogle().then((user) async {
                                appStore.setLoading(false);

                                DashboardScreen().launch(context, isNewTask: true);
                              });
                              appStore.setLoading(false);
                            }),
                          ),
                          8.width,
                          CircleAvatar(
                            backgroundColor: Colors.grey.withOpacity(0.1),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Image.asset(ic_call_ring, color: primaryColor, width: 30, height: 30),
                            ).onTap(() async {
                              await showInDialog(
                                context,
                                builder: (_) => OTPDialogBox(),
                                shape: dialogShape(),
                                backgroundColor: appStore.isDarkMode ? appBackGroundColor : scaffoldBackgroundLightColor,
                                barrierDismissible: false,
                              ).catchError((e) {
                                toast(e.toString());
                              });
                            }),
                          ),
                          if (isIOS)
                            CircleAvatar(
                              backgroundColor: Colors.grey.withOpacity(0.1),
                              child: Image.asset(ic_apple, color: appStore.isDarkMode ? white : black, width: 30, height: 30).paddingAll(8),
                            ).paddingLeft(8).onTap(
                              () async {
                                await appleSignIn().then((value) {
                                  DashboardScreen().launch(context, isNewTask: true);
                                }).catchError((e) {
                                  toast(e.toString());
                                  setState(() {});
                                });
                              },
                            ),
                        ],
                      ).paddingTop(16),
                      //CircularProgressIndicator().center().visible(appStore.isLoading),
                    ],
                  ).paddingAll(16),
                if (appStore.isLoggedIn)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          appStore.userProfileImage!.isNotEmpty
                              ? cachedImage(
                                  appStore.userProfileImage.toString(),
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ).cornerRadiusWithClipRRect(100)
                              : Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    appStore.userFirstName.validate().isNotEmpty ? appStore.userFirstName.validate()[0] : '',
                                    style: boldTextStyle(color: Colors.white, size: 26),
                                    textAlign: TextAlign.center,
                                  ).center(),
                                ),
                          16.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${appStore.userFirstName.validate()} ${appStore.userLastName.validate()}", style: boldTextStyle(size: 20)),
                              4.height,
                              Text(appStore.userEmail.validate().isNotEmpty ? appStore.userEmail.validate() : appStore.userMobileNumber.validate(), style: secondaryTextStyle(size: 14)),
                            ],
                          ),
                        ],
                      ).onTap(() {
                        finish(context);
                        ProfileFragment().launch(context);
                      }).expand(),
                      Image.asset(ic_logout, width: 30, height: 30, color: appStore.isDarkMode ? Colors.grey.shade500 : Colors.black).onTap(() {
                        showConfirmDialogCustom(
                          context,
                          title: language.logoutConfirmation,
                          primaryColor: primaryColor,
                          onAccept: (c) async {
                            finish(context);
                            logout(context);

                            DashboardScreen().launch(context, isNewTask: true);
                          },
                          dialogType: DialogType.CONFIRMATION,
                          negativeText: language.no,
                          positiveText: language.yes,
                        );
                      })
                    ],
                  ).paddingAll(16),
                Divider(thickness: 0.7),
                Wrap(
                  runSpacing: 16,
                  spacing: 16,
                  children: List.generate(
                    settingItem.length,
                    (index) => BounceTapWidget(
                      child: Container(
                        height: 100,
                        width: context.width() / 3 - 24,
                        decoration: BoxDecoration(
                          color: context.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: appStore.isDarkMode ? Colors.grey.shade900 : Colors.black12, blurRadius: 5.0, offset: Offset(0, 3))],
                          border: Border.all(color: appStore.isDarkMode ? Colors.grey.shade500 : Colors.white),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(settingItem[index].settingImage.validate(), width: 30, height: 30, color: primaryColor),
                            4.height,
                            Text(settingItem[index].settingName.validate(), style: boldTextStyle(size: 14), textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                      onTap: () async {
                        if (index == 0) {
                          const uri = 'mailto:$MAILTO';
                          url_launcher.launchUrl(Uri.parse(uri));
                        } else if (index == 1) {
                          finish(context);
                          onShareTap(context);
                        } else if (index == 2) {
                          finish(context);
                          SettingScreen().launch(context);
                        }
                      },
                    ),
                  ),
                ),
                VersionInfoWidget(prefixText: "${language.version} ", textStyle: secondaryTextStyle()),
                Text(companyTagLine, style: primaryTextStyle(color: Colors.grey.shade500, size: 14)),
                2.height,
              ],
            ),
            Observer(
              builder: (context) => Loader(color: primaryColor, valueColor: AlwaysStoppedAnimation(Colors.white)).center().visible(appStore.isLoading),
            ),
          ],
        ),
      ),
    );
  }
}
