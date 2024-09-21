import 'package:easy_localization/easy_localization.dart' as t;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_music_player/bloc/album_bloc/album_bloc.dart';
import 'package:simple_music_player/bloc/album_bloc/album_event.dart';
import 'package:simple_music_player/bloc/home_bloc/home_event.dart';
import 'package:simple_music_player/bloc/player_bloc/player_bloc.dart';
import 'package:simple_music_player/res/app_colors.dart';
import 'package:simple_music_player/utils/utils.dart';
import 'package:simple_music_player/view/all_music/all_music.dart';
import 'package:simple_music_player/view/common_widget/app_bar.dart';
import 'package:simple_music_player/view/home/components/home_top_box.dart';
import 'package:simple_music_player/view/home/components/recently_played_list.dart';
import 'package:simple_music_player/view/home/components/song_widget.dart';
import 'package:simple_music_player/view/player/player.dart';

import '../../bloc/home_bloc/home_bloc.dart';
import '../../bloc/home_bloc/home_state.dart';
import 'components/home_bottom_player.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();

    context.read<HomeBloc>().add(GetAllMusics());
    context.read<AlbumBloc>().add(GetFolderEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          CustomScrollView(
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate.fixed([
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      const CustomAppBar(),
                      const SizedBox(
                        height: 40,
                      ),
                      const HomeIntroBox(),
                      const RecentlyPlayedList(),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Text(
                            'album',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ).tr(),
                          const Spacer(),
                          InkWell(
                            // onTap: () => ),
                            onTap: () {
                              context.read<AlbumBloc>().add(GetFolderEvent());
                              Utils.go(
                                  context: context,
                                  screen: const AllMusicAlbum());
                            },
                            child: const Text(
                              'see_all',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ).tr(),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ])),
              BlocBuilder<HomeBloc, HomeState>(
                buildWhen: (previous, current) =>
                    previous.songList != current.songList,
                builder: (context, state) {
                  if (state.songListStatus == Status.complete) {
                    return Directionality(
                      textDirection: TextDirection.ltr,
                      child: SliverList.builder(
                        itemCount: state.songList.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(16.0)
                              .copyWith(top: 8, bottom: 8),
                          child: InkWell(
                            onTap: () {
                              context
                                  .read<PlayerBloc>()
                                  .playAction(state.songList.sublist(index));
                              Utils.go(
                                  context: context,
                                  screen: Player(
                                    file: state.songList[index],
                                    image: Utils.getRandomImage(),
                                  ));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                      color: shadowColor,
                                      offset: Offset(8, 6),
                                      blurRadius: 12),
                                  const BoxShadow(
                                      color: Colors.white,
                                      offset: Offset(-8, -6),
                                      blurRadius: 12),
                                ],
                              ),
                              child: SongWidget(
                                image: Utils.getRandomImage(),
                                file: state.songList[index],
                                name: state.songList[index].name.toString(),
                                length: state.songList[index].length.toString(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SliverList.list(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Text(
                              "album",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ).tr(),
                            const Spacer(),
                            InkWell(
                              onTap: () => Utils.go(
                                  context: context, screen: AllMusicAlbum()),
                              child: const Text(
                                "see_all",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ).tr(),
                            )
                          ],
                        ),
                        // const FilesLoading(),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
          HomeBottomPlayer(),
        ],
      ),
    ));
  }
}
