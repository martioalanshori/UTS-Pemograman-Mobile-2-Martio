import 'package:flutter/foundation.dart';

import '../models/movie.dart';

class MovieProvider extends ChangeNotifier {
  MovieProvider() {
    _movies = [
      Movie(
        title: 'Drifting Stars',
        genre: 'Sci-Fi',
        rating: 4.8,
        duration: '2h 18m',
        posterPath: 'assets/besar1.webp',
        synopsis:
            'A stranded crew races against time when their ship gets lost between twin galaxies.',
        releaseYear: '2024',
        director: 'Mira Leighton',
        cast: const ['Ezra Wolfe', 'Mina Kade', 'Hayes Carter'],
        languages: const ['English', 'Japanese'],
        tags: const ['now', 'trending'],
      ),
      Movie(
        title: 'Midnight Pulse',
        genre: 'Thriller',
        rating: 4.6,
        duration: '1h 52m',
        posterPath: 'assets/besar2.webp',
        synopsis:
            'An investigative journalist uncovers a cyber conspiracy that syncs with people’s heartbeats.',
        releaseYear: '2023',
        director: 'Devon Hart',
        cast: const ['Sora Lee', 'Ivan Rhodes', 'Clara Holt'],
        languages: const ['English', 'Korean'],
        tags: const ['now', 'popular'],
      ),
      Movie(
        title: 'Aqua Dreams',
        genre: 'Drama',
        rating: 4.5,
        duration: '2h 05m',
        posterPath: 'assets/besar3.webp',
        synopsis:
            'Two sisters rebuild their bond while rescuing their family’s floating resort.',
        releaseYear: '2022',
        director: 'Nina Salvatore',
        cast: const ['Mara Kent', 'Isabella Cruz', 'Theo Park'],
        languages: const ['English', 'Spanish'],
        tags: const ['now', 'trending'],
      ),
      Movie(
        title: 'City of Echoes',
        genre: 'Action',
        rating: 4.4,
        duration: '2h 11m',
        posterPath: 'assets/poster1.webp',
        synopsis:
            'A retired agent returns to Neo Jakarta to dismantle a sound-based weapon.',
        releaseYear: '2021',
        director: 'Ridwan Malik',
        cast: const ['Rio Santoso', 'Lila Quinn'],
        languages: const ['Indonesian', 'English'],
        tags: const ['popular'],
      ),
      Movie(
        title: 'Neon Mirage',
        genre: 'Sci-Fi',
        rating: 4.3,
        duration: '1h 47m',
        posterPath: 'assets/poster2.webp',
        synopsis:
            'A hacker dives through augmented dreams to find the architect of a rogue AI.',
        releaseYear: '2024',
        director: 'Jules Navarro',
        cast: const ['Kai Torres', 'Marlowe Dean'],
        languages: const ['English', 'Mandarin'],
        tags: const ['popular', 'top'],
      ),
      Movie(
        title: 'Golden Hour',
        genre: 'Romance',
        rating: 4.7,
        duration: '2h 01m',
        posterPath: 'assets/poster3.webp',
        synopsis:
            'A travel photographer and meteorologist track sunsets around the world.',
        releaseYear: '2020',
        director: 'Alya Freeman',
        cast: const ['Lydia Hale', 'Noah Bishop'],
        languages: const ['English'],
        tags: const ['trending', 'top'],
        progress: 0.35,
      ),
      Movie(
        title: 'Parallel Nights',
        genre: 'Sci-Fi',
        rating: 4.9,
        duration: '2h 24m',
        posterPath: 'assets/poster4.webp',
        synopsis:
            'Scientists test a device that lets them live different versions of the same night.',
        releaseYear: '2024',
        director: 'Drake Odell',
        cast: const ['Rae Morgan', 'Micah Stone'],
        languages: const ['English'],
        tags: const ['top'],
      ),
      Movie(
        title: 'Velvet Shadow',
        genre: 'Drama',
        rating: 4.2,
        duration: '1h 58m',
        posterPath: 'assets/poster5.webp',
        synopsis:
            'A stage actor navigates fame when her alter ego becomes more popular than herself.',
        releaseYear: '2019',
        director: 'Helena Cruz',
        cast: const ['Vivian Lau', 'Seth Grant'],
        languages: const ['English', 'French'],
        tags: const ['popular'],
        progress: 0.6,
      ),
      Movie(
        title: 'Crimson Tide',
        genre: 'Action',
        rating: 4.1,
        duration: '1h 49m',
        posterPath: 'assets/poster6.webp',
        synopsis:
            'A coast guard captain confronts eco-terrorists threatening Java Sea.',
        releaseYear: '2022',
        director: 'Imam Rakha',
        cast: const ['Arman Surya', 'Bima Akmal'],
        languages: const ['Indonesian', 'English'],
        tags: const ['trending'],
      ),
      Movie(
        title: 'Echo Chamber',
        genre: 'Thriller',
        rating: 4.0,
        duration: '1h 44m',
        posterPath: 'assets/poster7.webp',
        synopsis:
            'Podcasters witness a crime during a live stream and become targets themselves.',
        releaseYear: '2021',
        director: 'Piper Sloan',
        cast: const ['Yara Hill', 'Declan Cruz'],
        languages: const ['English'],
        tags: const ['top'],
      ),
      Movie(
        title: 'Skyline Hearts',
        genre: 'Romance',
        rating: 4.1,
        duration: '1h 46m',
        posterPath: 'assets/poster8.webp',
        synopsis:
            'Two architects fall in love while competing for the same eco-tower bid.',
        releaseYear: '2022',
        director: 'Farah Kim',
        cast: const ['Nadia Song', 'Evan Ortiz'],
        languages: const ['English', 'Korean'],
        tags: const ['popular'],
        progress: 0.18,
      ),
      Movie(
        title: 'Iron Bounty',
        genre: 'Action',
        rating: 4.3,
        duration: '2h 06m',
        posterPath: 'assets/poster9.webp',
        synopsis:
            'A disgraced captain hunts a rogue mech pilot across the Pacific Rim.',
        releaseYear: '2023',
        director: 'Hasan Pratama',
        cast: const ['Rafi Dirga', 'Alexa Pierce'],
        languages: const ['Indonesian', 'English'],
        tags: const ['trending'],
      ),
      Movie(
        title: 'Glacier Run',
        genre: 'Adventure',
        rating: 4.5,
        duration: '1h 59m',
        posterPath: 'assets/poster10.webp',
        synopsis:
            'An endurance racer and her huskies cross melting ice to save a stranded research team.',
        releaseYear: '2021',
        director: 'Linnea Byers',
        cast: const ['Noor Elgin', 'Marcus Vale'],
        languages: const ['English', 'Finnish'],
        tags: const ['popular', 'trending'],
      ),
      Movie(
        title: 'Pulse Runner',
        genre: 'Sci-Fi',
        rating: 4.6,
        duration: '2h 02m',
        posterPath: 'assets/poster11.webp',
        synopsis:
            'A courier races through neon districts to reboot a failing digital sun.',
        releaseYear: '2024',
        director: 'Ivy Calder',
        cast: const ['Rey Matsuda', 'Hans Keller'],
        languages: const ['English', 'German'],
        tags: const ['top'],
      ),
      Movie(
        title: 'Hollow Garden',
        genre: 'Mystery',
        rating: 4.2,
        duration: '1h 51m',
        posterPath: 'assets/poster12.webp',
        synopsis:
            'Detectives investigate a botanical lab where plants encode human memories.',
        releaseYear: '2020',
        director: 'Claudia Mendez',
        cast: const ['Elio Vargas', 'Sena Amari'],
        languages: const ['English', 'Spanish'],
        tags: const ['popular'],
      ),
      Movie(
        title: 'Afterlight',
        genre: 'Horror',
        rating: 4.0,
        duration: '1h 43m',
        posterPath: 'assets/poster13.webp',
        synopsis:
            'Filmmakers awaken an ancient signal while shooting inside an abandoned observatory.',
        releaseYear: '2022',
        director: 'Gabe Holloway',
        cast: const ['Moira Lee', 'Dak Ashford'],
        languages: const ['English'],
        tags: const ['top'],
      ),
      Movie(
        title: 'Rainbow Arcade',
        genre: 'Animation',
        rating: 4.4,
        duration: '1h 32m',
        posterPath: 'assets/poster14.webp',
        synopsis:
            'Two siblings get trapped inside a retro game cabinet and must clear every color world.',
        releaseYear: '2019',
        director: 'Sofia Choi',
        cast: const ['Ava Mills', 'Shawn Poon'],
        languages: const ['English'],
        tags: const ['popular', 'trending'],
        progress: 0.42,
      ),
      Movie(
        title: 'Selena & The Waves',
        genre: 'Documentary',
        rating: 4.7,
        duration: '1h 48m',
        posterPath: 'assets/poster15.webp',
        synopsis:
            'A coastal sound designer captures healing frequencies with indigenous musicians.',
        releaseYear: '2023',
        director: 'Julio Cabrera',
        cast: const ['Selena Morente', 'Damar Waskita'],
        languages: const ['Spanish', 'Indonesian', 'English'],
        tags: const ['popular', 'trending'],
      ),
    ];
  }

