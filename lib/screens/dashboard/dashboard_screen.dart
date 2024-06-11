import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/components/internet_connectivity_widget.dart';
import 'package:news_flutter/screens/auth/sign_in_screen.dart';
import 'package:news_flutter/screens/category/category_list_screen.dart';
import 'package:news_flutter/screens/dashboard/components/profile_widget.dart';
import 'package:news_flutter/screens/dashboard/fragments/bookmark_fragment.dart';
import 'package:news_flutter/screens/dashboard/fragments/home_fragment.dart';
import 'package:news_flutter/screens/dashboard/fragments/live_tv_fragment.dart';
import 'package:news_flutter/screens/dashboard/fragments/youtube_fragment.dart';
import 'package:news_flutter/screens/shimmerScreen/shimmer_component/profile_shimmer_component.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/constant.dart';
import 'package:news_flutter/utils/images.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../main.dart';

class DashboardScreen extends StatefulWidget {
  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  int selectedIndex = 0;

  List<Widget> pages = [
    HomeFragment(),
    BookmarkFragment(isTab: true),
    CategoryListScreen(isTab: true),
    if (!getBoolAsync(HAS_IN_REVIEW)) YoutubeScreenFragment(),
    // if (!getBoolAsync(HAS_IN_REVIEW)) LiveTvFragment(),
    SizedBox(),
  ];

  @override
  void initState() {
    super.initState();

    bookmarkStore.getBookMarkList();
  }

  //region User Info sheet
  void profileInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Observer(
          builder: (context) {
            if (appStore.isLoading)
              return ProfileShimmerComponent();
            else
              return ProfileWidget();
          },
        );
      },
    );
  }

  //endregion

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
    return Observer(
      builder: (_) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: InternetConnectivityWidget(
            retryCallback: () {
              setState(() {});
            },
            child: pages[selectedIndex],
          ),
          bottomNavigationBar: Blur(
            blur: 0.5,
            borderRadius: radius(0),
            elevation: 6,
            color: context.cardColor,
            child: BottomNavStyle3(
              navBarEssentials: NavBarEssentials(
                navBarHeight: 54,
                selectedIndex: selectedIndex,
                backgroundColor: context.cardColor,
                padding: NavBarPadding.all(0),
                onItemSelected: (index) {
                  if (index == (getBoolAsync(HAS_IN_REVIEW) ? 3 : 4)) {
                    profileInfoSheet(context);
                  } else {
                    if (index == 1 && !appStore.isLoggedIn) {
                      SignInScreen().launch(context);
                    } else {
                      selectedIndex = index;
                      setState(() {});
                    }
                  }
                },
                items: [
                  PersistentBottomNavBarItem(
                    activeColorPrimary: primaryColor,
                    icon: Image.asset(ic_home_bold, width: 22, height: 22, color: primaryColor),
                    inactiveIcon: Image.asset(ic_home,
                        width: 18, height: 18, color: appStore.isDarkMode ? Colors.grey.shade500 : Colors.black),
                  ),
                  PersistentBottomNavBarItem(
                    activeColorPrimary: primaryColor,
                    icon: Image.asset(ic_bookmark_bold, width: 22, height: 22, color: primaryColor),
                    inactiveIcon: Image.asset(ic_bookmark,
                        width: 22, height: 22, color: appStore.isDarkMode ? Colors.grey.shade500 : Colors.black),
                  ),
                  PersistentBottomNavBarItem(
                    activeColorPrimary: primaryColor,
                    icon: Image.asset(ic_category_bold, width: 22, height: 22, color: primaryColor),
                    inactiveIcon: Image.asset(ic_category,
                        width: 22, height: 22, color: appStore.isDarkMode ? Colors.grey.shade500 : Colors.black),
                  ),
                  if (!getBoolAsync(HAS_IN_REVIEW))
                    PersistentBottomNavBarItem(
                      activeColorPrimary: primaryColor,
                      icon: Lottie.asset(youtube_gif),
                      inactiveIcon: Lottie.asset(youtube_gif),
                    ),
                  PersistentBottomNavBarItem(
                    activeColorPrimary: primaryColor,
                    icon: Image.asset(ic_profile_bold, width: 22, height: 22, color: primaryColor),
                    inactiveIcon: Image.asset(ic_profile,
                        width: 22, height: 22, color: appStore.isDarkMode ? Colors.grey.shade500 : Colors.black),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
