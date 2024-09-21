import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:simple_music_player/res/app_string.dart';
import 'package:simple_music_player/utils/utils.dart';
import 'package:simple_music_player/view/home/home_view.dart';
import 'package:simple_music_player/view/onBoarding/components/first_page.dart';
import 'package:simple_music_player/view/onBoarding/components/second_page.dart';
import 'package:simple_music_player/view/onBoarding/components/third_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int _curentPage = 0;
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 20),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
            child: InkWell(
              onTap: () async {
                if (_curentPage == 2) {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  await pref.setBool("OPENED", true);
                  return Utils.go(context: context, screen: const HomeView());
                }

                _controller.animateToPage(++_curentPage,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.bounceIn);

                setState(() {});
              },
              child: Container(
                height: 50,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Let\'s go',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
          child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: PageView(
              controller: _controller,
              children: const [
                FirstPage(),
                SecondPage(),
                ThirdPage(),
              ],
            ),
          ),
          Positioned(
              right: 40,
              top: 50,
              child: InkWell(
                onTap: () {
                  Utils.go(context: context, screen: const HomeView());
                },
                child: const Text(
                  AppStrings.skip,
                ),
              ))
        ],
      )),
    );
  }
}