  late List<Movie> _movies;
  String _selectedGenre = 'All';

  List<String> get genres => const [
        'All',
        'Action',
        'Adventure',
        'Animation',
        'Documentary',
        'Drama',
        'Horror',
        'Mystery',
        'Romance',
        'Sci-Fi',
        'Thriller',
      ];

  String get selectedGenre => _selectedGenre;

  List<Movie> get nowPlaying =>
      _movies.where((movie) => movie.tags.contains('now')).toList();

  List<Movie> get trending =>
      _movies.where((movie) => movie.tags.contains('trending')).toList();

  List<Movie> get popular =>
      _movies.where((movie) => movie.tags.contains('popular')).toList();

  List<Movie> get topRated =>
      _movies.where((movie) => movie.tags.contains('top')).toList();

  List<Movie> get filteredRecommendations {
    if (_selectedGenre == 'All') {
      return popular;
    }
    return popular
        .where((movie) => movie.genre.toLowerCase() ==
            _selectedGenre.toLowerCase())
        .toList();
  }

  List<Movie> get continueWatching => _movies
      .where((movie) => movie.progress > 0)
      .toList()
    ..sort((a, b) => b.progress.compareTo(a.progress));

  void selectGenre(String genre) {
    if (_selectedGenre == genre) return;
    _selectedGenre = genre;
    notifyListeners();
  }

  void toggleFavorite(Movie movie) {
    final index = _movies.indexWhere((element) => element.title == movie.title);
    if (index == -1) return;
    _movies[index].isFavorite = !_movies[index].isFavorite;
    notifyListeners();
  }

  List<Movie> get favorites =>
      _movies.where((movie) => movie.isFavorite).toList();

  Movie? findByTitle(String title) {
    try {
      return _movies.firstWhere(
        (movie) => movie.title.toLowerCase() == title.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  List<Movie> get allMovies => List.unmodifiable(_movies);
}

