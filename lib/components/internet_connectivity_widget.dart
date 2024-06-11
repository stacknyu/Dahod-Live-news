import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/components/empty_error_state_widget.dart';
import 'package:news_flutter/main.dart';

class InternetConnectivityWidget extends StatelessWidget {
  final Widget child;
  VoidCallback? retryCallback;
  InternetConnectivityWidget({required this.child, this.retryCallback});

  @override
  Widget build(BuildContext context) {
    if (appStore.isConnectedToInternet)
      return child;
    else
      return NoDataWidget(
        title: language.lblNoInternetMsg,
        imageWidget: ErrorStateWidget(),
        onRetry: () {
          if (!appStore.isConnectedToInternet) toast(language.lblNoInternetMsg);
          if (appStore.isConnectedToInternet) toast(language.lblConnectedToInternet);

          if (appStore.isConnectedToInternet) retryCallback?.call();
        },
      );
  }
}
