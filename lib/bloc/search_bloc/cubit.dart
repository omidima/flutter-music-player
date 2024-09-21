import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_music_player/db_helper/db_helper.dart';
import 'package:simple_music_player/model/audio_file_model.dart';

part 'events.dart';

class SearchCubit extends Cubit<SearchMusicEvent> {
  final DbHelper _db = DbHelper();
  final BuildContext context;

  SearchCubit(this.context) : super(InitSearchState());

  search(String text, BuildContext context) async {
    final items = await _db.searchQuery(text);
    emit(FindItemState(items: items));
  }
}
