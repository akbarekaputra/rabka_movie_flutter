import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rabka_movie/models/movie_model.dart';
import 'package:rabka_movie/provider/dark_mode_toggle_provider.dart';
import 'package:rabka_movie/provider/isVideoPlay_provider.dart';
import 'package:rabka_movie/resources/like_methods.dart';
import 'package:rabka_movie/utils/colors.dart';
import 'package:rabka_movie/utils/global_variable.dart';
import 'package:rabka_movie/widgets/movies/detail_movie/thumnail_video_widget.dart';
import 'package:rabka_movie/widgets/movies/detail_movie/top_nav_widget.dart';
import 'package:rabka_movie/widgets/movies/detail_movie/youtube_player_widget.dart';

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
  Map<String, dynamic>? _videoMovie;
  Map<String, dynamic>? _movieDetails;
  int _likeMovie = 0;
  bool _isDescriptionClicked = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      await Future.wait([
        _fetchVideoMovie(widget.dataMovies.id),
        _fetchMovieDetails(widget.dataMovies.id),
      ]);
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> _fetchVideoMovie(int idMovie) async {
    final videoMoviesUrl =
        "https://api.themoviedb.org/3/movie/$idMovie/videos?api_key=$apiKey";

    final response = await http.get(Uri.parse(videoMoviesUrl));

    if (response.statusCode == 200) {
      setState(() {
        _videoMovie = json.decode(response.body);
      });
      _initializeLikeMovie();
    } else {
      print('Failed to load movie videos. Status code: ${response.statusCode}');
    }
  }

  Future<void> _fetchMovieDetails(int idMovie) async {
    final detailMovieUrl =
        "https://api.themoviedb.org/3/movie/$idMovie?api_key=$apiKey";

    final response = await http.get(Uri.parse(detailMovieUrl));

    if (response.statusCode == 200) {
      setState(() {
        _movieDetails = json.decode(response.body);
      });
    } else {
      print(
          'Failed to load movie details. Status code: ${response.statusCode}');
    }
  }

  Future<void> _initializeLikeMovie() async {
    int fetchedLike = await LikeMethods().getLikeMovie(
      widget.dataMovies.id,
      _videoMovie?["results"][widget.indexVideoMovie]["id"],
    );
    setState(() {
      _likeMovie = fetchedLike;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool _darkModeToggleValue =
        Provider.of<DarkModeToggleProvider>(context).toggleValue;

    final isVideoPlayProvider = Provider.of<IsVideoPlayProvider>(context);
    bool _isVidPlay = isVideoPlayProvider.isVideoPlay;

    return Scaffold(
      appBar: _isVidPlay ? null : TopNavWidget(dataMovies: widget.dataMovies),
      body: _videoMovie != null && _movieDetails != null
          ? SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 240,
                      child: _isVidPlay
                          ? YoutubePlayerWidget(
                              videoMovieData: _videoMovie,
                              indexVideoMovie: widget.indexVideoMovie,
                            )
                          : ThumbnailVideoWidget(
                              keyVideo: _videoMovie?["results"]
                                  [widget.indexVideoMovie]["key"],
                            ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20, top: 15),
                      height: 100,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
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
                                        color: _darkModeToggleValue
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
                                          if (_movieDetails?["genres"] !=
                                                  null &&
                                              _movieDetails?["genres"].length >
                                                  0)
                                            Text(
                                              _movieDetails?["genres"][0]
                                                  ["name"],
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: secondaryColor,
                                              ),
                                            ),
                                          if (_movieDetails?["genres"] !=
                                                  null &&
                                              _movieDetails?["genres"].length >
                                                  1)
                                            const Text(
                                              "  •  ",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: secondaryColor,
                                              ),
                                            ),
                                          if (_movieDetails?["genres"] !=
                                                  null &&
                                              _movieDetails?["genres"].length >
                                                  1)
                                            Text(
                                              _movieDetails?["genres"][1]
                                                  ["name"],
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: secondaryColor,
                                              ),
                                            ),
                                          if (_movieDetails?["genres"] !=
                                                  null &&
                                              _movieDetails?["genres"].length >
                                                  2)
                                            const Text(
                                              "  •  ",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: secondaryColor,
                                              ),
                                            ),
                                          if (_movieDetails?["genres"] !=
                                                  null &&
                                              _movieDetails?["genres"].length >
                                                  2)
                                            Text(
                                              _movieDetails?["genres"][2]
                                                  ["name"],
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
                                      _movieDetails?["release_date"],
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
                          Container(
                            height: 100,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 10, right: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.star),
                                Text(
                                  (_movieDetails?["vote_average"] is double
                                      ? (_movieDetails?["vote_average"])
                                          .toStringAsFixed(2)
                                      : (_movieDetails?["vote_average"]
                                              .toString()) ??
                                          ""),
                                  style: const TextStyle(
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
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(left: 20, top: 10, right: 20),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isDescriptionClicked = !_isDescriptionClicked;
                          });
                        },
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: _isDescriptionClicked
                                    ? (_movieDetails?['overview'])
                                    : '${_movieDetails?['overview'].substring(0, 80)}...',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: _darkModeToggleValue
                                      ? bgPrimaryColor
                                      : Colors.black,
                                ),
                              ),
                              if (!_isDescriptionClicked)
                                TextSpan(
                                  text: ' more',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: _darkModeToggleValue
                                        ? bgPrimaryColor
                                        : Colors.black,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                int updatedLike =
                                    await LikeMethods().postLikeMovie(
                                  widget.dataMovies.id,
                                  _videoMovie?["results"]
                                      [widget.indexVideoMovie]["id"],
                                  _likeMovie,
                                );
                                setState(() {
                                  _likeMovie = updatedLike;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: _darkModeToggleValue
                                      ? bgPrimaryColor
                                      : secondaryColor.withOpacity(0.1),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.thumb_up, size: 16),
                                    const SizedBox(width: 5),
                                    Text(_likeMovie.toString()),
                                  ],
                                ),
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
                                color: _darkModeToggleValue
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
                        ],
                      ),
                    ),
                    Container(
                      height: _videoMovie?["results"].length.isEven
                          ? (_videoMovie?["results"].length / 2) * 120
                          : ((_videoMovie?["results"].length + 1) / 2) * 120,
                      padding:
                          const EdgeInsets.only(left: 20, top: 20, right: 20),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: (_videoMovie?["results"].length / 2).ceil(),
                        itemBuilder: (context, index) {
                          final int firstIndex = index * 2;
                          final int secondIndex =
                              (index * 2 + 1 < _videoMovie?["results"].length)
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
                                        isVideoPlayProvider
                                            .setIsVideoPlay(true);
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
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                        'https://img.youtube.com/vi/${_videoMovie?["results"][firstIndex]["key"]}/0.jpg',
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
                                              isVideoPlayProvider
                                                  .setIsVideoPlay(true);
                                            });
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MovieDetailScreen(
                                                  dataMovies: widget.dataMovies,
                                                  indexVideoMovie: secondIndex,
                                                ),
                                              ),
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.network(
                                              'https://img.youtube.com/vi/${_videoMovie?["results"][secondIndex]["key"]}/0.jpg',
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
                    )
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
