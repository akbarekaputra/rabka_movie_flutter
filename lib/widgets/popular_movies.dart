import 'package:rabka_movie/api/api.dart';
import 'package:rabka_movie/models/movie_model.dart';
import 'package:rabka_movie/provider/drawer_toggle_provider.dart';
import 'package:rabka_movie/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularMovies extends StatefulWidget {
  const PopularMovies({Key? key}) : super(key: key);

  @override
  State<PopularMovies> createState() => _PopularMovieState();
}

class _PopularMovieState extends State<PopularMovies> {
  late Future<List<Movie>> popularMovies;

  @override
  void initState() {
    super.initState();
    popularMovies = Api().getPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    bool _toggleValue = Provider.of<DrawerToggleProvider>(context).toggleValue;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Popular Movies",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: _toggleValue == true
                          ? bgPrimaryColor
                          : Colors.black87,
                    ),
                  ),
                  const Icon(Icons.navigate_next),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SizedBox(
            height: 150,
            child: FutureBuilder<List<Movie>>(
              future: popularMovies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: primaryColor,
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final popularMoviesData = snapshot.data!;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: popularMoviesData.length,
                    itemBuilder: (context, index) {
                      final backDropPath =
                          popularMoviesData[index].backDropPath;
                      final imageUrl =
                          "https://image.tmdb.org/t/p/original/$backDropPath";
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: GestureDetector(
                                onTap: () {},
                                child: Image.network(
                                  imageUrl,
                                  width: 105,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
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
        ),
      ],
    );
  }
}
