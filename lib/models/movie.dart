class Movie {
  Movie({
    required this.title,
    required this.genre,
    required this.rating,
    required this.duration,
    required this.posterPath,
    required this.synopsis,
    required this.releaseYear,
    required this.director,
    required this.cast,
    required this.languages,
    this.progress = 0,
    this.tags = const [],
    this.isFavorite = false,
  });

  final String title;
  final String genre;
  final double rating;
  final String duration;
  final String posterPath;
  final String synopsis;
  final String releaseYear;
  final String director;
  final List<String> cast;
  final List<String> languages;
  final double progress;
  final List<String> tags;
  bool isFavorite;

  Movie copyWith({
    bool? isFavorite,
  }) {
    return Movie(
      title: title,
      genre: genre,
      rating: rating,
      duration: duration,
      posterPath: posterPath,
      synopsis: synopsis,
      releaseYear: releaseYear,
      director: director,
      cast: cast,
      languages: languages,
      progress: progress,
      tags: tags,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

