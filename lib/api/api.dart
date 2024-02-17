import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rabka_movie/models/movie_model.dart';
import 'package:rabka_movie/utils/global_variable.dart';

class Api {
  final nowPlayingApiUrl =
      "https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey";
  final popularApiUrl =
      "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey";
  final topRatedApiUrl =
      "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey";
  final upcomingApiUrl =
      "https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey";

  Future<List<Movie>> getNowPlayingMovies() async {
    final response = await http.get(Uri.parse(nowPlayingApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(Uri.parse(popularApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final response = await http.get(Uri.parse(topRatedApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load top rated movies');
    }
  }

  Future<List<Movie>> getUpcomingMovies() async {
    final response = await http.get(Uri.parse(upcomingApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  Future<List<VideoMovies>> getVideoMovies(int idMovie) async {
    final videoMovies =
        "https://api.themoviedb.org/3/movie/$idMovie/videos?api_key=$apiKey";

    final response = await http.get(Uri.parse(videoMovies));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<VideoMovies> videoMovies =
          data.map((videoMovies) => VideoMovies.fromMap(videoMovies)).toList();
      return videoMovies;
    } else {
      throw Exception('Failed to load video movies');
    }
  }

  Future<MovieDetails> getMovieDetails(int idMovie) async {
    final detailMovieUrl =
        "https://api.themoviedb.org/3/movie/$idMovie?api_key=$apiKey";

    final response = await http.get(Uri.parse(detailMovieUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return MovieDetails.fromJson(data);
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}
