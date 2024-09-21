import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_music_player/utils/utils.dart';
import 'package:simple_music_player/view/seach_music/search_music_screen.dart';

import '../../res/app_svg.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, this.title, this.preIcon, this.postIcon});
  final String? title;
  final Widget? preIcon;
  final Widget? postIcon;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Positioned(
            left: 1,
            child: preIcon ?? SvgPicture.asset(AppSvg.drawer, height: 20),
          ),
          Center(
            child: Text(
              title ?? Utils.getGreetingMessage(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          Positioned(
            right: 1,
            child: postIcon ??
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Utils.go(context: context, screen: SearchMusicScreen());
                      },
                      child: SvgPicture.asset(
                        AppSvg.search,
                        color: Colors.black87,
                        width: 20,
                      ),
                    ),
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    // SvgPicture.asset(
                    //   AppSvg.notification,
                    //   color: Colors.black87,
                    //   width: 20,
                    // ),
                  ],
                ),
          )
        ],
      ),
    );
  }
}
