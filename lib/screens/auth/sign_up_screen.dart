import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/app_widgets.dart';
import 'package:news_flutter/configs.dart';
import 'package:news_flutter/model/login_response.dart';
import 'package:news_flutter/network/rest_apis.dart';
import 'package:news_flutter/screens/auth/sign_in_screen.dart';
import 'package:news_flutter/screens/dashboard/dashboard_screen.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:news_flutter/utils/constant.dart';
import 'package:news_flutter/utils/images.dart';

import '../../main.dart';

class SignUpScreen extends StatefulWidget {
  final String? phoneNumber;
  final LoginResponse? userData;

  SignUpScreen({this.phoneNumber, this.userData});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  bool isSelectedCheck = false;
  var isVisibility = true;
  bool confirmPasswordVisible = false;
  var formKey = GlobalKey<FormState>();
  var autoValidate = false;
  bool isUpdate = false;

  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController usernameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController cnfPwdCont = TextEditingController();

  TextEditingController phoneNumberCont = TextEditingController();

  FocusNode lNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode usernameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode cnfFocus = FocusNode();

  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    isSelectedCheck = false;
    isUpdate = widget.phoneNumber != null;
    if (widget.phoneNumber != null) {
      passwordCont.text = widget.phoneNumber.validate();
      cnfPwdCont.text = widget.phoneNumber.validate();
    }

