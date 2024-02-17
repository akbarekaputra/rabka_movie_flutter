import 'package:rabka_movie/api/api.dart';
import 'package:rabka_movie/models/movie_model.dart';
import 'package:rabka_movie/provider/drawer_toggle_provider.dart';
import 'package:rabka_movie/screens/top_rated_movies_screen.dart';
import 'package:rabka_movie/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopRatedMovies extends StatefulWidget {
  const TopRatedMovies({Key? key}) : super(key: key);

  @override
  State<TopRatedMovies> createState() => _TopRatedMoviestate();
}

class _TopRatedMoviestate extends State<TopRatedMovies> {
  late Future<List<Movie>> topRatedMovies;

  @override
  void initState() {
    super.initState();
    topRatedMovies = Api().getTopRatedMovies();
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TopRatedMoviesScreen(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Top Rated Movies",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: _toggleValue == true
                            ? bgPrimaryColor
                            : Colors.black87,
                      ),
                    ),
                    Icon(
                      Icons.navigate_next,
                      color:
                          _toggleValue == true ? bgPrimaryColor : primaryColor,
                    ),
                  ],
                ),
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
              future: topRatedMovies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: primaryColor,
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final topRatedMoviesData = snapshot.data!;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: topRatedMoviesData.length,
                    itemBuilder: (context, index) {
                      final posterPath = topRatedMoviesData[index].posterPath;
                      final imageUrl =
                          "https://image.tmdb.org/t/p/original/$posterPath";
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
