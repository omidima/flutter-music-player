import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_music_player/utils/utils.dart';
import 'package:simple_music_player/view/home/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashServices {
  static isFirstTime({required BuildContext context}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final check = pref.getBool('OPENED') ?? false;

    bool permission = await Utils.requestPermission();
    Timer(const Duration(milliseconds: 1000), () async {
      if (permission && check) {
        Utils.go(context: context, screen: const HomeView(), replace: true);
      } else {
        Utils.go(context: context, screen: const HomeView(), replace: true);
      }
    });
  }
}
