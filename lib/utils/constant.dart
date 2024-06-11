import 'package:news_flutter/model/live_tv_channel_model.dart';

//region Weather API
const weatherUrl = "https://api.weatherapi.com/v1/forecast.json";
const weatherApiKey = "d484ad77c78a46b4999130429222803";
//endregion
const defaultLanguage = 'en';

const perPageItemInCategory = 50; // you have change value when you have get per page item 1 to 100
const perPageCategory = 10; // you have change value when you have get per page category 1 to 100
const accessAllowed = true;
var allowPreFetched = true;
const dateFormat = 'MMM dd, yyyy';
const weatherDisplayFormat = 'EEEE, MMM dd yyyy';
const suffixText = 'μg/m3';

//region shared preference keys
const IS_LOGGED_IN = 'IS_LOGGED_IN';
const TOKEN = 'TOKEN';
const USER_ID = 'USER_ID';
const USERNAME = 'USERNAME';
const FIRST_NAME = 'FIRST_NAME';
const LAST_NAME = 'LAST_NAME';
const USER_DISPLAY_NAME = 'USER_DISPLAY_NAME';
const USER_EMAIL = 'USER_EMAIL';
const USER_MOBILE_NUMBER = 'USER_MOBILE_NUMBER';
const USER_EMAIL_USERNAME = 'USER_EMAIL_USERNAME';
const USER_LOGIN = 'USER_LOGIN';
const USER_PASSWORD = 'USER_PASSWORD';
const PROFILE_IMAGE = 'PROFILE_IMAGE';
const IS_DARK_THEME = "IS_DARK_THEME";
const LANGUAGE = 'LANGUAGE';
const IS_REMEMBERED = 'IS_REMEMBERED';
const allowPreFetchedPref = 'allowPreFetchedPref';
const IS_NOTIFICATION_ON = "IS_NOTIFICATION_ON";
const WHATSAPP = 'WHATSAPP';
const FACEBOOK = 'FACEBOOK';
const TWITTER = 'TWITTER';
const INSTAGRAM = 'INSTAGRAM';
const CONTACT = 'CONTACT';
const PRIVACY_POLICY = 'PRIVACY_POLICY';
const TERMS_AND_CONDITIONS = 'TERMS_AND_CONDITIONS';
const COPYRIGHT_TEXT = 'COPYRIGHT_TEXT';
const SELECTED_LANGUAGE_INDEX = 'SELECT_LANGUAGE';
const IS_SOCIAL_LOGIN = 'IsSocialLogin';
const LOGIN_TYPE = 'LOGIN_TYPE';
const WISHLIST_ITEM_LIST = 'WISHLIST_ITEM_LIST';
const HAS_IN_REVIEW = 'hasInReview';
const HAS_IN_APP_STORE_REVIEW = 'hasInAppStoreReview';
const HAS_IN_PLAY_STORE_REVIEW = 'hasInPlayStoreReview';
const PLAYER_ID = "PLAYER_ID";
const phoneKey = 'phone';
//endregion

// Offline Data
const dashboardData = 'dashboardData';
const newsDetailData = 'newsDetailData';
const videoListData = 'videoListData';
const bookmarkData = 'bookmarkData';
const categoryData = 'categoryData';
const cachedCategoryList = 'cachedCategoryList';
const cachedCategoryWiseNewsList = 'cachedCategoryWiseNewsList';
const cachedFeatureNewsList = 'cachedFeatureNewsList';
const cachedLatestNewsList = 'cachedLatestNewsList';

// Video Type
const VideoTypeYouTube = 'youtube';
const VideoTypeIFrame = 'iframe';
const VideoCustomUrl = 'custom_url';

/* Login Type */
const SignInTypeGoogle = 'google';
const SignInTypeApple = 'apple';
const SignInTypeOTP = 'otp';

//
var isAdsDisabled = false;
const isLanguageEnable = true;

/* DetailsPageVariant */
const DETAIL_PAGE_VARIANT = 'DetailPageVariant';
/* Text to Speech */
const TEXT_TO_SPEECH_LANG = 'TEXT_TO_SPEECH_LANG';
const TTS_SELECTED_LANGUAGE_INDEX = 'TTS_SELECT_LANGUAGE';

/*default ttsLanguage*/
const defaultTTSLanguage = 'en-US';

//region font sizes
const textSizeSmall = 12;
const textSizeSMedium = 14;
const textSizeMedium = 16;
const textSizeLargeMedium = 18;
const textSizeNormal = 20;
const textSizeLarge = 24;
const textSizeXLarge = 26;
//endregionss

const editTextRadius = 28.0;
const ARTICLE_LINE_HEIGHT = 1.5;
//endregion

//region Messages
const Password = 'Password';
const Email_Address = 'Email Address';

const Field_Required = "Field Required";
const noRecord = 'No Record Found';
const errorMsg = 'Please try again later.';
const permission = 'Permission denied.';
const noInternetMsg = 'You are not connected to Internet';
const companyTagLine = "Made with ❤ by Stacknyu";
const admin_author = ["Admin", "ADMIN", "admin"];

enum NewsListType { FEATURE_NEWS, LATEST_NEWS }

enum PostType { HTML, String, WordPress }

//endregion

/// Live TV URL channel list
/// NOTE : Currently support only Youtube live channels
/// Add channel name and channel url (Add channel URL No iframe no Embedded code)
List<LiveTvChannelModel> liveTvChannels = [
  LiveTvChannelModel(channelName: "NDTV", channelURL: "https://youtu.be/WB-y7_ymPJ4"),
  LiveTvChannelModel(channelName: "NEWS 18", channelURL: "https://www.youtube.com/watch?v=PoOC7jiXOAs"),
  LiveTvChannelModel(channelName: "WION", channelURL: "https://www.youtube.com/watch?v=lbb38uOR0Cs"),
  LiveTvChannelModel(channelName: "DW News", channelURL: "https://youtu.be/GE_SfNVNyqk"),
  LiveTvChannelModel(channelName: "LiveNOW from FOX", channelURL: "https://youtu.be/Z7tZuO46GVQ"),
];

const PER_PAGE = 10;

const demoUserName = 'felix';
const demoPassword = '123456';
const demoUserEmail = 'felix@gmail.com';

const CACHED_NEWS_POST = 'CACHED_NEWS_POST';
const CHANGE_COMMENT = 'CHANGE_COMMENT';
const LOCATION_PERMISSION = 'LOCATION_PERMISSION';

const LIVE = 'LIVE';
