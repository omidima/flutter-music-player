import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:simple_music_player/db_helper/db_helper.dart';
import 'package:simple_music_player/model/audio_file_model.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Cubit<PlayerEvent> {
  final AudioPlayer player;
  Timer? timer;
  double progress = 0;
  final dbHelper = DbHelper();
  List<AudioFile> musics = [];

  PlayerBloc(this.player) : super(InitState()) {
    player.currentIndexStream.listen(_indexChangeListener);
  }

  _indexChangeListener(int? index) async {
    if (index != null) {
      emit(OnPlayEvent(
          file: musics[index],
          isLiked: await dbHelper.isFavoriteExists(musics[index].name!)));
      timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        progress = player.duration == null
            ? 0.0
            : player.position.inMilliseconds / player.duration!.inMilliseconds;
        emit(ProgressUpdateEvent(progress: progress));
        if (progress >= 1.0) {
          _.cancel();
        }
      });
    }
  }

  onCloseEvent() async {
    player.stop();
    timer?.cancel();
    emit(OnCloseEvent());
  }

  Future<void> onPlayPauseEvent() async {
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }

    emit(PlayPauseEvent());
  }

  Future<void> playAction(List<AudioFile> files) async {
    musics = files;

    final playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children:
          files.map((item) => AudioSource.file(item.path!.toString())).toList(),
    );

    await player.setAudioSource(playlist,
        initialIndex: 0, initialPosition: Duration.zero);

    onTapForwardEvent(isFirst: true);
  }

  Future<void> onTapFavorite(AudioFile file, BuildContext context) async {
    final alreadyExist = await dbHelper.isFavoriteExists(file.name.toString());
    if (alreadyExist) {
      await dbHelper.delete(file.name.toString());
    } else {
      await dbHelper.insert(file);
    }
  }

  void onTapForwardEvent({bool isFirst = false}) async {
    timer?.cancel();

    if (!isFirst) {
      await player.seekToNext();
    } else {
      _indexChangeListener(0);
    }
    player.play();
  }

  void onTapBackwardEvent() async {
    timer?.cancel();

    await player.seekToPrevious();
    player.play();
  }
}
