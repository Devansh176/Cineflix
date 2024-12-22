import 'package:cineflix/widgets/movies/english/action.dart';
import 'package:cineflix/widgets/movies/english/adventureMovies.dart';
import 'package:cineflix/widgets/movies/english/animationMovies.dart';
import 'package:cineflix/widgets/movies/english/comedyMovies.dart';
import 'package:cineflix/widgets/movies/english/documentaryMovies.dart';
import 'package:cineflix/widgets/movies/english/dramaMovies.dart';
import 'package:cineflix/widgets/movies/english/familyMovies.dart';
import 'package:cineflix/widgets/movies/english/historyMovies.dart';
import 'package:cineflix/widgets/movies/english/horrorMovies.dart';
import 'package:cineflix/widgets/movies/english/musicFilms.dart';
import 'package:cineflix/widgets/movies/english/mysteryMovies.dart';
import 'package:cineflix/widgets/movies/english/popular.dart';
import 'package:cineflix/widgets/movies/english/romanceMovies.dart';
import 'package:cineflix/widgets/movies/english/scienceFictionMovies.dart';
import 'package:cineflix/widgets/movies/english/thriller.dart';
import 'package:cineflix/widgets/movies/english/topRated.dart';
import 'package:cineflix/widgets/movies/english/trendingMovies.dart';
import 'package:cineflix/widgets/movies/english/upcomingMovies.dart';
import 'package:cineflix/widgets/movies/english/westernMovies.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tmdb_api/tmdb_api.dart';

class EngMovies extends StatefulWidget {
  const EngMovies({super.key});

  @override
  State<EngMovies> createState() => _EngMoviesState();
}

class _EngMoviesState extends State<EngMovies> {
  late Box englishMoviesBox;

  Map<String, List> englishMoviesData = {
    'trendingMovies' : [],
    'topRatedMovies' : [],
    'popularMovies' : [],
    'upcomingMovies' : [],
    'horrorMovies' : [],
    'thrillerMovies' : [],
    'actionMovies' : [],
    'adventureMovies' : [],
    'animationMovies' : [],
    'comedyMovies' : [],
    'romanceMovies' : [],
    'sciFiMovies' : [],
    'documentaryMovies' : [],
    'historyMovies' : [],
    'mysteryMovies' : [],
    'westernMovies' : [],
    'dramaMovies' : [],
    'familyMovies' : [],
    'musicFilms' : [],
  };

  final String apiKey = 'caab8223e29b6c77c16940d6e2ccfa5e';
  final String readAccessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjYWFiODIyM2UyOWI2Yzc3YzE2OTQwZDZlMmNjZmE1ZSIsIm5iZiI6MTczMjc5OTg0Mi41NzYsInN1YiI6IjY3NDg2ZDYyMmVkMzlhM2FmMTcxZTFiOCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.EYnIzQkuqB3oQtFYdJHn1xg7bVXxkqf6eCg7SGw5yFo';

  late TMDB tmdbWithCustomLogs;

  @override
  void initState() {
    super.initState();
    initializeHive().then((_) => loadMovies());
    tmdbWithCustomLogs = TMDB(
      ApiKeys(apiKey, readAccessToken),
      logConfig: ConfigLogger(showErrorLogs: true, showLogs: true),
    );
    loadMovies();
  }

  Future<void> initializeHive() async {
    await Hive.initFlutter();
    englishMoviesBox = await Hive.openBox('EnglishMoviesCache');
  }

