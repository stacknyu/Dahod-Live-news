import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/network/rest_apis.dart';
import 'package:news_flutter/screens/dashboard/dashboard_screen.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:news_flutter/utils/images.dart';
import 'package:news_flutter/app_widgets.dart';
import 'package:news_flutter/utils/constant.dart';
import 'package:news_flutter/components/back_widget.dart';
import 'package:news_flutter/components/loading_dot_widget.dart';

import '../../main.dart';

class ProfileFragment extends StatefulWidget {
  final bool? isTab;

  ProfileFragment({this.isTab});

  @override
  ProfileFragmentState createState() => ProfileFragmentState();
}

class ProfileFragmentState extends State<ProfileFragment> {
  var imageFile = '';
  File? mSelectedImage;
  String avatar = '';
  List? userDetail;

  var fNameCont = TextEditingController();
  var lNameCont = TextEditingController();
  var emailCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    fNameCont.text = appStore.userFirstName!;
    lNameCont.text = appStore.userLastName!;
    emailCont.text = appStore.userEmail!;

    setState(() {});
  }

  saveUser() async {
    setState(() {});
    hideKeyboard(context);

    var request = {
      'user_email': emailCont.text,
      'first_name': fNameCont.text,
      'last_name': lNameCont.text,
      'ID': appStore.userId,
      'user_login': appStore.userLogin,
    };
    appStore.setLoading(true);
    updateUser(request).then((res) async {
      if (!mounted) return;
      appStore.setLoading(false);
      setState(() {});

      await setValue(FIRST_NAME, res['data']['first_name']);
      await setValue(LAST_NAME, res['data']['last_name']);
      await setValue(USER_EMAIL, res['data']['user_email']);

      appStore.setFirstName(res['data']['first_name']);
      appStore.setLastName(res['data']['last_name']);
      appStore.setUserEmail(res['data']['user_email']);

      toast(res['message']);
      DashboardScreen().launch(context, isNewTask: true);
    }).catchError((error) {
      toast(error.toString());
      appStore.setLoading(false);
      setState(() {});
    });
    appStore.setLoading(false);
  }

  void pickImage() async {
    File image = File((await ImagePicker().pickImage(source: ImageSource.gallery))!.path);

    setState(() {
      mSelectedImage = image;
    });

    if (mSelectedImage != null) {
      showConfirmDialogCustom(
        context,
        primaryColor: primaryColor,
        title: language.conformationUploadImage,
        onAccept: (context) async {
          var base64Image = base64Encode(mSelectedImage!.readAsBytesSync());
          var request = {'base64_img': base64Image};

          await saveProfileImage(request).then((res) async {
            if (res['profile_image'] != null && res['profile_image'].toString().isNotEmpty) {
              await setValue(PROFILE_IMAGE, res['profile_image']);
              appStore.setUserProfile(res['profile_image']);
            } else {
              toast(language.lblCanNotSaveThisImage);
            }

            toast(res['message']);
          }).catchError((error) {
            toast(error.toString());
          });

          setState(() {});
        },
        dialogType: DialogType.CONFIRMATION,
        negativeText: language.no,
        positiveText: language.yes,
      );
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget profileImage = ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: mSelectedImage == null
          ? appStore.userProfileImage!.isNotEmpty
              ? cachedImage(appStore.userProfileImage.validate(), height: 100, width: 100, fit: BoxFit.cover)
              : cachedImage(user_profile, width: 100, height: 100, fit: BoxFit.cover)
          : cachedImage(mSelectedImage!.path, width: 120, height: 120, fit: BoxFit.cover),
    );

    return Stack(
      children: [
        appStore.isLoggedIn
            ? Scaffold(
                appBar: widget.isTab == false
                    ? PreferredSize(
                        preferredSize: Size.fromHeight(kToolbarHeight),
                        child: appBarWidget(
                          language.profile,
                          center: true,
                        ),
                      )
                    : PreferredSize(preferredSize: Size.fromHeight(0.0), child: SizedBox()),
                body: SingleChildScrollView(
                  child: Observer(
                    builder: (_) => Column(
                      children: [
                        24.height,
                        Align(alignment: Alignment.centerLeft, child: BackWidget(color: context.iconColor)),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              height: 120,
                              width: 120,
                              decoration: boxDecoration(context, radius: 60, color: primaryColor, borderWidth: 4.0, bgColor: Colors.transparent),
                              child: profileImage.paddingAll(4.0),
                            ),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: primaryColor, width: 2), color: white_color),
                              child: IconButton(
                                  icon: Icon(Icons.camera_alt, size: 20, color: primaryColor),
                                  onPressed: (() {
                                    pickImage();
                                  })),
                            ).visible(appStore.isLoggedIn && !getBoolAsync(IS_SOCIAL_LOGIN)).onTap(() {
                              pickImage();
                            })
                          ],
                        ),
                        24.height,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextField(
                              textFieldType: TextFieldType.NAME,
                              controller: fNameCont,
                              cursorColor: primaryColor,
                              decoration: inputDecoration(
                                context,
                                hint: language.firstName,
                                prefixIcon: Icon(Icons.account_circle_outlined),
                                prefix: true,
                              ),
                            ),
                            16.height,
                            AppTextField(
                              textFieldType: TextFieldType.NAME,
                              controller: lNameCont,
                              cursorColor: primaryColor,
                              decoration: inputDecoration(context, hint: language.lastName, prefixIcon: Icon(Icons.account_circle_outlined), prefix: true),
                            ),
                            16.height,
                            AppTextField(
                              textFieldType: TextFieldType.NAME,
                              controller: emailCont,
                              cursorColor: primaryColor,
                              readOnly: true,
                              decoration: inputDecoration(context, hint: language.email, prefixIcon: Icon(Icons.email_outlined), prefix: true),
                            ),
                            16.height,
                            AppButton(
                              text: language.save,
                              textStyle: boldTextStyle(color: white_color),
                              width: context.width(),
                              color: primaryColor,
                              shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              onTap: () {
                                if (!accessAllowed) {
                                  toast(language.sorry);
                                  return;
                                }
                                if (fNameCont.text.isEmpty)
                                  toast(language.firstName + language.fieldRequired);
                                else if (lNameCont.text.isEmpty)
                                  toast(language.lastName + language.fieldRequired);
                                else if (emailCont.text.isEmpty)
                                  toast(language.emailAddress + language.fieldRequired);
                                else {
                                  ifNotTester(context, saveUser);
                                  // print(appStore.userName);
                                  // saveUser();
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ).paddingAll(16.0),
                  ),
                ))
            : Container(
                width: context.width(),
                height: context.height(),
                color: Theme.of(context).cardTheme.color,
              ),
        Observer(builder: (_) => LoadingDotsWidget().center().visible(appStore.isLoading)),
      ],
    );
  }
}
