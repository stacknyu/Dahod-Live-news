import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/main.dart';
import 'package:news_flutter/network/auth_service.dart';
import 'package:news_flutter/network/rest_apis.dart';
import 'package:news_flutter/screens/auth/sign_up_screen.dart';
import 'package:news_flutter/screens/dashboard/dashboard_screen.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:news_flutter/utils/constant.dart';
import 'package:news_flutter/utils/extensions/string_extensions.dart';
import 'package:news_flutter/utils/images.dart';

class OTPDialogBox extends StatefulWidget {
  static String tag = '/OTPDialog';
  final String? verificationId;
  final String? phoneNumber;

  bool? isCodeSent;
  final PhoneAuthCredential? credential;

  Function()? callBackToUpdateProfile;

  OTPDialogBox({this.verificationId, this.isCodeSent, this.phoneNumber, this.credential, this.callBackToUpdateProfile});

  @override
  OTPDialogBoxState createState() => OTPDialogBoxState();
}

class OTPDialogBoxState extends State<OTPDialogBox> {
  TextEditingController numberController = TextEditingController();

  String otpCode = '';

  Country selectedCountry = defaultCountry();

  @override
  void initState() {
    super.initState();
    init();
    numberController.text = '1234567890';
  }

  Future<void> init() async {
    //
  }

  //region Methods
  Future<void> changeCountry() async {
    showCountryPicker(
      context: context,
      showPhoneCode: true, // o
      // ptional. Shows phone code before the country name.
      onSelect: (Country country) {
        selectedCountry = country;
        log(jsonEncode(selectedCountry.toJson()));
        setState(() {});
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> submit() async {
    AuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verificationId!, smsCode: otpCode.validate());

    await FirebaseAuth.instance.signInWithCredential(credential).then((result) async {
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
      });
    }).catchError((e) {
      toast(e.toString());
      appStore.setLoading(false);
    });
  }

  Future<void> sendOTP() async {
    hideKeyboard(context);

    if (numberController.text.trim().isEmpty) {
      toast(errorThisFieldRequired);
      return;
    }
    appStore.setLoading(true);
    setState(() {});

    String number = '+${selectedCountry.phoneCode}${numberController.text.trim()}';
    if (!number.startsWith('+')) {
      number = '+${selectedCountry.phoneCode}${numberController.text.trim()}';
    }

    await signInWithOTP(context, number).then((value) {
      appStore.setLoading(false);
    }).catchError((e) {
      finish(context);
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height() * 0.24,
      child: Stack(
        children: [
          Container(
            width: context.width(),
            child: AnimatedScrollView(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              listAnimationType: ListAnimationType.None,
              children: !widget.isCodeSent.validate()
                  ? [
                      Text(language.enterPhoneNumber, style: boldTextStyle()),
                      24.height,
                      AppTextField(
                        controller: numberController,
                        textFieldType: TextFieldType.PHONE,
                        decoration: inputDecoration(context, hint: language.phoneNumber).copyWith(
                          prefixText: '+${selectedCountry.phoneCode} ',
                          hintText: '${selectedCountry.example}',
                        ),
                        autoFocus: true,
                        cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
                        onFieldSubmitted: (s) {
                          sendOTP();
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            changeCountry();
                          },
                          child: Text(language.changeCountry, style: secondaryTextStyle(size: 16)),
                        ),
                      ),
                      AppButton(
                        onTap: () {
                          sendOTP();
                        },
                        text: language.sendotp,
                        width: context.width(),
                        color: primaryColor,
                        shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        textStyle: primaryTextStyle(color: white_color, size: textSizeLargeMedium),
                      ),
                    ]
                  : [
                      Text(
                        '${language.otpSentToPhoneNumber} **${widget.phoneNumber.validate().substring(widget.phoneNumber.validate().length - 4)}',
                        style: primaryTextStyle(),
                      ),
                      16.height,
                      OTPTextField(
                        pinLength: 6,
                        fieldWidth: 45,
                        cursorColor: primaryColor,
                        onChanged: (s) {
                          otpCode = s;
                        },
                        onCompleted: (pin) {
                          otpCode = pin;
                          submit();
                        },
                      ).fit(),
                      32.height,
                      AppButton(
                        onTap: () {
                          submit();
                        },
                        child: Text(language.confirm, style: boldTextStyle(color: white)),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: primaryColor,
                        width: context.width(),
                      ),
                    ],
            ),
          ),
          if (!widget.isCodeSent.validate())
            Align(
              child: ic_clear.iconImageColored(color: primaryColor).onTap(() {
                if (!appStore.isLoading) finish(context);
              }),
              alignment: Alignment.topRight,
            ),
          Observer(builder: (context) {
            return Loader(color: primaryColor, valueColor: AlwaysStoppedAnimation(Colors.white)).visible(appStore.isLoading).center();
          })
        ],
      ),
    );
  }
}
