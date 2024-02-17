import 'package:rabka_movie/provider/drawer_toggle_provider.dart';
import 'package:rabka_movie/utils/colors.dart';
import 'package:rabka_movie/widgets/movies/top_rated_movies.dart';
import 'package:rabka_movie/widgets/movies/now_playing_movies_banner.dart';
import 'package:rabka_movie/widgets/movies/popular_movies.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabka_movie/widgets/movies/upcoming_movies.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({Key? key}) : super(key: key);

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  @override
  Widget build(BuildContext context) {
    bool _toggleValue = Provider.of<DrawerToggleProvider>(context).toggleValue;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: _toggleValue == true ? Colors.black87 : bgPrimaryColor,
          child: const Column(
            children: [
              SizedBox(height: 10),
              NowPlayingMoviesBanner(),
              SizedBox(height: 20),
              PopularMovies(),
              SizedBox(height: 20),
              TopRatedMovies(),
              SizedBox(height: 20),
              UpcomingMovies(),
              SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }
}
