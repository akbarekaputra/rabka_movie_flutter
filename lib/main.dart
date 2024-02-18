import 'dart:io';

import 'package:rabka_movie/provider/drawer_toggle_provider.dart';
import 'package:rabka_movie/provider/idVidePlay_provider.dart';
import 'package:rabka_movie/responsive/mobile_screen_layout.dart';
import 'package:rabka_movie/responsive/responsive_layout.dart';
import 'package:rabka_movie/responsive/web_screen_layout.dart';
import 'package:rabka_movie/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialise app based on platform- web or mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAk_-pGN5qz8jgPTsbiRZ81gnv1P-6GDSY2",
        appId: "1:823653093142:web:dce206158cf31b53fc8a37",
        messagingSenderId: "823653093142",
        projectId: "rabka-movie-01",
        storageBucket: "rabka-movie-01.appspot.com",
      ),
    );
  } else if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAJJSxofBW4e_Dh6HeIzMz4aKo4vFvn4aE",
        appId: "1:823653093142:android:a9a391eb9d754698fc8a37",
        messagingSenderId: "823653093142",
        projectId: "rabka-movie-01",
        storageBucket: "rabka-movie-01.appspot.com",
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
        ChangeNotifierProvider(create: (_) => DrawerToggleProvider()),
        ChangeNotifierProvider(create: (_) => IsVidPlayProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Consumer<DrawerToggleProvider>(
          builder: (context, toggleProvider, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: 'Poppins',
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: primaryColor,
                  primary: primaryColor,
                ),
                scaffoldBackgroundColor: toggleProvider.toggleValue
                    ? Colors.black87
                    : bgPrimaryColor,
              ),
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
      ),
    );
  }
}
