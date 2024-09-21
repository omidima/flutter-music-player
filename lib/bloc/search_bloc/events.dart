part of 'cubit.dart';

abstract class SearchMusicEvent {}

class InitSearchState extends SearchMusicEvent {}

class FindItemState extends SearchMusicEvent {
  FindItemState({
    required this.items,
  });

  List<AudioFile> items;
}