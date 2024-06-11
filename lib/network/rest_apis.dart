import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/configs.dart';
import 'package:news_flutter/model/base_response.dart' as b;
import 'package:news_flutter/model/blog_model.dart';
import 'package:news_flutter/model/post_list_model.dart';
import 'package:news_flutter/model/category_model.dart';
import 'package:news_flutter/model/dashboard_model.dart';
import 'package:news_flutter/model/login_response.dart';
import 'package:news_flutter/model/notification_model.dart';
import 'package:news_flutter/model/post_model.dart';
import 'package:news_flutter/model/view_comment_model.dart';
import 'package:news_flutter/model/weather_model.dart';
import 'package:news_flutter/utils/constant.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../main.dart';
import 'network_utils.dart';

Future<bool> handlePermission() async {
  bool serviceEnabled;
  LocationPermission permission;
  final GeolocatorPlatform geoLocator = GeolocatorPlatform.instance;
  serviceEnabled = await geoLocator.isLocationServiceEnabled();
  permission = await geoLocator.checkPermission();

  if (!serviceEnabled) {
    appStore.setLocationPermission(false);
    return false;
  } else {
    if (permission == LocationPermission.denied) {
      permission = await geoLocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
      appStore.setLocationPermission(false);
      return false;
    } else {
      appStore.setLocationPermission(true);
      return true;
    }
  }
}

Future<WeatherModel> weatherApi() async {
  final hasPermission = await handlePermission();

  if (!hasPermission) {
    throw permission;
  }
  final GeolocatorPlatform geoLocator = GeolocatorPlatform.instance;
  final Position position = await geoLocator.getCurrentPosition();
  http.Response response = await http.get(Uri.parse('$weatherUrl?key=$weatherApiKey&days=7&q=${position.latitude},${position.longitude}&aqi=yes'));
  if (response.statusCode.isSuccessful()) {
    cachedWeatherData = WeatherModel.fromJson(jsonDecode(response.body));
    return WeatherModel.fromJson(jsonDecode(response.body));
  } else {
    toast('error');
    throw errorMsg;
  }
}

Future<LoginResponse> login(Map request, {bool isSocialLogin = false}) async {
  Response response = await postRequest(isSocialLogin ? 'iqonic-api/api/v1/customer/social_login' : 'jwt-auth/v1/token', request);

  if (!response.statusCode.isSuccessful()) {
    if (response.body.isJson()) {
      if (jsonDecode(response.body).containsKey('code')) {
        if (jsonDecode(response.body)['code'].toString().contains('invalid_username')) {
          b.BaseResponse res = b.BaseResponse.fromJson(await handleResponse(response));
          toast(res.message);
          throw 'invalid_username';
        }
      }
    }
  }

  return await handleResponse(response).then((res) async {
    if (res.containsKey('code')) {
      if (res['code'].toString().contains('invalid_username')) {
        throw 'invalid username';
      }
    }
    LoginResponse loginResponse = LoginResponse.fromJson(res);
    if (isSocialLogin) {
      loginResponse = LoginResponse.fromJson(res['data']);
    }

    await setValue(USER_ID, loginResponse.userId);
    await setValue(FIRST_NAME, loginResponse.firstName);
    await setValue(LAST_NAME, loginResponse.lastName);
    await setValue(USER_EMAIL, loginResponse.userEmail);
    await setValue(USERNAME, loginResponse.userNiceName);
    await setValue(TOKEN, loginResponse.token);
    await setValue(USER_DISPLAY_NAME, loginResponse.userDisplayName);
    await setValue(USER_LOGIN, loginResponse.userLogin);
    await setValue(IS_SOCIAL_LOGIN, isSocialLogin.validate());
    await setValue(IS_LOGGED_IN, true);
    await setValue(USER_EMAIL_USERNAME, loginResponse.userEmail);

    if (loginResponse.profileImage.validate().isNotEmpty) {
      await setValue(PROFILE_IMAGE, loginResponse.profileImage.validate());
    } else {
      await setValue(PROFILE_IMAGE, appStore.userProfileImage.validate());
    }

    appStore.setUserId(loginResponse.userId);
    appStore.setUserEmail(loginResponse.userEmail);
    appStore.setFirstName(loginResponse.firstName);
    appStore.setLastName(loginResponse.lastName);
    appStore.setUserLogin(loginResponse.userLogin);
    appStore.setUserName(loginResponse.userNiceName.validate());
    if (loginResponse.profileImage.validate().isNotEmpty) {
      appStore.setUserProfile(loginResponse.profileImage.validate());
    }
    OneSignal.login(appStore.userId.toString().validate());

    appStore.setLoggedIn(true);

    if (bookmarkStore.mBookmark.isNotEmpty) bookmarkStore.mBookmark.clear();

    if (isSocialLogin) {
      FirebaseAuth.instance.signOut();
      await setValue(IS_REMEMBERED, true);
    } else {}

    return loginResponse;
  });
}

