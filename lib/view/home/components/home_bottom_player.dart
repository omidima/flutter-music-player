import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_music_player/model/audio_file_model.dart';
import 'package:simple_music_player/utils/utils.dart';
import 'package:simple_music_player/view/player/player.dart';

import '../../../bloc/player_bloc/player_bloc.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_icons.dart';
import '../../../res/app_svg.dart';

// ignore: must_be_immutable
class HomeBottomPlayer extends StatelessWidget {
  HomeBottomPlayer({super.key});
  AudioFile? file;

  String calcTime(int time) {
    int min = time ~/ 60;
    int sec = (time % 60) - 1;

    return "$min:$sec";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerEvent>(
      buildWhen: (previous, current) =>
          current is OnCloseEvent || current is OnPlayEvent,
      builder: (context, state) {

        if (BlocProvider.of<PlayerBloc>(context).musics.isNotEmpty) {
          file = BlocProvider.of<PlayerBloc>(context).musics[
              BlocProvider.of<PlayerBloc>(context).player.currentIndex!];
        }

        return AnimatedPositioned(
            bottom:
                BlocProvider.of<PlayerBloc>(context).player.playing ? 20 : -150,
            duration: const Duration(milliseconds: 300),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width - 40,
                    child: InkWell(
                      onTap: () {
                        file != null ? Utils.go(
                            context: context,
                            screen: Player(
                              file: file!,
                              image: Utils.getRandomImage(),
                            )): print("file null");
                      },
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: Container(
                            height: 80,
                            width: 350,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 27,
                                  backgroundImage:
                                      AssetImage(AppIcons.splashIcons),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        file == null
                                            ? ''
                                            : file!.name.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        textDirection: TextDirection.ltr,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      BlocBuilder<PlayerBloc, PlayerEvent>(
                                        buildWhen: (previous, current) =>
                                            current is ProgressUpdateEvent,
                                        builder: (context, state) => Text(
                                          file == null
                                              ? ''
                                              : calcTime(
                                                  BlocProvider.of<PlayerBloc>(
                                                          context)
                                                      .player
                                                      .position
                                                      .inSeconds),
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      BlocBuilder<PlayerBloc, PlayerEvent>(
                                        buildWhen: (previous, current) =>
                                            current is ProgressUpdateEvent,
                                        builder: (context, state) => SizedBox(
                                          width: 120,
                                          child: LinearProgressIndicator(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            backgroundColor:
                                                Colors.grey.withOpacity(.1),
                                            color: blueBackground,
                                            value: state.progress,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          context
                                              .read<PlayerBloc>()
                                              .onTapBackwardEvent();
                                        },
                                        child: RotatedBox(
                                            quarterTurns: 2,
                                            child: SvgPicture.asset(
                                              AppSvg.prev,
                                              height: 20,
                                            )),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          context
                                              .read<PlayerBloc>()
                                              .onPlayPauseEvent();
                                        },
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: blueBackground,
                                          child: Center(
                                            child: BlocBuilder<PlayerBloc,
                                                PlayerEvent>(
                                              buildWhen: (previous, current) =>
                                                  current is PlayPauseEvent ||
                                                  current is OnPlayEvent,
                                              builder: (context, state) {
                                                return SvgPicture.asset(
                                                  BlocProvider.of<PlayerBloc>(
                                                              context)
                                                          .player
                                                          .playing
                                                      ? AppSvg.pause
                                                      : AppSvg.play,
                                                  color: Colors.white,
                                                  width: 15,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          context
                                              .read<PlayerBloc>()
                                              .onTapForwardEvent();
                                        },
                                        child: SvgPicture.asset(
                                          AppSvg.next,
                                          height: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        BlocProvider.of<PlayerBloc>(context).onCloseEvent();
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(360)),
                        child: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                      ),
                    )),
              ],
            ));
      },
    );
  }
}
