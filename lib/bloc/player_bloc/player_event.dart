part of 'player_bloc.dart';

abstract class PlayerEvent {
  final bool isPlaying;
  final double progress;
  final AudioFile? file;

  const PlayerEvent({this.file, this.isPlaying = false, this.progress = 0});
}

class InitState extends PlayerEvent {}

class PlayPauseEvent extends PlayerEvent {
  const PlayPauseEvent();
}

class OnPlayEvent extends PlayerEvent {
  final bool isLiked;
  OnPlayEvent({required AudioFile file, required this.isLiked}) : super(file: file);
}

class OnTapPrevEvent extends PlayerEvent {
  OnTapPrevEvent();
}

class ProgressUpdateEvent extends PlayerEvent {
  const ProgressUpdateEvent({required double progress})
      : super(progress: progress);
}

class OnTapFavouriteEvent extends PlayerEvent {
  final AudioFile file;
  final BuildContext context;
  const OnTapFavouriteEvent({required this.file, required this.context});
}

class OnTapForwardEvent extends PlayerEvent {}

class OnCloseEvent extends PlayerEvent {}

class OnTapBackwardEvent extends PlayerEvent {}
