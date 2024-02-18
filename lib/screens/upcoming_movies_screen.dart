import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabka_movie/api/api.dart';
import 'package:rabka_movie/models/movie_model.dart';
import 'package:rabka_movie/provider/drawer_toggle_provider.dart';
import 'package:rabka_movie/screens/movie_detail_screen.dart';
import 'package:rabka_movie/utils/colors.dart';

class UpcomingMoviesScreen extends StatefulWidget {
  const UpcomingMoviesScreen({super.key});

  @override
  State<UpcomingMoviesScreen> createState() => _UpcomingMoviesScreenState();
}

class _UpcomingMoviesScreenState extends State<UpcomingMoviesScreen> {
  late Future<List<Movie>> upcomingMovies;

  @override
  void initState() {
    super.initState();
    upcomingMovies = Api().getUpcomingMovies();
  }

  @override
  Widget build(BuildContext context) {
    bool _toggleValue = Provider.of<DrawerToggleProvider>(context).toggleValue;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _toggleValue == true ? Colors.black87 : bgPrimaryColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: _toggleValue == true ? bgPrimaryColor : primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        centerTitle: true,
        title: Text(
          "Upcoming Movies",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: _toggleValue == true ? bgPrimaryColor : primaryColor,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: const Icon(Icons.search, size: 25),
              color: _toggleValue == true ? bgPrimaryColor : primaryColor,
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: FutureBuilder<List<Movie>>(
          future: upcomingMovies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: primaryColor,
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final upcomingMoviesData = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: (upcomingMoviesData.length / 2).ceil(),
                itemBuilder: (context, index) {
                  final int firstIndex = index * 2;
                  final int secondIndex = index * 2 + 1;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailScreen(
                                      dataMovies:
                                          upcomingMoviesData[firstIndex],
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
                                      "https://image.tmdb.org/t/p/original/${upcomingMoviesData[firstIndex].posterPath}",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _toggleValue == true
                                            ? Colors.white
                                            : Colors.black,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(3),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          for (int i = 0;
                                              i <
                                                  upcomingMoviesData[firstIndex]
                                                          .rate
                                                          .toInt() /
                                                      2;
                                              i++)
                                            const Icon(
                                              Icons.star_rate,
                                              color: primaryColor,
                                              size: 12,
                                            ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailScreen(
                                      dataMovies:
                                          upcomingMoviesData[secondIndex],
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
                                      "https://image.tmdb.org/t/p/original/${upcomingMoviesData[secondIndex].posterPath}",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _toggleValue == true
                                            ? Colors.white
                                            : Colors.black,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(3),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          for (int i = 0;
                                              i <
                                                  upcomingMoviesData[
                                                              secondIndex]
                                                          .rate
                                                          .toInt() /
                                                      2;
                                              i++)
                                            const Icon(
                                              Icons.star_rate,
                                              color: primaryColor,
                                              size: 12,
                                            ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
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
    );
  }
}
