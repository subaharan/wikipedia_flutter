import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wikipedia_flutter/common/strings.dart';
import 'package:wikipedia_flutter/views/search_page.dart';

import 'bloc/search_bloc.dart';
import 'common/size_config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context,constrains){
          return OrientationBuilder(
            builder: (context, orientation){
              SizeConfig().init(constrains, orientation);
              return MaterialApp(
                localizationsDelegates: [
                  // ... app-specific localization delegate[s] here
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: [
                  const Locale('en', ''), // English, no country code
                  const Locale('ar', ''), // Arabic, no country code
                  const Locale('hi', ''), // Arabic, no country code
                  const Locale.fromSubtags(languageCode: 'zh'), // Chinese *See Advanced Locales below*
                  // ... other locales the app supports
                ],

                title: Strings.wikipedia,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: BlocProvider(
                  create: (context) =>
                      SearchBloc(),
                  child: SearchPage(),
                ),
              );
            },
          );
        }
    );
  }

}


