
import 'package:flutter/material.dart';

Image assetImage(String name, {double width, double height, BoxFit fit}) {
  return Image.asset('${CustomImage.IMAGE_PATH}$name', width: width, height: height, fit: fit);
}

class CustomImage {

  static const String IMAGE_PATH = 'static/images/';

  static const String LIVE_BEAUTY = 'live_beauty.png';

}


