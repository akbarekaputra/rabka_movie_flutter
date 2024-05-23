import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabka_movie/api/api.dart';
import 'package:rabka_movie/models/movie_model.dart';
import 'package:rabka_movie/provider/dark_mode_toggle_provider.dart';
import 'package:rabka_movie/screens/movies/movie_detail_screen.dart';
import 'package:rabka_movie/utils/colors.dart';
import 'package:rabka_movie/widgets/second_top_nav_widget.dart';

class PopularMoviesScreen extends StatefulWidget {
  const PopularMoviesScreen({Key? key}) : super(key: key);

  @override
  State<PopularMoviesScreen> createState() => _PopularMoviesScreenState();
}

class _PopularMoviesScreenState extends State<PopularMoviesScreen> {
  late Future<List<Movie>> popularMovies;

  @override
  void initState() {
    super.initState();
    popularMovies = Api().getPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    final bool _darkModeToggleValue =
        Provider.of<DarkModeToggleProvider>(context).toggleValue;

    return Scaffold(
      appBar: const SecondTopNavWidget(title: "Popular Movie"),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder<List<Movie>>(
          future: popularMovies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final popularMoviesData = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: (popularMoviesData.length / 2).ceil(),
                itemBuilder: (context, index) {
                  final int firstIndex = index * 2;
                  final int secondIndex =
                      (index * 2 + 1 < popularMoviesData.length)
                          ? index * 2 + 1
                          : -1;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildMovieItem(popularMoviesData[firstIndex],
                              _darkModeToggleValue),
                        ),
                        const SizedBox(width: 10),
                        if (secondIndex != -1)
                          Expanded(
                            child: _buildMovieItem(
                                popularMoviesData[secondIndex],
                                _darkModeToggleValue),
                          ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildMovieItem(Movie movie, bool toggleValue) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(
              dataMovies: movie,
              indexVideoMovie: 0,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              "https://image.tmdb.org/t/p/original/${movie.posterPath}",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: toggleValue ? Colors.white : Colors.black,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(3),
                  topRight: Radius.circular(3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  (movie.rate.toInt() / 2).round(),
                  (index) => const Icon(
                    Icons.star_rate,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
