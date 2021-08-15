class Movies {
  List<Movie> items = [];
  Movies();
  Movies.fromJsonList(List<dynamic> jsonList) {
    for (var item in jsonList) {
      final movie = new Movie.fromJsonMap(item);
      items.add(movie);
    }
  }
}

class Movie {
  String? uniqueId;

  String posterPath;
  int id;
  String backdropPath;
  String originalTitle;
  List<int> genreIds;
  String title;
  double voteAverage;
  String overview;
  String releaseDate;

  Movie({
    this.uniqueId,
    required this.posterPath,
    required this.id,
    required this.backdropPath,
    required this.originalTitle,
    required this.genreIds,
    required this.title,
    required this.voteAverage,
    required this.overview,
    required this.releaseDate,
  });

  factory Movie.fromJsonMap(Map<String, dynamic> json) => new Movie(
        posterPath: json['poster_path'] == null
            ? 'https://causeofaction.org/wp-content/uploads/2013/09/Not-available.gif'
            : 'https://image.tmdb.org/t/p/w500/${json['poster_path']}',
        id: json['id'],
        backdropPath: json['backdrop_path'] == null
            ? 'https://causeofaction.org/wp-content/uploads/2013/09/Not-available.gif'
            : 'https://image.tmdb.org/t/p/w500/${json['backdrop_path']}',
        originalTitle: json['original_title'],
        genreIds: json['genre_ids'].cast<int>(),
        title: json['title'],
        voteAverage: json['vote_average'] / 1,
        overview: json['overview'],
        releaseDate: json['release_date'] ?? '',
      );

  Map<int, String> genders = {
    28: 'Acción',
    12: 'Aventura',
    16: 'Animación',
    35: 'Comedia',
    80: 'Crimem',
    99: 'Documental',
    18: 'Drama',
    10751: 'Familia',
    14: 'Fantasía',
    36: 'Historia',
    27: 'Terror',
    10402: 'Música',
    9648: 'Misterio',
    10749: 'Romance',
    878: 'Ciencia ficción',
    10770: 'Película de TV',
    53: 'Suspenso',
    10752: 'Bélica',
    37: 'Occidental',
  };
}
