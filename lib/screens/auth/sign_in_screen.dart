import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/app_widgets.dart';
import 'package:news_flutter/components/social_buttons.dart';
import 'package:news_flutter/configs.dart';
import 'package:news_flutter/main.dart';
import 'package:news_flutter/network/rest_apis.dart';
import 'package:news_flutter/screens/auth/components/forget_email_dialog.dart';
import 'package:news_flutter/screens/auth/sign_up_screen.dart';
import 'package:news_flutter/screens/dashboard/dashboard_screen.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:news_flutter/utils/constant.dart';
import 'package:news_flutter/utils/images.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool? isSelectedCheck = false;
  var isVisibility = true;
  var formKey = GlobalKey<FormState>();
  var autoValidate = false;

  var emailCont = TextEditingController();
  var passwordCont = TextEditingController();

  var passwordFocus = FocusNode();

  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (isIOS) {
      TheAppleSignIn.onCredentialRevoked!.listen((_) {
        log("Credentials revoked");
      });
    }

    if (!getBoolAsync(IS_SOCIAL_LOGIN) && getBoolAsync(IS_REMEMBERED)) {
      emailCont.text = getStringAsync(USER_EMAIL_USERNAME);
      passwordCont.text = getStringAsync(USER_PASSWORD);
    }
  }

  Future<void> signInApi(req) async {
    appStore.setLoading(true);
    await login(req, isSocialLogin: getBoolAsync(IS_SOCIAL_LOGIN)).then((res) async {
      appStore.setLoading(false);

      DashboardScreen().launch(context, isNewTask: true);
    }).catchError((error) {
      appStore.setLoading(false);

      toast(error.toString());
    });
  }

  Future<void> validate() async {
    hideKeyboard(context);
    if (!accessAllowed) {
      toast("Sorry");
      return;
    }

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      var request = {};
      if (getBoolAsync(IS_SOCIAL_LOGIN)) {
        request = {
          "username": "${emailCont.text}",
          "phone": "${getStringAsync(USER_MOBILE_NUMBER)}",
          "loginType": "${getStringAsync(LOGIN_TYPE)}",
        };
      } else {
        request = {
          "username": "${emailCont.text}",
          "password": "${passwordCont.text}",
        };
      }

      if (emailCont.text.isEmpty)
        toast("Email Address " + Field_Required);
      else if (passwordCont.text.isEmpty)
        toast("Password " + Field_Required);
      else {
        await setValue(USER_PASSWORD, passwordCont.text);
        await setValue(USER_EMAIL_USERNAME, emailCont.text);
        await signInApi(request);
      }
    } else {
      isFirstTime = !isFirstTime;
      setState(() {});
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (_) {
          return Stack(
            children: [
              SizedBox(
                width: context.width(),
                height: context.height(),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: context.statusBarHeight),
                  child: Form(
                    key: formKey,
                    autovalidateMode: isFirstTime ? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios, size: 20),
                            onPressed: () {
                              finish(context);
                            },
                          ),
                        ),
                        8.height,
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            cachedImage(APP_ICON, height: 90, width: 90).cornerRadiusWithClipRRect(defaultRadius),
                            8.height,
                            Text(APP_NAME, style: boldTextStyle(size: 28)),
                          ],
                        ),
                        16.height,
                        Text(
                          language.titleForSignIn,
                          style: boldTextStyle(size: textSizeLargeMedium),
                        ),
                        16.height,
                        Text(language.welcomeMsgForSignIn, style: secondaryTextStyle(size: textSizeSMedium)),
                        24.height,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AppTextField(
                              controller: emailCont,
                              textFieldType: TextFieldType.USERNAME,
                              decoration: inputDecoration(
                                context,
                                labelText: '${language.email}' + ' / ' + '${language.userName}',
                                prefix: true,
                                prefixIcon: cachedImage(ic_email, height: 16, width: 16, color: Colors.grey.shade500),
                              ),
                              nextFocus: passwordFocus,
                              cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
                            ),
                            16.height,
                            TextFormField(
                              controller: passwordCont,
                              focusNode: passwordFocus,
                              obscureText: isVisibility,
                              autovalidateMode: isFirstTime ? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
                              decoration: inputDecoration(
                                context,
                                hint: language.password,
                                suffix: true,
                                suffixIcon: cachedImage(isVisibility ? ic_hide : ic_show, height: 16, width: 16, color: Colors.grey.shade500),
                                onIconTap: () {
                                  setState(() {
                                    isVisibility = !isVisibility;
                                  });
                                },
                                prefix: true,
                                prefixIcon: cachedImage(ic_password, height: 16, width: 16, color: Colors.grey.shade500),
                              ),
                              cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
                              textInputAction: TextInputAction.done,
                              validator: (s) {
                                if (s.validate().isEmpty) {
                                  return errorThisFieldRequired;
                                } else if (s.validate().length < 6) {
                                  return language.passwordLength;
                                }
                                return null;
                              },
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 16),
                        16.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: getBoolAsync(IS_REMEMBERED, defaultValue: false),
                                    side: MaterialStateBorderSide.resolveWith((states) => BorderSide(width: 1.0, color: Colors.grey.shade500)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                    activeColor: primaryColor,
                                    checkColor: white,
                                    onChanged: (v) {
                                      isSelectedCheck = v;
                                      setValue(IS_REMEMBERED, v);
                                      setState(() {});
                                    },
                                  ),
                                ),
                                4.width,
                                TextButton(
                                  onPressed: () {
                                    setValue(IS_REMEMBERED, !getBoolAsync(IS_REMEMBERED));
                                    isSelectedCheck = !isSelectedCheck!;
                                    setState(() {});
                                  },
                                  child: Text(
                                    language.rememberME,
                                    style: primaryTextStyle(size: textSizeSMedium),
                                  ),
                                ),
                              ],
                            ).expand(),
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => ForgetEmailDialog(),
                                );
                              },
                              child: Text(
                                language.forgotPassword,
                                style: primaryTextStyle(color: primaryColor),
                              ),
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 16),
                        24.height,
                        AppButton(
                          width: context.width(),
                          color: primaryColor,
                          elevation: 0,
                          shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Text(language.signIn, style: primaryTextStyle(color: white_color, size: textSizeLargeMedium)),
                          onTap: () {
                            validate();
                          },
                          margin: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        24.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              language.dontHaveAccount,
                              style: secondaryTextStyle(size: textSizeMedium),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: GestureDetector(
                                child: Text(
                                  language.signUp,
                                  style: TextStyle(decoration: TextDecoration.underline, color: primaryColor, fontSize: textSizeMedium.toDouble()),
                                ),
                                onTap: () {
                                  SignUpScreen().launch(context);
                                },
                              ),
                            )
                          ],
                        ),
                        25.height,
                        Text(
                          language.signInWith,
                          style: secondaryTextStyle(size: textSizeMedium),
                        ),
                        16.height,
                        SocialButtons(),
                        16.height,
                      ],
                    ),
                  ),
                ),
              ),
              Loader(color: primaryColor, valueColor: AlwaysStoppedAnimation(Colors.white)).center().visible(appStore.isLoading),
            ],
          );
        },
      ),
    );
  }
}
