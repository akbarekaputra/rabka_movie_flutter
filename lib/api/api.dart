import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rabka_movie/models/movie_model.dart';
import 'package:rabka_movie/utils/global_variable.dart';

class Api {
  static const String _baseUrl = "https://api.themoviedb.org";
  static const String _apiKeyParam = "api_key=$apiKey";

  Future<List<Movie>> _fetchMovies(String apiUrl) async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Movie>> getNowPlayingMovies() async {
    const apiUrl = "$_baseUrl/3/movie/now_playing?$_apiKeyParam";
    return _fetchMovies(apiUrl);
  }

  Future<List<Movie>> getPopularMovies() async {
    const apiUrl = "$_baseUrl/3/movie/popular?$_apiKeyParam";
    return _fetchMovies(apiUrl);
  }

  Future<List<Movie>> getTopRatedMovies() async {
    const apiUrl = "$_baseUrl/3/movie/top_rated?$_apiKeyParam";
    return _fetchMovies(apiUrl);
  }

  Future<List<Movie>> getUpcomingMovies() async {
    const apiUrl = "$_baseUrl/3/movie/upcoming?$_apiKeyParam";
    return _fetchMovies(apiUrl);
  }

  Future<MovieDetails> getMovieDetails(int idMovie) async {
    final apiUrl = "$_baseUrl/3/movie/$idMovie?$_apiKeyParam";

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return MovieDetails.fromJson(data);
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}
