import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/main.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/common.dart';

class PasswordProtectedPost extends StatefulWidget {
  final double? height;
  final double? width;
  final Function(String? pwd) getPostDetails;
  PasswordProtectedPost(this.getPostDetails, {this.height, this.width});

  @override
  _PasswordProtectedPostState createState() => _PasswordProtectedPostState();
}

class _PasswordProtectedPostState extends State<PasswordProtectedPost> {
  TextEditingController passwordCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? context.width(),
      height: widget.height ?? context.height(),
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      decoration: boxDecorationDefault(
        borderRadius: BorderRadius.zero,
        color: context.cardColor.withOpacity(0.1),
      ),
      child: Container(
        height: context.height() * 0.2,
        padding: EdgeInsets.all(16),
        decoration: boxDecorationDefault(
          color: appStore.isDarkMode ? Colors.white24 : Colors.black26,
          boxShadow: [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(language.passwordProtectedNews, style: primaryTextStyle(color: Colors.white)),
            16.height,
            AppTextField(
              controller: passwordCont,
              cursorColor: primaryColor,
              textFieldType: TextFieldType.PASSWORD,
              decoration: inputDecoration(context),
              onFieldSubmitted: (v) {
                widget.getPostDetails.call(passwordCont.text);
              },
            )
          ],
        ),
      ),
    );
  }
}
