import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_music_player/bloc/player_bloc/player_bloc.dart';
import 'package:simple_music_player/model/audio_file_model.dart';
import 'package:simple_music_player/res/app_svg.dart';
import 'package:simple_music_player/utils/utils.dart';
import 'package:simple_music_player/view/common_widget/app_bar.dart';
import 'package:simple_music_player/view/player/components/song_controllers.dart';
import 'package:simple_music_player/view/player/components/song_title.dart';

import 'components/song_circle_container.dart';

class Player extends StatelessWidget {
  const Player({super.key, required this.file, required this.image});
  final AudioFile file;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomAppBar(
                        preIcon: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: Colors.black,
                          ),
                        ),
                        postIcon: SvgPicture.asset(
                          AppSvg.more,
                          width: 17,
                        ),
                      ),
                      BlocBuilder<PlayerBloc, PlayerEvent>(
                        buildWhen: (previous, current) =>
                            current is OnPlayEvent,
                        builder: (context, state) {
                          if (BlocProvider.of<PlayerBloc>(context)
                              .player
                              .currentIndex != null) {
                            final file =
                                BlocProvider.of<PlayerBloc>(context).musics[
                                    BlocProvider.of<PlayerBloc>(context)
                                        .player
                                        .currentIndex!];
                            return Column(
                              children: [
                                SongTitle(
                                  file: file,
                                ),
                                Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  child: Center(
                                    child: SongCircleContainer(
                                      file: file,
                                      image: Utils.getRandomImage(),
                                    ),
                                  ),
                                )
                              ],
                            );
                          } else {
                            return Text("loading");
                          }
                        },
                      ),
                    ],
                  ),
                  BlocBuilder<PlayerBloc, PlayerEvent>(
                    buildWhen: (previous, current) => current is OnPlayEvent,
                    builder: (context, state) => Expanded(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: SongControllers(
                          file: file,
                          isLiked: state is OnPlayEvent
                              ? state.isLiked
                              : false,
                        ),
                      ),
                    ),
                  )
                  // SizedBox(height: 40,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
