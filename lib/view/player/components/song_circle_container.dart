import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_music_player/bloc/player_bloc/player_bloc.dart';
import 'package:simple_music_player/model/audio_file_model.dart';

import '../../../res/app_colors.dart';
import '../../../res/app_svg.dart';
import '../../common_widget/soft_button.dart';

class SongCircleContainer extends StatelessWidget {
  const SongCircleContainer(
      {super.key, required this.file, required this.image});
  final String image;
  final AudioFile file;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 305,
      width: MediaQuery.sizeOf(context).width,
      child: Stack(
        alignment: Alignment.center,
        // fit: StackFit.expand,
        children: [
          Container(
            height: 270,
            width: 270,
            decoration: BoxDecoration(
                color: backgroundColor,
                boxShadow: [
                  BoxShadow(
                      color: shadowColor,
                      offset: const Offset(8, 6),
                      blurRadius: 12),
                  const BoxShadow(
                      color: Colors.white,
                      offset: Offset(-8, -6),
                      blurRadius: 12),
                ],
                shape: BoxShape.circle),
          ),
          Positioned(
            child: CircularSoftButton(
              padding: 0,
              radius: 120,
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(300),
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                    )),
              ),
            ),
          ),
          Container(
            height: 270,
            width: 270,
            padding: EdgeInsets.all(10),
            child: Transform.flip(
              flipX: true,
              child: Transform.rotate(
                angle: .25,
                child: RotatedBox(
                  quarterTurns: 2,
                  child: BlocBuilder<PlayerBloc, PlayerEvent>(
                    buildWhen: (previous, current) =>
                        current is ProgressUpdateEvent,
                    builder: (context, state) {
                      return CircularProgressIndicator(
                        color: blueBackground,
                        backgroundColor: Colors.grey.withOpacity(.1),
                        value: state.progress,
                        strokeWidth: 7,
                        strokeCap: StrokeCap.round,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: GestureDetector(
              onTap: () =>
                  BlocProvider.of<PlayerBloc>(context).onPlayPauseEvent(),
              child: CircleAvatar(
                radius: 32,
                backgroundColor: blueBackground,
                child: BlocBuilder<PlayerBloc, PlayerEvent>(
                  buildWhen: (previous, current) => current is PlayPauseEvent,
                  builder: (context, state) {
                    return AnimatedSwitcher(
                      switchInCurve: Curves.easeInOutBack,
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      duration: const Duration(milliseconds: 300),
                      child: Center(
                        child: SvgPicture.asset(
                          BlocProvider.of<PlayerBloc>(context).player.playing
                              ? AppSvg.pause
                              : AppSvg.play,
                          color: Colors.white,
                          width: 20,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
