import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_music_player/bloc/player_bloc/player_bloc.dart';
import 'package:simple_music_player/bloc/search_bloc/cubit.dart';
import 'package:simple_music_player/model/audio_file_model.dart';
import 'package:simple_music_player/res/app_colors.dart';
import 'package:simple_music_player/utils/utils.dart';
import 'package:simple_music_player/view/home/components/home_bottom_player.dart';
import 'package:simple_music_player/view/home/components/song_widget.dart';
import 'package:simple_music_player/view/player/player.dart';

// ignore: must_be_immutable
class SearchMusicScreen extends StatelessWidget {
  SearchMusicScreen({super.key});
  Timer? _timer = null;
  late final SearchCubit _cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        _cubit = SearchCubit(context);
        return _cubit;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          padding: const EdgeInsets.all(0),
                          alignment: Alignment.center,
                          icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 16, bottom: 8, left: 16, right: 0),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: shadowColor,
                                    offset: const Offset(8, 6),
                                    blurRadius: 12),
                                const BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(-8, -6),
                                    blurRadius: 12),
                              ]),
                          child: TextFormField(
                            onChanged: (value) async {
                              _timer?.cancel();
                              _timer = Timer(
                                const Duration(seconds: 1),
                                () {
                                  _cubit.search(value, context);
                                },
                              );
                            },
                            decoration: const InputDecoration(
                                hintText: "جستجو برای ...",
                                fillColor: Colors.transparent,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 12),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: BlocBuilder<SearchCubit, SearchMusicEvent>(
                      buildWhen: (previous, current) =>
                          current is InitSearchState ||
                          current is FindItemState,
                      builder: (context, state) {
                        if (state is FindItemState) {
                          return ListView.builder(
                            itemBuilder: (context, index) =>
                                _MusicItem(file: state.items[index]),
                            itemCount: state.items.length,
                          );
                        }

                        return const Center(
                          child: Text("موردی برای نمایش نیست"),
                        );
                      },
                    ),
                  )
                ],
              ),
              HomeBottomPlayer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _MusicItem extends StatelessWidget {
  const _MusicItem({required this.file});
  final AudioFile file;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0).copyWith(top: 8, bottom: 8),
      child: InkWell(
        onTap: () {
          context.read<PlayerBloc>().playAction([file]);
          Utils.go(
              context: context,
              screen: Player(
                file: file,
                image: Utils.getRandomImage(),
              ));
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: shadowColor, offset: Offset(8, 6), blurRadius: 12),
              const BoxShadow(
                  color: Colors.white, offset: Offset(-8, -6), blurRadius: 12),
            ],
          ),
          child: SongWidget(
            image: Utils.getRandomImage(),
            file: file,
            name: file.name.toString(),
            length: file.length.toString(),
          ),
        ),
      ),
    );
  }
}
