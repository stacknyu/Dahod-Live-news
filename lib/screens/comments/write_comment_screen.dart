import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/app_widgets.dart';
import 'package:news_flutter/main.dart';
import 'package:news_flutter/network/rest_apis.dart';
import 'package:news_flutter/screens/auth/sign_in_screen.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/constant.dart';
import 'package:news_flutter/utils/images.dart';

class WriteCommentScreen extends StatefulWidget {
  final int? id;
  final bool hideTitle;
  final String? editCommentText;
  final bool isUpdate;
  final int? commentId;

  final String? password;

  WriteCommentScreen({this.id, this.hideTitle = false, this.password, this.editCommentText, this.isUpdate = false, this.commentId});

  @override
  _WriteCommentScreenState createState() => _WriteCommentScreenState();
}

class _WriteCommentScreenState extends State<WriteCommentScreen> {
  TextEditingController commentCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (widget.editCommentText.validate().isNotEmpty) {
      commentCont.text = widget.editCommentText.toString();
    }
  }

  Future<void> postCommentApi() async {
    hideKeyboard(context);

    appStore.setLoading(true);

    Map<String, dynamic> request = {
      "content": commentCont.text.trim().validate(),
    };
    if (!widget.isUpdate) {
      request.putIfAbsent('post', () => widget.id);
    }
    if (widget.isUpdate) {
      request.putIfAbsent("id", () => widget.commentId);
    }
    if (widget.password.validate().isNotEmpty) request.putIfAbsent('password', () => widget.password);
    if (widget.isUpdate) {
      await updateCommentList(request).then((res) {
        finish(context);
        appStore.setLoading(false);

        toast(language.commentUpdated);
        LiveStream().emit(CHANGE_COMMENT);
        commentCont.clear();
        setState(() {});
      }).catchError((error) {
        finish(context);
        toast('${error.toString()}');
        appStore.setLoading(false);
      });
    } else {
      await postComment(request).then((res) {
        appStore.setLoading(false);
        toast(language.commentAdded);
        LiveStream().emit(CHANGE_COMMENT);
        commentCont.clear();
        setState(() {});
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString(), print: true);
      });
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
    return SizedBox(
      height: context.width() - 128,
      width: context.width(),
      child: Stack(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.hideTitle) Text(language.updateComment, style: boldTextStyle()).paddingOnly(left: 6, top: 16),
                AppTextField(
                  textFieldType: TextFieldType.MULTILINE,
                  controller: commentCont,
                  scrollPadding: EdgeInsets.all(16.0),
                  keyboardType: TextInputType.multiline,
                  cursorColor: Colors.grey.shade500,
                  minLines: widget.hideTitle ? 4 : 1,
                  decoration: InputDecoration(
                    labelText: widget.hideTitle ? "" : language.comment,
                    labelStyle: secondaryTextStyle(),
                    enabledBorder: OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: radius(editTextRadius - 8),
                      borderSide: BorderSide(color: viewLineColor, width: 1.0),
                    ),
                    fillColor: context.cardColor,
                    filled: true,
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: radius(editTextRadius - 8),
                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: radius(editTextRadius - 8),
                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                    ),
                    errorMaxLines: 2,
                    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: radius(editTextRadius - 8),
                      borderSide: BorderSide(color: primaryColor, width: 1.0),
                    ),

                    /// add observer
                    suffixIcon: widget.hideTitle
                        ? Offstage()
                        : IconButton(
                            padding: EdgeInsets.all(0),
                            icon: cachedImage(ic_send, color: primaryColor, height: 24, width: 24),
                            onPressed: () {
                              if (!accessAllowed) {
                                toast(language.sorry);
                                return;
                              }
                              if (commentCont.text.isEmpty) {
                                toast(language.commentFieldRequired);
                              } else {
                                if (appStore.isLoggedIn) {
                                  postCommentApi();
                                } else {
                                  SignInScreen().launch(context);
                                }
                              }
                            },
                          ),
                  ),
                ).paddingSymmetric(vertical: 16),
                if (widget.hideTitle)
                  Observer(
                    builder: (_) => Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppButton(
                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            onTap: () {
                              finish(context);
                            },
                            elevation: 0,
                            child: Text(language.cancel, style: boldTextStyle(color: appStore.isDarkMode ? white : black)),
                            shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                            color: context.cardColor,
                          ),
                          16.width,
                          AppButton(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                              elevation: 0,
                              onTap: () {
                                if (!accessAllowed) {
                                  toast(language.sorry);
                                  return;
                                }
                                if (commentCont.text.isEmpty) {
                                  toast(language.commentFieldRequired);
                                } else {
                                  if (appStore.isLoggedIn) {
                                    postCommentApi();
                                  } else {
                                    SignInScreen().launch(context);
                                  }
                                }
                              },
                              child: Text(language.send, style: boldTextStyle(color: white)),
                              color: primaryColor)
                        ],
                      ).paddingOnly(bottom: 8, right: 16),
                    ),
                  ),
              ],
            ),
          ),
          Align(
            alignment: widget.hideTitle ? Alignment.bottomCenter : Alignment.center,
            child: Observer(
              builder: (context) {
                return Loader(color: primaryColor, valueColor: AlwaysStoppedAnimation(Colors.white)).visible(appStore.isLoading && widget.hideTitle).center();
              },
            ),
          )
        ],
      ),
    );
  }
}
