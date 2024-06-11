import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'body_widget.dart';

class AppScaffold extends StatelessWidget {
  final String? appBarTitle;
  final List<Widget>? actions;

  final Widget body;
  final Color? scaffoldBackgroundColor;

  AppScaffold({this.appBarTitle, required this.body, this.actions, this.scaffoldBackgroundColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle.validate(), style: primaryTextStyle(color: Colors.white, size: 22)),
        elevation: 0.0,
        backgroundColor: context.primaryColor,
        actions: actions,
      ),
      backgroundColor: scaffoldBackgroundColor,
      body: Body(child: body),
    );
  }
}
