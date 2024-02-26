import 'package:rabka_movie/screens/home/home_screen.dart';
import 'package:rabka_movie/screens/local/local_screen.dart';
import 'package:rabka_movie/screens/movies/movies_screen.dart';
import 'package:rabka_movie/screens/series/series_screen.dart';
import 'package:flutter/material.dart';

const webScreenSize = 600;

const apiKey = "b822a913ac91d291333b43feddcaac11";

final List<Widget> homeScreenItems = [
  const HomeScreen(),
  const MoviesScreen(),
  const SeriesScreen(),
  const LocalScreen(),
];