  Future<void> loadMovies() async {
    try {
      final categories = {
        'trendingMovies': () => tmdbWithCustomLogs.v3.trending.getTrending(language: 'en-US'),
        'topRatedMovies': () => tmdbWithCustomLogs.v3.movies.getTopRated(language: 'en-US'),
        'popularMovies': () => tmdbWithCustomLogs.v3.movies.getPopular(language: 'en-US'),
        'upcomingMovies': () => tmdbWithCustomLogs.v3.movies.getUpcoming(language: 'en-US'),
        'horrorMovies': () => tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '27', language: 'en-US'),
        'thrillerMovies': () => tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '53', language: 'en-US'),
        'actionMovies': () => tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '28', language: 'en-US'),
        'adventureMovies': () => tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '12', language: 'en-US'),
        'animationMovies': () => tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '16', language: 'en-US'),
        'comedyMovies': () => tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '35', language: 'en-US'),
        'romanceMovies': () => tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '10749', language: 'en-US'),
        'sciFiMovies': () => tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '878', language: 'en-US'),
        'documentaryMovies': () => tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '99', language: 'en-US'),
        'historyMovies': () => tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '36', language: 'en-US'),
        'mysteryMovies': () => tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '9648', language: 'en-US'),
        'westernMovies': () => tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '37', language: 'en-US'),
        'dramaMovies': () => tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '18', language: 'en-US'),
        'familyMovies': () => tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '10751', language: 'en-US'),
        'musicFilms': () => tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '10402', language: 'en-US'),
      };

      for (var category in categories.keys) {
        print("Checking Hive cache for category: $category");
        final cachedData = englishMoviesBox.get(category);

        if (cachedData != null && cachedData.isNotEmpty) {
          print("Using cached data for $category: ${cachedData.length} items");
          englishMoviesData[category] = cachedData;
        } else {
          print("No cached data for $category. Fetching from API...");
          final response = await categories[category]!();
          final results = response['results'];
          if (results != null) {
            print("Fetched ${results.length} items for $category");
            englishMoviesData[category] = results;
            await englishMoviesBox.put(category, results);
          } else {
            print("No results from API for $category");
          }
        }
      }

      setState(() {});
    } catch (e) {
      print("Error Loading Movies: $e");
    }
  }

  @override
  void dispose() {
    englishMoviesBox.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: TrendingMovies(trendingMovies: englishMoviesData['trendingMovies']!,),
          ),
          SliverToBoxAdapter(
            child: UpcomingMovies(upcomingMovies: englishMoviesData['upcomingMovies']!),
          ),
          SliverToBoxAdapter(
            child: PopularMovies(popularMovies: englishMoviesData['popularMovies']!),
          ),
          SliverToBoxAdapter(
            child: TopRatedMovies(topRatedMovies: englishMoviesData['topRatedMovies']!,),
          ),
          SliverToBoxAdapter(
            child: HorrorMovies(horrorMovies: englishMoviesData['horrorMovies']!),
          ),
          SliverToBoxAdapter(
            child: ThrillerMovies(thrillerMovies: englishMoviesData['thrillerMovies']!),
          ),
          SliverToBoxAdapter(
            child: ActionMovies(actionMovies: englishMoviesData['actionMovies']!),
          ),
          SliverToBoxAdapter(
            child: AdventureMovies(adventureMovies: englishMoviesData['adventureMovies']!),
          ),
          SliverToBoxAdapter(
            child: AnimationMovies(animationMovies: englishMoviesData['animationMovies']!),
          ),
          SliverToBoxAdapter(
            child: ComedyMovies(comedyMovies: englishMoviesData['comedyMovies']!),
          ),
          SliverToBoxAdapter(
            child: RomanceMovies(romanceMovies: englishMoviesData['romanceMovies']!),
          ),
          SliverToBoxAdapter(
            child: DocumentaryMovies(documentaryMovies: englishMoviesData['documentaryMovies']!),
          ),
          SliverToBoxAdapter(
            child: ScienceFictionMovies(scienceFictionMovies: englishMoviesData['sciFiMovies']!),
          ),
          SliverToBoxAdapter(
            child: HistoryMovies(historyMovies: englishMoviesData['historyMovies']!),
          ),
          SliverToBoxAdapter(
            child: WesternMovies(westernMovies: englishMoviesData['westernMovies']!),
          ),
          SliverToBoxAdapter(
            child: MysteryMovies(mysteryMovies: englishMoviesData['mysteryMovies']!,),
          ),
          SliverToBoxAdapter(
            child: DramaMovies(dramaMovies: englishMoviesData['dramaMovies']!,),
          ),
          SliverToBoxAdapter(
            child: FamilyMovies(familyMovies: englishMoviesData['familyMovies']!,),
          ),
          SliverToBoxAdapter(
            child: MusicFilms(musicFilms: englishMoviesData['musicFilms']!,),
          ),
        ],
      ),
    );
  }
}
