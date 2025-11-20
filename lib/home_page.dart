import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/movie.dart';
import 'pages/movie_detail_page.dart';
import 'providers/movie_provider.dart';
import 'widgets/continue_watching_card.dart';
import 'widgets/movie_poster_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF050509),
      drawer: const _AppDrawer(),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _selectedIndex == 0
              ? _HomeTab(onProfileTap: _openDrawer)
              : _selectedIndex == 1
                  ? const _DiscoverTab()
                  : const _FavoriteTab(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF050509),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white38,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
        ],
      ),
    );
  }
}

class _HomeTab extends StatefulWidget {
  const _HomeTab({required this.onProfileTap});

  final VoidCallback onProfileTap;

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();
    final List<Movie> searchResults = _searchQuery.isEmpty
        ? const []
        : provider.allMovies
            .where((movie) =>
                movie.title.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF050509), Color(0xFF101030), Color(0xFF0A051A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildSearchField(),
            if (_searchQuery.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildSectionHeader(
                'Search Results (${searchResults.length})',
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 240,
                child: searchResults.isEmpty
                    ? const Center(
            child: Text(
                          'No matches found.',
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final movie = searchResults[index];
                          final heroTag = 'search-${movie.title}-$index';
                          return MoviePosterCard(
                            movie: movie,
                            onFavoriteTap: () =>
                                provider.toggleFavorite(movie),
                            onTap: () => _openDetail(
                              context,
                              movie,
                              heroTag: heroTag,
                            ),
                            heroTag: heroTag,
                          );
                        },
                      ),
              ),
              const SizedBox(height: 24),
            ],
            const SizedBox(height: 24),
            _buildCarousel(provider.nowPlaying, provider),
            const SizedBox(height: 24),
            _buildGenreFilter(provider),
            const SizedBox(height: 16),
            _buildSectionHeader('Recommended For You', actionLabel: 'View all'),
            const SizedBox(height: 16),
            SizedBox(
              height: 320,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.filteredRecommendations.length,
                itemBuilder: (context, index) {
                  final movie = provider.filteredRecommendations[index];
                  final heroTag = 'recommend-${movie.title}-$index';
                  return MoviePosterCard(
                    movie: movie,
                    onFavoriteTap: () => provider.toggleFavorite(movie),
                    onTap: () => _openDetail(context, movie, heroTag: heroTag),
                    heroTag: heroTag,
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Continue Watching'),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.continueWatching.length,
                itemBuilder: (context, index) {
                  final movie = provider.continueWatching[index];
                  return ContinueWatchingCard(movie: movie);
                },
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Top Rated Picks'),
          const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.topRated.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final movie = provider.topRated[index];
                final heroTag = 'top-${movie.title}-$index';
                return _TopRatedCard(
                  movie: movie,
                  onFavoriteTap: () => provider.toggleFavorite(movie),
                  onTap: () => _openDetail(context, movie, heroTag: heroTag),
                  heroTag: heroTag,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Hi, Martio 👋',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Let’s pick something to watch tonight',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white10,
          ),
          child: const Icon(Icons.notifications_outlined, color: Colors.white),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: widget.onProfileTap,
          child: CircleAvatar(
            radius: 22,
            backgroundImage: const AssetImage('assets/usericon.png'),
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white70),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {
                _searchQuery = value;
              }),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search movies, series...',
                hintStyle: TextStyle(color: Colors.white54),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white54),
            onPressed: () {
              if (_searchQuery.isEmpty) return;
              _searchController.clear();
              setState(() => _searchQuery = '');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel(List<Movie> movies, MovieProvider provider) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 280,
        viewportFraction: 0.82,
        enlargeCenterPage: true,
        autoPlay: true,
      ),
      items: movies.map((movie) {
        final tag = 'hero-${movie.title}';
        return _HeroCard(
          movie: movie,
          onFavoriteTap: () => provider.toggleFavorite(movie),
          onTap: (ctx) => _openDetail(ctx, movie, heroTag: tag),
          heroTag: tag,
        );
      }).toList(),
    );
  }

