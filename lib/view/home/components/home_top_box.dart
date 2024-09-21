import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_music_player/res/app_images.dart';
import 'package:simple_music_player/res/app_svg.dart';

import '../../../res/app_colors.dart';

class HomeIntroBox extends StatelessWidget {
  const HomeIntroBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 150,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: shadowColor, offset: const Offset(8, 6), blurRadius: 12),
            const BoxShadow(
                color: Colors.white, offset: Offset(-8, -6), blurRadius: 12),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  AppImages.imageList[12]!,
                  fit: BoxFit.cover,
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 30,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white70,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "recently_played",
                          style: TextStyle(color: Colors.white, fontSize: 8),
                        ).tr(),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "header_name",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ).tr(),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "header_direct",
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ).tr(),
                          const Text(
                            'header_desc',
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 8),
                          ).tr(),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaY: 4, sigmaX: 4),
                        child: Container(
                          height: 40,
                          width: 110,
                          margin: const EdgeInsets.only(bottom: 30),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black26),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'listen',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ).tr(),
                              const SizedBox(
                                width: 10,
                              ),
                              CircleAvatar(
                                radius: 11,
                                backgroundColor: Colors.white,
                                child: Center(
                                  child: SvgPicture.asset(
                                    AppSvg.play,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
