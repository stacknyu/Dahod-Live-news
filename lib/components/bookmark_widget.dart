import 'package:flutter/material.dart';
import 'package:news_flutter/utils/colors.dart';

class BookmarkWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Widget? icon;

  BookmarkWidget({required this.icon, this.onTap, this.backgroundColor = primaryColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => onTap?.call(),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        alignment: Alignment.topRight,
        child: icon,
      ),
    );
  }
}