  Widget _buildGenreFilter(MovieProvider provider) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final genre = provider.genres[index];
          final isSelected = genre == provider.selectedGenre;
          return GestureDetector(
            onTap: () => provider.selectGenre(genre),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: isSelected ? const Color(0xFF5BE4FF) : Colors.white10,
              ),
      child: Text(
                genre,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: provider.genres.length,
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? actionLabel}) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
            fontWeight: FontWeight.bold,
                      fontSize: 18,
          ),
        ),
        if (actionLabel != null)
          Text(
            actionLabel,
            style: const TextStyle(color: Colors.white54),
          ),
      ],
    );
  }

  void _openDetail(BuildContext context, Movie movie, {String? heroTag}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovieDetailPage(
          movie: movie,
          heroTag: heroTag ?? movie.title,
        ),
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Home', Icons.home_filled),
      ('TV Shows', Icons.live_tv),
      ('Movies', Icons.movie),
      ('My List', Icons.bookmark),
      ('Downloads', Icons.download),
      ('Kids', Icons.child_care),
      ('Account', Icons.person_outline),
      ('Help Center', Icons.help_outline),
    ];
    return Drawer(
      backgroundColor: const Color(0xFF0B0B1A),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 26,
                backgroundImage: const AssetImage('assets/usericon.png'),
                backgroundColor: Colors.white,
              ),
              title: const Text(
                'Martio Alanshori',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Premium plan',
                style: TextStyle(color: Colors.white54),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Divider(color: Colors.white12),
            Expanded(
            child: ListView.builder(
                itemCount: items.length,
              itemBuilder: (context, index) {
                  final entry = items[index];
                  return ListTile(
                    leading: Icon(entry.$2, color: Colors.white70),
                    title: Text(
                      entry.$1,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Navigating to ${entry.$1}'),
                          duration: const Duration(seconds: 1),
                  ),
                );
              },
                  );
                },
              ),
            ),
            const Divider(color: Colors.white12),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.pinkAccent),
              title: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.pinkAccent),
              ),
              onTap: () {},
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.movie,
    this.onFavoriteTap,
    this.onTap,
    required this.heroTag,
  });

  final Movie movie;
  final VoidCallback? onFavoriteTap;
  final void Function(BuildContext context)? onTap;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(context),
      child: Stack(
        children: [
          Hero(
            tag: heroTag,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                movie.posterPath,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Colors.transparent, Colors.black87],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        movie.genre,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.star, color: Color(0xFFFFB74D), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      movie.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onFavoriteTap,
                      child: Icon(
                        movie.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: movie.isFavorite
                            ? Colors.pinkAccent
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  movie.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  movie.duration,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5BE4FF),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Watch now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopRatedCard extends StatelessWidget {
  const _TopRatedCard({
    required this.movie,
    this.onFavoriteTap,
    this.onTap,
    required this.heroTag,
  });

  final Movie movie;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: const Color(0xFF1C1C2E),
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Expanded(
              child: Hero(
                tag: heroTag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    movie.posterPath,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
              children: [
                      const Icon(Icons.star,
                          color: Color(0xFFFFB74D), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        movie.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: onFavoriteTap,
                        child: Icon(
                          movie.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          color: movie.isFavorite
                              ? Colors.pinkAccent
                              : Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                Text(
                    movie.genre,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiscoverTab extends StatelessWidget {
  const _DiscoverTab();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Discover by genre',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: provider.genres
              .where((genre) => genre != 'All')
              .map(
                (genre) => Container(
                  width: 150,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1F1F2E), Color(0xFF10101D)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      genre,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 32),
        const Text(
          'Trending Today',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 16),
        ...provider.trending.map(
          (movie) {
            final heroTag = 'discover-${movie.title}-${movie.genre}';
            return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: GestureDetector(
              onTap: () => _openDetail(context, movie, heroTag),
              child: Row(
                children: [
                  Hero(
                    tag: heroTag,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        movie.posterPath,
                        height: 100,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${movie.genre} • ${movie.duration}',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 16, color: Color(0xFFFFB74D)),
                            const SizedBox(width: 4),
                            Text(
                              movie.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
              ],
            ),
          ),
                  IconButton(
                    onPressed: () => provider.toggleFavorite(movie),
                    icon: Icon(
                      movie.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      color:
                          movie.isFavorite ? Colors.pinkAccent : Colors.white,
                    ),
                  ),
                ],
              ),
                  ),
                );
              },
        ),
      ],
    );
  }

  void _openDetail(BuildContext context, Movie movie, String heroTag) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovieDetailPage(movie: movie, heroTag: heroTag),
      ),
    );
  }
}

class _FavoriteTab extends StatelessWidget {
  const _FavoriteTab();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();
    final favorites = provider.favorites;
    if (favorites.isEmpty) {
      return const Center(
        child: Text(
          'No favorites yet.\nTap the heart icon to save movies.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white60, fontSize: 16),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: favorites.length + 1,
      separatorBuilder: (context, index) =>
          index == 0 ? const SizedBox(height: 12) : const Divider(color: Colors.white12),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Your Favorites',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Curated list synced with your heart icons.',
                style: TextStyle(color: Colors.white60),
              ),
            ],
          );
        }

        final movie = favorites[index - 1];
        final heroTag = 'favorite-${movie.title}-$index';
        return ListTile(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MovieDetailPage(movie: movie, heroTag: heroTag),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 6),
          leading: Hero(
            tag: heroTag,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                movie.posterPath,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            movie.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            '${movie.genre} • ${movie.duration}',
            style: const TextStyle(color: Colors.white70),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.favorite, color: Colors.pinkAccent),
            onPressed: () => provider.toggleFavorite(movie),
          ),
        );
      },
    );
  }
}