Future<b.BaseResponse> createUser(Map request, {bool isUpdate = false}) async {
  String endPoint = 'registration';
  if (isUpdate) endPoint = 'update-profile';
  return b.BaseResponse.fromJson(await handleResponse(await postRequest('iqonic-api/api/v1/user/$endPoint', request, requireToken: isUpdate ? true : false)));
}

Future updateUser(Map request) async {
  return handleResponse(await postRequest('iqonic-api/api/v1/user/registration', request, requireToken: false));
}

Future<DashboardModel> getDashboardApi(int page, {Function(bool)? lastPageCallback}) async {
  var res = DashboardModel.fromJson(
    await handleResponse(
      await getRequest('iqonic-api/api/v1/blog/get-dashboard?page=$page&posts_per_page=8', requireToken: false),
    ),
  );
  await setValue(dashboardData, res.toJson());

  if (res.socialLink != null) {
    await setValue(WHATSAPP, res.socialLink!.whatsapp.toString());
    await setValue(FACEBOOK, res.socialLink!.facebook.toString());
    await setValue(TWITTER, res.socialLink!.twitter.toString());
    await setValue(INSTAGRAM, res.socialLink!.instagram.toString());
    await setValue(CONTACT, res.socialLink!.contact.toString());

    if (res.socialLink!.termCondition.validate().isNotEmpty) {
      await setValue(TERMS_AND_CONDITIONS, res.socialLink!.termCondition.toString());
    } else {
      await setValue(TERMS_AND_CONDITIONS, TERMS_CONDITION);
    }
    if (res.socialLink!.privacyPolicy.validate().isNotEmpty) {
      await setValue(PRIVACY_POLICY, res.socialLink!.privacyPolicy.toString());
    } else {
      await setValue(PRIVACY_POLICY, POLICY);
    }
    await setValue(COPYRIGHT_TEXT, res.socialLink!.copyrightText.toString());
  }

  lastPageCallback?.call(res.featurePost.validate().length != PER_PAGE);

  /// if you want language set under the app so comment this two line other wise uncomment..
  if (!isLanguageEnable) {
    setValue(LANGUAGE, res.appLang.toString());
    appStore.setLanguage(res.appLang.toString());
  }

  String featureNewsMarquee = "";

  if (res.featurePost.validate().isNotEmpty) {
    appStore.setFeatureListEmpty(false);
  } else {
    appStore.setFeatureListEmpty(true);
  }

  res.featurePost.validate().take(5).forEach((e) {
    featureNewsMarquee = featureNewsMarquee + e.postTitle.validate() + " | ";
  });

  res.featureNewsMarquee = featureNewsMarquee;
  return res;
}

Future<PostModel> getBlogDetail(Map request) async {
  PostModel newsData = PostModel.fromJson(await handleResponse(await postRequest('iqonic-api/api/v1/blog/get-post-details', request, requireToken: appStore.isLoggedIn ? true : false)));
  appStore.setCachedNewsAndArticles(newsData);
  return newsData;
}

Future<BlogModel> getPostDetails({required String postId, String password = ''}) async {
  return BlogModel.fromJson(await handleResponse(await getRequest('wp/v2/posts/$postId?_embed${password.validate().isNotEmpty ? '&password=$password' : ''}')));
}

Future saveProfileImage(Map request) async {
  return handleResponse(await postRequest('iqonic-api/api/v1/user/save-profile-image', request, requireToken: true));
}

Future<List<CategoryModel>> getCategories({int? page, int perPage = perPageCategory, int? parent}) async {
  Iterable it = await handleResponse(await getRequest('wp/v2/get-category?parent=${parent ?? 0}&page=${page ?? 1}&per_page=$perPage', requireToken: false));

  return it.map((e) => CategoryModel.fromJson(e)).toList();
}

Future<PostListModel> getBlogList(Map request, int page) async {
  PostListModel postListData = PostListModel.fromJson(await handleResponse(await postRequest('iqonic-api/api/v1/blog/get-blog-by-filter/?posts_per_page=10&page=$page', request, requireToken: true)));
  return postListData;
}

