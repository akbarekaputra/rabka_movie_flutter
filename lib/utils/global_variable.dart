import 'package:rabka_movie/screens/home/home_screen.dart';
import 'package:rabka_movie/screens/local/local_screen.dart';
import 'package:rabka_movie/screens/movies/movies_screen.dart';
import 'package:rabka_movie/screens/series/series_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const webScreenSize = 600;

String apiKeyWeb = dotenv.env['API_KEY_WEB']!;
String apiKeyAndroid = dotenv.env['API_KEY_ANDROID']!;
String appId = dotenv.env['APP_ID']!;
String messagingSenderId = dotenv.env['MESSAGING_SENDER_ID']!;
String projectId = dotenv.env['PROJECT_ID']!;
String storageBucket = dotenv.env['STORAGE_BUCKET']!;
String apiKey = dotenv.env['API_KEY_TMDB']!;

final List<Widget> homeScreenItems = [
  const HomeScreen(),
  const MoviesScreen(),
  const SeriesScreen(),
  const LocalScreen(),
];
