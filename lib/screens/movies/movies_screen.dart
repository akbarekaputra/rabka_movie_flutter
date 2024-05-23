import 'package:rabka_movie/provider/dark_mode_toggle_provider.dart';
import 'package:rabka_movie/utils/colors.dart';
import 'package:rabka_movie/widgets/movies/top_rated_movies_widget.dart';
import 'package:rabka_movie/widgets/movies/now_playing_movies_banner_widget.dart';
import 'package:rabka_movie/widgets/movies/popular_movies_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabka_movie/widgets/movies/upcoming_movies_widget.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({Key? key}) : super(key: key);

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  @override
  Widget build(BuildContext context) {
    bool _darkModeToggleValue =
        Provider.of<DarkModeToggleProvider>(context).toggleValue;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: _darkModeToggleValue == true ? Colors.black87 : bgPrimaryColor,
          child: const Column(
            children: [
              SizedBox(height: 10),
              NowPlayingMoviesBannerWidget(),
              SizedBox(height: 20),
              PopularMoviesWidget(),
              SizedBox(height: 20),
              TopRatedMoviesWidget(),
              SizedBox(height: 20),
              UpcomingMoviesWidget(),
              SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }
}
