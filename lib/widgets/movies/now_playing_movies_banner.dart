import 'package:rabka_movie/api/api.dart';
import 'package:rabka_movie/models/movie_model.dart';
import 'package:rabka_movie/utils/colors.dart';
import 'package:flutter/material.dart';

class NowPlayingMoviesBanner extends StatefulWidget {
  const NowPlayingMoviesBanner({super.key});

  @override
  State<NowPlayingMoviesBanner> createState() => _NowPlayingMoviesBannerState();
}

class _NowPlayingMoviesBannerState extends State<NowPlayingMoviesBanner> {
  late Future<List<Movie>> nowPlayingMovies;

  @override
  void initState() {
    super.initState();
    nowPlayingMovies = Api().getNowPlayingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: SizedBox(
        height: 150,
        child: FutureBuilder<List<Movie>>(
          future: nowPlayingMovies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final nowPlayingMoviesData = snapshot.data!;
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
                        onTap: () {},
                        child: Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: GestureDetector(
                                onTap: () {},
                                child: Image.network(
                                  imageUrl,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
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
