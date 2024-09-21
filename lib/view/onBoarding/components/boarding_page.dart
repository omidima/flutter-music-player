import 'package:flutter/material.dart';
import '../../../res/app_colors.dart';

class BoardingPage extends StatelessWidget {
  const BoardingPage(
      {super.key, required this.text, this.image, required this.title});

  final String text;
  final String title;
  final String? image;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        SizedBox(
          height: size.height / 5,
        ),
        Text(
          title,
          style: TextStyle(
              color: blueShade, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(
          height: 8,
        ),
        const Text(
          'Let\'s vibe together!Create your own\nplaylist and enjoy music',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 60,
        ),
        Expanded(
            child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: size.height / 2.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(200),
                    topRight: Radius.circular(200),
                  ),
                  color: Colors.grey.withOpacity(.1)),
            ),
            // Image.asset(AppIcons.splashIcons),
          ],
        )),
      ],
    );
  }
}
