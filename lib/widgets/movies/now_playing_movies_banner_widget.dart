import 'package:flutter/material.dart';
import 'package:rabka_movie/api/api.dart';
import 'package:rabka_movie/models/movie_model.dart';
import 'package:rabka_movie/screens/movies/movie_detail_screen.dart';
import 'package:rabka_movie/utils/colors.dart';

class NowPlayingMoviesBannerWidget extends StatefulWidget {
  const NowPlayingMoviesBannerWidget({Key? key}) : super(key: key);

  @override
  State<NowPlayingMoviesBannerWidget> createState() =>
      _NowPlayingMoviesBannerWidgetState();
}

class _NowPlayingMoviesBannerWidgetState
    extends State<NowPlayingMoviesBannerWidget> {
  late Future<List<Movie>> _nowPlayingMovies;

  @override
  void initState() {
    super.initState();
    _nowPlayingMovies = Api().getNowPlayingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: SizedBox(
        height: 150,
        child: FutureBuilder<List<Movie>>(
          future: _nowPlayingMovies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              final List<Movie> nowPlayingMoviesData = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: nowPlayingMoviesData.length,
                itemBuilder: (context, index) {
                  final backDropPath = nowPlayingMoviesData[index].backDropPath;
                  final imageUrl =
                      "https://image.tmdb.org/t/p/original/$backDropPath";
                  final title = nowPlayingMoviesData[index].title;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailScreen(
                                dataMovies: nowPlayingMoviesData[index],
                                indexVideoMovie: 0,
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: <Widget>[
                            Image.network(
                              imageUrl,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                color: Colors.black54,
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                color: primaryColor,
                                child: const Text(
                                  'Live',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
}