    if (widget.userData != null) {
      fNameCont.text = widget.userData!.firstName.validate();
      lNameCont.text = widget.userData!.lastName.validate();
      emailCont.text = widget.userData!.userEmail.validate();
      usernameCont.text = widget.userData!.userLogin.validate();
    }
  }

  validate() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      signUpApi();
    } else {
      autoValidate = true;
      isFirstTime = !isFirstTime;
      setState(() {});
    }
  }

  signUpApi() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      var request = {
        'first_name': fNameCont.text,
        'last_name': lNameCont.text,
        'user_login': usernameCont.text,
        'user_email': emailCont.text,
      };
      if (widget.phoneNumber.validate().isNotEmpty) {
        request.putIfAbsent('password', () => passwordCont.text);
        request.putIfAbsent('email', () => emailCont.text);
      } else {
        request.putIfAbsent('user_email', () => emailCont.text);
        request.putIfAbsent('user_pass', () => passwordCont.text);
      }
      appStore.setLoading(true);

      createUser(request, isUpdate: widget.phoneNumber.validate().isNotEmpty).then((res) async {
        appStore.setLoading(false);
        toast(res.message);
        if (isUpdate) {
          Map req = {
            'phone': widget.phoneNumber!.replaceAll('+', ''),
            'loginType': 'mobile',
          };

          appStore.setLoading(true);
          await login(req, isSocialLogin: true).then((value) async {
            appStore.setLoading(false);
            if (!value.isUpdatedProfile.validate()) {
              SignUpScreen(phoneNumber: widget.phoneNumber!.replaceAll('+', ''), userData: value).launch(context);
            } else {
              await setValue(IS_SOCIAL_LOGIN, true);
              await setValue(LOGIN_TYPE, SignInTypeOTP);
              DashboardScreen().launch(context, isNewTask: true);
            }
          }).catchError((e) {
            appStore.setLoading(false);
            toast(e.toString());
          });
        } else {
          Map<String, dynamic> request = {
            "username": "${emailCont.text}",
            "password": "${passwordCont.text}",
          };
          await login(request).then((value) async {
            await setValue(USER_EMAIL_USERNAME, usernameCont.text);
            await setValue(USER_PASSWORD, passwordCont.text);
            appStore.setLoading(false);
            SignInScreen().launch(context);
          }).catchError((e) {
            appStore.setLoading(false);
            toast(e.toString());
          });
        }
      }).catchError((error) {
        finish(context);
        appStore.setLoading(false);
        toast(error.toString());
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColor(appStore.isDarkMode ? card_color_dark : card_color_light);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () {
                      finish(context);
                    },
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      cachedImage(APP_ICON, height: 100, width: 100).cornerRadiusWithClipRRect(defaultRadius),
                      8.height,
                      Text(APP_NAME, style: boldTextStyle(size: 32)),
                    ],
                  ).center(),
                  Column(
                    children: [
                      16.height,
                      Text(language.gettingStarted, style: boldTextStyle(size: textSizeLargeMedium)),
                      8.height,
                      Text(isUpdate ? language.updateToContinue : language.createAnAccountContinue, style: secondaryTextStyle(size: textSizeMedium)),
                      16.height,
                      Form(
                        key: formKey,
                        autovalidateMode: isFirstTime ? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AppTextField(
                              controller: fNameCont,
                              textFieldType: TextFieldType.NAME,
                              decoration: inputDecoration(
                                context,
                                labelText: language.firstName,
                                prefix: true,
                                prefixIcon: cachedImage(ic_profile, height: 16, width: 16, color: Colors.grey.shade500),
                              ),
                              nextFocus: lNameFocus,
                              cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
                            ),
                            16.height,
                            AppTextField(
                              controller: lNameCont,
                              focus: lNameFocus,
                              textFieldType: TextFieldType.NAME,
                              decoration: inputDecoration(
                                context,
                                labelText: language.lastName,
                                prefix: true,
                                prefixIcon: cachedImage(ic_profile, height: 16, width: 16, color: Colors.grey.shade500),
                              ),
                              nextFocus: widget.phoneNumber != null ? emailFocus : usernameFocus,
                              cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
                            ),
                            16.height,
                            AppTextField(
                              controller: usernameCont,
                              focus: usernameFocus,
                              textFieldType: TextFieldType.USERNAME,
                              decoration: inputDecoration(
                                context,
                                labelText: language.userName,
                                prefix: true,
                                prefixIcon: cachedImage(ic_profile, height: 16, width: 16, color: Colors.grey.shade500),
                              ),
                              nextFocus: emailFocus,
                              cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
                            ),
                            16.height,
                            AppTextField(
                              controller: emailCont,
                              focus: emailFocus,
                              textFieldType: TextFieldType.EMAIL,
                              decoration: inputDecoration(
                                context,
                                labelText: language.emailAddress,
                                prefix: true,
                                prefixIcon: cachedImage(ic_email, height: 16, width: 16, color: Colors.grey.shade500),
                              ),
                              nextFocus: passwordFocus,
                              cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
                            ),
                            16.height,
                            AppTextField(
                              textFieldType: TextFieldType.PASSWORD,
                              controller: passwordCont,
                              decoration: inputDecoration(
                                context,
                                labelText: language.password,
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
                            16.height,
                            AppTextField(
                              controller: cnfPwdCont,
                              decoration: inputDecoration(
                                context,
                                labelText: language.password,
                                prefix: true,
                                prefixIcon: cachedImage(ic_password, height: 16, width: 16, color: Colors.grey.shade500),
                              ),
                              cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
                              textInputAction: TextInputAction.done,
                              validator: (s) {
                                if (s.validate().isEmpty) {
                                  return errorThisFieldRequired;
                                } else if (passwordCont.text != cnfPwdCont.text) {
                                  return language.passwordDoesNotMatch;
                                }
                                return null;
                              },
                              textFieldType: TextFieldType.PASSWORD,
                            ),
                          ],
                        ),
                      ),
                      16.height,
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: isSelectedCheck,
                              side: MaterialStateBorderSide.resolveWith((states) => BorderSide(width: 1.0, color: Colors.grey.shade500)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              activeColor: primaryColor,
                              checkColor: Colors.white,
                              onChanged: (val) {
                                setState(() {
                                  isSelectedCheck = val.validate();
                                });
                              },
                            ),
                          ),
                          8.width,
                          RichTextWidget(
                            list: [
                              TextSpan(
                                text: language.termCondition + ' ',
                                style: primaryTextStyle(size: textSizeSmall),
                              ),
                              TextSpan(
                                text: language.terms,
                                style: primaryTextStyle(color: primaryColor, size: textSizeSmall),
                                recognizer: TapGestureRecognizer()..onTap = () => redirectUrl(getStringAsync(TERMS_AND_CONDITIONS)),
                              ),
                            ],
                          ).expand(),
                        ],
                      ),
                      16.height,
                      AppButton(
                        width: context.width(),
                        color: primaryColor,
                        shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        text: widget.phoneNumber.validate().isNotEmpty ? 'Update' : language.signUp,
                        elevation: 0,
                        textStyle: primaryTextStyle(color: white_color, size: textSizeLargeMedium),
                        onTap: () {
                          if (!accessAllowed) {
                            toast(language.sorry);
                            return;
                          }
                          if (isSelectedCheck.validate()) {
                            signUpApi();
                          } else {
                            toast(language.acceptTerms);
                          }
                        },
                      ).paddingOnly(left: 16.0, right: 16.0),
                      16.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(language.haveAnAccount + '? ', style: secondaryTextStyle(size: textSizeMedium)),
                          Container(
                            margin: EdgeInsets.only(left: 4),
                            child: GestureDetector(
                                child: Text(language.signIn, style: TextStyle(decoration: TextDecoration.underline, color: primaryColor, fontSize: textSizeMedium.toDouble())),
                                onTap: () {
                                  finish(context);
                                }),
                          )
                        ],
                      ),
                      16.height,
                    ],
                  ).paddingAll(16.0),
                ],
              ),
            ),
          ),
        ),
        Observer(builder: (_) => Loader(color: primaryColor, valueColor: AlwaysStoppedAnimation(Colors.white)).center().visible(appStore.isLoading)),
      ],
    );
  }
}
