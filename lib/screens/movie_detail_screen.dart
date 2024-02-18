import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabka_movie/api/api.dart';
import 'package:rabka_movie/models/movie_model.dart';
import 'package:rabka_movie/provider/drawer_toggle_provider.dart';
import 'package:rabka_movie/provider/isVidePlay_provider.dart';
import 'package:rabka_movie/utils/colors.dart';
import 'package:rabka_movie/utils/global_variable.dart';
import 'package:rabka_movie/widgets/movies/detail_movie/thumnail_video_widget.dart';
import 'package:rabka_movie/widgets/movies/detail_movie/top_nav_widget.dart';
import 'package:rabka_movie/widgets/movies/detail_movie/youtube_player_widget.dart';
import 'package:http/http.dart' as http;

class MovieDetailScreen extends StatefulWidget {
  final Movie dataMovies;
  final int indexVideoMovie;

  const MovieDetailScreen({
    Key? key,
    required this.dataMovies,
    required this.indexVideoMovie,
  }) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<List<VideoMovies>> videoMovie;
  Map<String, dynamic>? movieDetails;

  bool isDescriptionClicked = false;
  bool isVideoClicked = false;

  @override
  void initState() {
    super.initState();
    videoMovie = Api().getVideoMovies(widget.dataMovies.id);
    fetchMovieDetails(widget.dataMovies.id);
  }

  Future<void> fetchMovieDetails(int idMovie) async {
    try {
      final detailMovieUrl =
          "https://api.themoviedb.org/3/movie/$idMovie?api_key=$apiKey";

      final response = await http.get(Uri.parse(detailMovieUrl));

      if (response.statusCode == 200) {
        setState(() {
          movieDetails = json.decode(response.body)!;
        });
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching movie details: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _toggleValue = Provider.of<DrawerToggleProvider>(context).toggleValue;
    final isVidPlayProvider = Provider.of<IsVidPlayProvider>(context);
    bool _isVidPlay = isVidPlayProvider.isVidPlay;

    return Scaffold(
      appBar: _isVidPlay ? null : TopNavWidget(dataMovies: widget.dataMovies),
      body: movieDetails != null
          ? SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 240,
                      child: FutureBuilder<List<VideoMovies>>(
                        future: videoMovie,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            final videoMovieData = snapshot.data!;

                            return _isVidPlay
                                ? YoutubePlayerWidget(
                                    videoMovieData: videoMovieData,
                                    indexVideoMovie: widget.indexVideoMovie,
                                  )
                                : ThumbnailVideoWidget(
                                    keyVideo:
                                        videoMovieData[widget.indexVideoMovie]
                                            .key);
                          } else {
                            return const Center(
                                child: Text('No data available'));
                          }
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20, top: 15),
                      height: 100,
                      width: double.infinity,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              "https://image.tmdb.org/t/p/original/${widget.dataMovies.posterPath}",
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            height: 100,
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.dataMovies.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: _toggleValue
                                        ? bgPrimaryColor
                                        : Colors.black,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 3,
                                  ),
                                  child: Row(
                                    children: [
                                      if (movieDetails?["genres"] != null &&
                                          movieDetails?["genres"].length > 0)
                                        Text(
                                          movieDetails?["genres"][0]["name"],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: secondaryColor,
                                          ),
                                        ),
                                      const Text(
                                        "  •  ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: secondaryColor,
                                        ),
                                      ),
                                      if (movieDetails?["genres"] != null &&
                                          movieDetails?["genres"].length > 1)
                                        Text(
                                          movieDetails?["genres"][1]["name"],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: secondaryColor,
                                          ),
                                        ),
                                      if (movieDetails?["genres"] != null &&
                                          movieDetails?["genres"].length > 2)
                                        const Text(
                                          "  •  ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: secondaryColor,
                                          ),
                                        ),
                                      if (movieDetails?["genres"] != null &&
                                          movieDetails?["genres"].length > 2)
                                        Text(
                                          movieDetails?["genres"][2]["name"],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: secondaryColor,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Text(
                                  movieDetails?["release_date"],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: secondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        padding:
                            const EdgeInsets.only(left: 20, top: 10, right: 20),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isDescriptionClicked = !isDescriptionClicked;
                            });
                          },
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: isDescriptionClicked
                                      ? (movieDetails?['overview'])
                                      : '${movieDetails?['overview'].substring(0, 80)}...',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: _toggleValue
                                        ? bgPrimaryColor
                                        : Colors.black,
                                  ),
                                ),
                                if (!isDescriptionClicked)
                                  const TextSpan(
                                    text: ' more',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )),
                    Container(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: _toggleValue
                                    ? bgPrimaryColor
                                    : secondaryColor.withOpacity(0.1),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, size: 16),
                                  SizedBox(width: 5),
                                  Text(
                                    "Watchlist",
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: _toggleValue
                                    ? bgPrimaryColor
                                    : secondaryColor.withOpacity(0.1),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.share, size: 16),
                                  SizedBox(width: 5),
                                  Text("Share"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<List<VideoMovies>>(
                      future: videoMovie,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                          final videoMovieData = snapshot.data!;
                          return Container(
                            padding: const EdgeInsets.only(
                                left: 20, top: 20, right: 20),
                            height: videoMovieData.length.isEven
                                ? (videoMovieData.length / 2) * 120
                                : ((videoMovieData.length + 1) / 2) * 120,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: (videoMovieData.length / 2).ceil(),
                              itemBuilder: (context, index) {
                                final int firstIndex = index * 2;
                                final int secondIndex =
                                    (index * 2 + 1 < videoMovieData.length)
                                        ? index * 2 + 1
                                        : -1;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isVidPlayProvider
                                                  .setIsVidPlay(true);
                                            });
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MovieDetailScreen(
                                                  dataMovies: widget.dataMovies,
                                                  indexVideoMovie: firstIndex,
                                                ),
                                              ),
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.network(
                                              'https://img.youtube.com/vi/${videoMovieData[firstIndex].key}/0.jpg',
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      secondIndex != -1
                                          ? Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isVidPlayProvider
                                                        .setIsVidPlay(true);
                                                  });
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          MovieDetailScreen(
                                                        dataMovies:
                                                            widget.dataMovies,
                                                        indexVideoMovie:
                                                            secondIndex,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: Image.network(
                                                    'https://img.youtube.com/vi/${videoMovieData[secondIndex].key}/0.jpg',
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Expanded(child: Container())
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return const Center(child: Text('No data available'));
                        }
                      },
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            ),
    );
  }
}