Future<PostListModel> getSearchBlogList(Map request, int page) async {
  return PostListModel.fromJson(await handleResponse(await postRequest('iqonic-api/api/v1/blog/get-blog-by-filter?page=$page', request)));
}

Future<List<PostModel>> searchBlogList({
  String? searchString,
  required int page,
  Function(bool)? lastPageCallback,
  required List<PostModel> postsList,
}) async {
  Map request = {"text": searchString};

  PostListModel postListModel = PostListModel.fromJson(await handleResponse(await postRequest('iqonic-api/api/v1/blog/get-blog-by-filter?page=$page', request)));
  if (page == 1) postsList.clear();

  lastPageCallback?.call(postListModel.posts.validate().length != PER_PAGE);

  postsList.addAll(postListModel.posts.validate());

  return postsList;
}

Future<b.BaseResponse> addWishList(Map request) async {
  return b.BaseResponse.fromJson(await handleResponse(await postRequest('iqonic-api/api/v1/blog/add-fav-list', request, requireToken: true)));
}

Future<PostListModel> getWishList(int page) async {
  return PostListModel.fromJson(await handleResponse(await postRequest('iqonic-api/api/v1/blog/get-fav-list?page=$page&posts_per_page=5', {}, requireToken: true)));
}

Future<void> removeWishList(Map request) async {
  return handleResponse(await postRequest('iqonic-api/api/v1/blog/delete-fav-list', request, requireToken: true));
}

Future<List<ViewCommentModel>> getCommentList(int id, {int? page, String? password}) async {
  if (id == 0) return [];

  List<String> params = [];
  if (page != null) {
    params.add('page=$page');
    params.add('per_page=$PER_PAGE');
  }
  if (password.validate().isNotEmpty) params.add('password=$password');

  Iterable it = await handleResponse(await getRequest('wp/v2/comments?post=$id&${params.validate().join('&')}', requireToken: false));

  return it.map((e) => ViewCommentModel.fromJson(e)).toList();
}

Future<void> updateCommentList(
  Map request,
) async {
  await handleResponse(await putRequest('iqonic-api/api/v1/blog/comment', request, requireToken: true, isBearer: true));
}

Future<void> deleteCommentList(Map request) async {
  await handleResponse(await deleteRequest('iqonic-api/api/v1/blog/comment', request: request, requireToken: true, isBearer: true));
}

Future<void> postComment(Map request) async {
  return handleResponse(await postRequest('wp/v2/comments', request, requireToken: true, isBearer: true));
}

Future<dynamic> forgotPassword(Map request) async {
  return handleResponse(await postRequest('iqonic-api/api/v1/user/forget-password', request));
}

Future getVideoList(Map request, int page) async {
  return handleResponse(await postRequest('iqonic-api/api/v1/blog/get-video-list?paged=$page&per_page=10', request, requireToken: false));
}

Future<void> changePassword(Map request) async {
  return handleResponse(await postRequest('iqonic-api/api/v1/user/change-password', request, requireToken: true));
}

Future<NotificationModel> getNotificationList() async {
  return NotificationModel.fromJson(await handleResponse(await getRequest('iqonic-api/api/v1/blog/get-notification-list', requireToken: false)));
}

Future<void> logout(BuildContext context) async {
  await removeKey(TOKEN);
  await removeKey(USER_ID);
  await removeKey(FIRST_NAME);
  await removeKey(LAST_NAME);
  await removeKey(USERNAME);
  await removeKey(USER_DISPLAY_NAME);
  await removeKey(PROFILE_IMAGE);
  await removeKey(USER_EMAIL);
  await removeKey(IS_LOGGED_IN);
  await removeKey(IS_SOCIAL_LOGIN);
  await removeKey(USER_LOGIN);
  await removeKey(USER_PASSWORD);
  await removeKey(PLAYER_ID);

  await removeKey(dashboardData);
  await removeKey(categoryData);
  await removeKey(videoListData);
  await removeKey(bookmarkData);

  if (getBoolAsync(IS_SOCIAL_LOGIN) || !getBoolAsync(IS_REMEMBERED)) {
    await removeKey(USER_PASSWORD);
    await removeKey(USER_EMAIL_USERNAME);
  }
  bookmarkStore.clearBookmark();
  //
  appStore.setLoggedIn(false);
  appStore.setUserId(0);
  appStore.setUserEmail('');
  appStore.setFirstName('');
  appStore.setLastName('');
  appStore.setUserLogin('');
  appStore.setUserName('');
  appStore.setUserProfile('');
  //
}
