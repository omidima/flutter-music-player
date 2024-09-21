import 'dart:io';
import 'dart:math';

import 'package:just_audio/just_audio.dart';
import 'package:simple_music_player/db_helper/db_helper.dart';
import 'package:simple_music_player/model/audio_file_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class AudioFileQueries {
  static List<AudioFile> favourite = [];
  static final List<String> folders = [];

  static Future<List<AudioFile>> getFiles(String _path) async {
    List<AudioFile> audioList = [];
    final isPermissionGranted = await Permission.storage.isGranted;
    if (isPermissionGranted) {
      Directory directory = Directory(_path);
      List<FileSystemEntity> files = directory.listSync(recursive: true);
      List<String> audioExtensions = [
        '.mp3',
        '.wav',
        '.au',
        '.aac',
        '.smi',
        '.flac',
        '.ogg',
        '.m4a',
        '.wma'
      ];
      for (int i = 0; i < files.length; i++) {
        String extension = path.extension(files[i].path).toLowerCase();
        if (audioExtensions.contains(extension)) {
          String name = path.basename(files[i].path);
          String size = File(files[i].path).lengthSync().toString();
          String length = await getFileLength(files[i].path);
          int isFavourite = 0;

          audioList.add(AudioFile(
            id: Random().nextInt(1000000),
            name: name,
            path: files[i].path,
            size: size,
            length: length,
            isFavourite: isFavourite,
          ));
        }
      }
    } else {
      return [];
    }

    return audioList;
  }

  static Future<String> getFileLength(String filePath) async {
    AudioPlayer player = AudioPlayer();
    final _ = await player.setFilePath(filePath);
    String prefix = player.duration!.inMinutes.toString();
    String postFix = (player.duration!.inSeconds % 60).toString();
    if (prefix.length < 2) {
      prefix = '0$prefix';
    }
    if (postFix.length < 2) {
      postFix = '0$postFix';
    }
    player.dispose();
    return '$prefix:$postFix';
  }

  static Future<List<Map<String, String>>> getFolders() async {
    List<Map<String, String>> list = [];
    final audioQuery = OnAudioQuery();
    List<String> folders = await audioQuery.queryAllPath();
    for (var folder in folders) {
      list.add({'path': folder, 'name': path.basename(folder)});
    }
    return list;
  }

  static Future<List<AudioFile>> _findMusics(String _path) async {
    List<AudioFile> audioList = [];
    late Directory directory = Directory(_path);

    try {
      directory = Directory(_path);
    } catch (e) {
      return [];
    }

    List<FileSystemEntity> files = directory.listSync();

    List<String> audioExtensions = [
      '.mp3',
      '.wav',
      '.au',
      '.aac',
      '.smi',
      '.flac',
      '.ogg',
      '.m4a',
      '.wma'
    ];
    for (int i = 0; i < files.length; i++) {
      // try {
      String extension = path.extension(files[i].path).toLowerCase();
      if (audioExtensions.contains(extension)) {
        String name = path.basename(files[i].path);
        String size = File(files[i].path).lengthSync().toString();
        String length = await getFileLength(files[i].path);
        int isFavourite = 0;

        audioList.add(AudioFile(
          id: Random().nextInt(1000000),
          name: name,
          path: files[i].path,
          size: size,
          length: length,
          isFavourite: isFavourite,
        ));
      } else {}
      // } on FileSystemException catch (e) {
      //   print("directory not acceptable");
      // }
    }

    return audioList;
  }

  static Future<Null> _getAllMusicFiles({bool? getAllMusic}) async {
    List<Map<String, String>> list = await getFolders();

    list.forEach((item) {
      Directory directory = Directory(item["path"]!);
      folders.add(item["path"]!);
      List<FileSystemEntity> files = directory.listSync(recursive: true);

      files.forEach((action) {
        if (action.toString().contains("Directory")) {
          folders.add(action.path);
        }
      });
    });

    return null;
  }

  static Future<List<AudioFile>> getAllFiles({int page = 0}) async {
    final isPermissionGranted = await Permission.storage.isGranted;
    if (isPermissionGranted) {
      final List<AudioFile> items =
          await DbHelper().getAudioCache(take: 20, page: page);

      // update database audio cache
      _getAllMusicFiles().then((event) async {
        final List<AudioFile> musics = [];
        for (var index = 0; index < folders.length; index++) {
          var data = await _findMusics(folders[index]);
          musics.addAll(data);
        }

        // return data from database;
        await DbHelper().cacheAudios(musics);
      });
      return items;
    } else {
      return [];
    }
  }
}
