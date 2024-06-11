import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

extension StExt on String {
  Widget iconImageColored({double? size, Color? color, BoxFit? fit, double? height, double? width}) {
    return Image.asset(
      this,
      height: size ?? height ?? 24,
      width: size ?? width ?? 24,
      fit: fit ?? BoxFit.cover,
      color: color,
      errorBuilder: (context, error, stackTrace) {
        return PlaceHolderWidget();
      },
    );
  }
}
