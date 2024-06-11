import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/network/rest_apis.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:news_flutter/app_widgets.dart';
import 'package:news_flutter/utils/constant.dart';
import 'package:news_flutter/main.dart';

// ignore: must_be_immutable
class ForgetEmailDialog extends StatelessWidget {
  var email = TextEditingController();
  var formKey = GlobalKey<FormState>();
  void forgotPwdApi(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      var request = {
        'email': email.text,
      };

      appStore.setLoading(true);

      forgotPassword(request).then((res) {
        appStore.setLoading(false);
        toast(res['message']);
        finish(context);
      }).catchError((error) {
        appStore.setLoading(false);
        toast(error.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: boxDecoration(context, color: white_color, radius: 10.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // To make the card compact
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        16.height,
                        Text(language.forgotPassword, style: boldTextStyle(size: textSizeLargeMedium)),
                        24.height,
                        AppTextField(
                          controller: email,
                          textFieldType: TextFieldType.EMAIL,
                          decoration: inputDecoration(context, hint: language.emailAddress),
                          autoFocus: true,
                          validator: (s) {
                            if (s.validate().isEmpty) {
                              return errorThisFieldRequired;
                            }
                            return null;
                          },
                          cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ],
                    ).paddingOnly(left: 16.0, right: 16.0, bottom: 16.0),
                    Container(
                      margin: EdgeInsets.all(16),
                      width: MediaQuery.of(context).size.width,
                      child: AppButton(
                        child: Text(language.send, style: primaryTextStyle(color: white_color, size: textSizeLargeMedium)),
                        color: primaryColor,
                        elevation: 0,
                        shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        onTap: () {
                          if (!accessAllowed) {
                            toast(language.sorry);
                            return;
                          } else
                            forgotPwdApi(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Observer(
            builder: (context) => Observer(builder: (context) {
              return Loader(color: primaryColor, valueColor: AlwaysStoppedAnimation(Colors.white)).visible(appStore.isLoading).center();
            }),
          )
        ],
      ),
    );
  }
}
