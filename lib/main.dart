import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:rabka_movie/provider/dark_mode_toggle_provider.dart';
import 'package:rabka_movie/provider/isVideoPlay_provider.dart';
import 'package:rabka_movie/responsive/mobile_screen_layout.dart';
import 'package:rabka_movie/responsive/responsive_layout.dart';
import 'package:rabka_movie/responsive/web_screen_layout.dart';
import 'package:rabka_movie/utils/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rabka_movie/utils/global_variable.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  // initialise app based on platform- web or mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: apiKeyWeb,
        appId: appId,
        messagingSenderId: messagingSenderId,
        projectId: projectId,
        storageBucket: storageBucket,
      ),
    );
  } else if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: apiKeyAndroid,
        appId: appId,
        messagingSenderId: messagingSenderId,
        projectId: projectId,
        storageBucket: storageBucket,
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DarkModeToggleProvider()),
        ChangeNotifierProvider(create: (_) => IsVideoPlayProvider()),
      ],
      child: Consumer<DarkModeToggleProvider>(
        builder: (context, toggleProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: _buildThemeData(toggleProvider),
            title: 'Rabka Movie',
            home: const Scaffold(
              body: ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              ),
            ),
          );
        },
      ),
    );
  }

  ThemeData _buildThemeData(DarkModeToggleProvider toggleProvider) {
    return ThemeData(
      fontFamily: 'Poppins',
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
      ),
      scaffoldBackgroundColor:
          toggleProvider.toggleValue ? Colors.black87 : bgPrimaryColor,
    );
  }
}
