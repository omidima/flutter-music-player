import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:simple_music_player/bloc/home_bloc/home_bloc.dart';
import 'package:simple_music_player/bloc/home_bloc/home_event.dart';
import 'package:simple_music_player/bloc/player_bloc/player_bloc.dart' as bloc;
import 'package:simple_music_player/model/audio_file_model.dart';
import 'package:simple_music_player/res/app_colors.dart';
import 'package:simple_music_player/view/common_widget/soft_button.dart';
import '../../../res/app_svg.dart';

class SongControllers extends StatelessWidget {
  const SongControllers({super.key, required this.file, required this.isLiked});
  final AudioFile file;
  final bool isLiked;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SvgPicture.asset(AppSvg.loop, width: 20,),
        GestureDetector(
            child: const Icon(
          Icons.volume_down_alt,
          color: Colors.black,
        )),
        const SizedBox(
          width: 20,
        ),
        GestureDetector(
          onTap: () => context.read<bloc.PlayerBloc>().onTapBackwardEvent(),
          child: RotatedBox(
              quarterTurns: 2,
              child: SvgPicture.asset(
                AppSvg.prev,
                width: 25,
              )),
        ),
        const SizedBox(
          width: 20,
        ),
        _LikedButton(file: file, isLiked: isLiked),
        const SizedBox(
          width: 20,
        ),
        GestureDetector(
            onTap: () {
              BlocProvider.of<bloc.PlayerBloc>(context).onTapForwardEvent();
            },
            child: SvgPicture.asset(
              AppSvg.next,
              width: 25,
            )),
        const SizedBox(
          width: 20,
        ),
        _ReapetMode(),
      ],
    );
  }
}

class _LikedButton extends StatefulWidget {
  _LikedButton({
    super.key,
    required this.file,
    required this.isLiked,
  });

  final AudioFile file;
  bool isLiked;

  @override
  State<_LikedButton> createState() => _LikedButtonState();
}

class _LikedButtonState extends State<_LikedButton> {
  @override
  Widget build(BuildContext context) {
    return CircularSoftButton(
      radius: 25,
      padding: 0,
      icon: GestureDetector(
        onTap: () async {
          try {
            await context.read<bloc.PlayerBloc>().onTapFavorite(widget.file, context);
          } catch (_) {}
          Timer(const Duration(milliseconds: 500), () {
            context.read<HomeBloc>().add(GetFavSongEvent());
          });

          setState(() {
            widget.isLiked = !widget.isLiked;
          });
        },
        child: widget.isLiked
            ? Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: blueShade.withAlpha(40),
                ),
                child: Icon(
                  Icons.favorite,
                  color: blueShade, // to do change state here
                ),
              )
            : const Icon(
                Icons.favorite,
                color: Colors.black87, // to do change state here
              ),
      ),
    );
  }
}

class _ReapetMode extends StatefulWidget {
  const _ReapetMode({
    super.key,
  });

  @override
  State<_ReapetMode> createState() => _ReapetModeState();
}

class _ReapetModeState extends State<_ReapetMode> {
  _state(BuildContext context) {
    final mode = context.read<bloc.PlayerBloc>().player.loopMode;
    if (mode == LoopMode.off) {
      return Icons.repeat;
    } else if (mode == LoopMode.all) {
      return Icons.repeat_on_rounded;
    } else {
      return Icons.repeat_one_on_rounded;
    }
  }

  _setMode(BuildContext context) {
    final mode = context.read<bloc.PlayerBloc>().player.loopMode;
    if (mode == LoopMode.one) {
      context.read<bloc.PlayerBloc>().player.setLoopMode(LoopMode.all);
    } else if (mode == LoopMode.all) {
      context.read<bloc.PlayerBloc>().player.setLoopMode(LoopMode.off);
    } else {
      context.read<bloc.PlayerBloc>().player.setLoopMode(LoopMode.one);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          _setMode(context);
        },
        child: Icon(_state(context)));
  }
}
