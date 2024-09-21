import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:simple_music_player/bloc/album_bloc/album_bloc.dart';
import 'package:simple_music_player/bloc/home_bloc/home_bloc.dart';
import 'package:simple_music_player/bloc/player_bloc/player_bloc.dart';
import 'package:simple_music_player/db_helper/db_helper.dart';
import 'package:simple_music_player/res/app_colors.dart';
import 'package:simple_music_player/view/splash/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Bloc.observer = ApplicationBlocObserver();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('fa')],
        path: 'assets/translations',
        fallbackLocale: const Locale('fa'),
        startLocale: const Locale("fa"),
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeBloc(dbHelper: DbHelper()),
        ),
        BlocProvider(
          create: (_) => PlayerBloc(AudioPlayer()..setLoopMode(LoopMode.one)),
        ),
        BlocProvider(
          create: (_) => AlbumBloc(pageController: PageController()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          fontFamily: "yekan",
          scaffoldBackgroundColor: backgroundColor,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
  }
}

class ApplicationBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    print(
        'stateChange: ${bloc.runtimeType} ${change.currentState} ${change.nextState}');
    super.onChange(bloc, change);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError (${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}
