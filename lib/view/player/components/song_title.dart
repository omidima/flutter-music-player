import 'package:flutter/material.dart';
import 'package:simple_music_player/model/audio_file_model.dart';
import 'package:simple_music_player/res/app_string.dart';

import '../../../res/app_colors.dart';

class SongTitle extends StatelessWidget {
  const SongTitle({super.key, required this.file});
  final AudioFile file;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        children: [

          Text(
            file.name.toString().length>20? '${file.name.toString().substring(0,20)}...':file.name.toString(),
            style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          Text(
            AppStrings.listen,
            style: TextStyle(
                color: blueBackground,
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),

        ],
      ),
    );
  }
}
