import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabka_movie/api/api.dart';
import 'package:rabka_movie/models/movie_model.dart';
import 'package:rabka_movie/provider/drawer_toggle_provider.dart';
import 'package:rabka_movie/utils/colors.dart';
import 'package:rabka_movie/utils/global_variable.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie dataMovies;

  const MovieDetailScreen({
    Key? key,
    required this.dataMovies,
  }) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<List<VideoMovies>> videoMovie;
  Map<String, dynamic>? movieDetails;

  bool isClicked = false;

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
          movieDetails = json.decode(response.body);
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _toggleValue ? Colors.black87 : bgPrimaryColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: _toggleValue ? bgPrimaryColor : primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text(
          widget.dataMovies.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: _toggleValue ? bgPrimaryColor : primaryColor,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: const Icon(Icons.search, size: 25),
              color: _toggleValue ? bgPrimaryColor : primaryColor,
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 240,
              child: FutureBuilder<List<VideoMovies>>(
                future: videoMovie,
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
                    final videoMovieData = snapshot.data!;
                    return buildYoutubePlayer(videoMovieData);
                  } else {
                    return const Center(child: Text('No data available'));
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
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 3,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        movieDetails?["genres"]["name"],
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
                                    ],
                                  ),
                                )
                              ],
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.only(left: 20, top: 15, right: 20),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isClicked = !isClicked;
                    });
                  },
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: isClicked
                              ? (movieDetails?['overview'])
                              : '${movieDetails?['overview'].substring(0, 120)}...',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: secondaryColor,
                          ),
                        ),
                        if (!isClicked)
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
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 58),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: secondaryColor.withOpacity(0.1),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add, size: 16),
                        SizedBox(width: 5),
                        Text(
                          "Watchlist",
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 58),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: secondaryColor.withOpacity(0.1),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.share, size: 16),
                        SizedBox(width: 5),
                        Text("Share"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildYoutubePlayer(List<VideoMovies> videoMovieData) {
    final int lastIndex = videoMovieData.length - 1;
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // Do something when exit full screen
      },
      player: YoutubePlayer(
        controller: YoutubePlayerController(
          initialVideoId: videoMovieData[lastIndex].key,
          flags: const YoutubePlayerFlags(
            mute: false,
            autoPlay: false,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: true,
          ),
        ),
        showVideoProgressIndicator: true,
        progressIndicatorColor: bgPrimaryColor,
        progressColors: const ProgressBarColors(
          handleColor: primaryColor,
          playedColor: primaryColor,
        ),
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              videoMovieData[lastIndex].nameVideo,
              style: const TextStyle(
                color: bgPrimaryColor,
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: bgPrimaryColor,
              size: 25.0,
            ),
            onPressed: () {},
          ),
        ],
        onReady: () {
          // Do something when player is ready.
        },
        onEnded: (data) {
          // Do something when video ends.
        },
      ),
      builder: (context, player) {
        return player;
      },
    );
  }
}
