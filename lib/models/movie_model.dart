class Movie {
  final int id;
  final String title;
  final double rate;
  final String overview;
  final String backDropPath;
  final String posterPath;

  Movie({
    required this.id,
    required this.title,
    required this.rate,
    required this.overview,
    required this.backDropPath,
    required this.posterPath,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      rate: map['vote_average'],
      overview: map['overview'],
      backDropPath: map['backdrop_path'],
      posterPath: map['poster_path'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'rate': rate,
      'overview': overview,
      'backDropPath': backDropPath,
      'posterPath': posterPath,
    };
  }
}

class GenresMovie {
  final String genresName;

  GenresMovie({
    required this.genresName,
  });

  factory GenresMovie.fromMap(Map<String, dynamic> map) {
    return GenresMovie(
      genresName: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'genresName': genresName,
    };
  }
}

class MovieDetails {
  final int id;
  final String title;
  final String overview;
  final String releaseDate;
  final List<GenresMovie> genres;

  MovieDetails({
    required this.id,
    required this.title,
    required this.overview,
    required this.releaseDate,
    required this.genres,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    List<GenresMovie> genresList = (json['genres'] as List)
        .map((genre) => GenresMovie.fromMap(genre))
        .toList();

    return MovieDetails(
      id: json['id'],
      title: json['original_title'],
      overview: json['overview'],
      releaseDate: json['release_date'],
      genres: genresList,
    );
  }
}
