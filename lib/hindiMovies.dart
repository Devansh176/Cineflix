import 'package:cineflix/widgets/movies/hindi/hindiAdventureMovies.dart';
import 'package:cineflix/widgets/movies/hindi/hindiAnimationMovies.dart';
import 'package:cineflix/widgets/movies/hindi/hindiComedyMovies.dart';
import 'package:cineflix/widgets/movies/hindi/hindiDocumentaryMovies.dart';
import 'package:cineflix/widgets/movies/hindi/hindiDramaMovies.dart';
import 'package:cineflix/widgets/movies/hindi/hindiFamilyMovies.dart';
import 'package:cineflix/widgets/movies/hindi/hindiHistoryMovies.dart';
import 'package:cineflix/widgets/movies/hindi/hindiHorrorMovies.dart';
import 'package:cineflix/widgets/movies/hindi/hindiMusicFilms.dart';
import 'package:cineflix/widgets/movies/hindi/hindiMysteryMovies.dart';
import 'package:cineflix/widgets/movies/hindi/hindiRomanceMovies.dart';
import 'package:cineflix/widgets/movies/hindi/hindiScienceFictionMovies.dart';
import 'package:cineflix/widgets/movies/hindi/hindiThriller.dart';
import 'package:cineflix/widgets/movies/hindi/hindiUpcomingMovies.dart';
import 'package:cineflix/widgets/movies/hindi/hindiWesternMovies.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tmdb_api/tmdb_api.dart';

class HindiMovies extends StatefulWidget {
  const HindiMovies({super.key});

  @override
  State<HindiMovies> createState() => _HindiMoviesState();
}

class _HindiMoviesState extends State<HindiMovies> {
  late Box hindiMoviesBox;

  Map<String, List> hindiMoviesData = {
    'trendingHindiMovies' : [],
    'topRatedHindiMovies' : [],
    'popularHindiMovies' : [],
    'upcomingHindiMovies' : [],
    'horrorHindiMovies' : [],
    'thrillerHindiMovies' : [],
    'actionHindiMovies' : [],
    'adventureHindiMovies' : [],
    'animationHindiMovies' : [],
    'comedyHindiMovies' : [],
    'romanceHindiMovies' : [],
    'sciFiHindiMovies' : [],
    'documentaryHindiMovies' : [],
    'historyHindiMovies' : [],
    'mysteryHindiMovies' : [],
    'westernHindiMovies' : [],
    'dramaHindiMovies' : [],
    'familyHindiMovies' : [],
    'musicHindiFilms' : [],
  };

  final String apiKey = 'caab8223e29b6c77c16940d6e2ccfa5e';
  final String readAccessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjYWFiODIyM2UyOWI2Yzc3YzE2OTQwZDZlMmNjZmE1ZSIsIm5iZiI6MTczMjgwMDM1Mi43OTc0NTIyLCJzdWIiOiI2NzQ4NmQ2MjJlZDM5YTNhZjE3MWUxYjgiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.14l3iY-IjTx0kJwnE17stnAvxo58nsENZD1-kIoWY7I';

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
    hindiMoviesBox = await Hive.openBox('HindiMoviesCache');
  }

  Future<void> loadMovies() async {
    try {
      final categories = {
        'upcomingHindiMovies': () =>
            tmdbWithCustomLogs.v3.movies.getUpcoming(
              language: 'en-US',
              region: 'IN',
            ),
        'horrorHindiMovies': () =>
            tmdbWithCustomLogs.v3.discover.getMovies(
              withGenres: '27',
              language: 'en-US',
              withOrginalLanguage: 'hi',
            ),
        'thrillerHindiMovies': () =>
            tmdbWithCustomLogs.v3.discover.getMovies(
              withGenres: '53',
              language: 'en-US',
              withOrginalLanguage: 'hi',
            ),
        'actionHindiMovies': () =>
            tmdbWithCustomLogs.v3.discover.getMovies(
              withGenres: '28',
              language: 'en-US',
              withOrginalLanguage: 'hi',
            ),
        'adventureHindiMovies': () =>
            tmdbWithCustomLogs.v3.discover.getMovies(
              withGenres: '12',
              language: 'en-US',
              withOrginalLanguage: 'hi',
            ),
        'animationHindiMovies': () =>
            tmdbWithCustomLogs.v3.discover.getMovies(
              withGenres: '16',
              language: 'en-US',
              withOrginalLanguage: 'hi'
            ),
        'comedyHindiMovies': () =>
            tmdbWithCustomLogs.v3.discover.getMovies(
              withGenres: '35',
              language: 'en-US',
              withOrginalLanguage: 'hi',
            ),
        'romanceHindiMovies': () =>
            tmdbWithCustomLogs.v3.discover.getMovies(
              withGenres: '10749',
              language: 'en-US',
              withOrginalLanguage: 'hi',
            ),
        'sciFiHindiMovies': () =>
            tmdbWithCustomLogs.v3.discover.getMovies(
              withGenres: '878',
              language: 'en-US',
              withOrginalLanguage: 'hi',
            ),
        'documentaryHindiMovies': () =>
            tmdbWithCustomLogs.v3.discover.getMovies(
              withGenres: '99',
              language: 'en-US',
              withOrginalLanguage: 'hi',
            ),
        'historyHindiMovies': () =>
            tmdbWithCustomLogs.v3.discover.getMovies(
              withGenres: '36',
              language: 'en-US',
              withOrginalLanguage: 'hi',
            ),
        'mysteryHindiMovies': () =>
            tmdbWithCustomLogs.v3.discover.getMovies(
              withGenres: '9648',
              language: 'en-US',
              withOrginalLanguage: 'hi',
            ),
        'westernHindiMovies': () =>
            tmdbWithCustomLogs.v3.discover.getMovies(
              withGenres: '37',
              language: 'en-US',
              withOrginalLanguage: 'hi',
            ),
        'dramaHindiMovies': () =>
            tmdbWithCustomLogs.v3.discover.getMovies(
              withGenres: '18',
              language: 'en-US',
              withOrginalLanguage: 'hi',
            ),
        'familyHindiMovies': () =>
            tmdbWithCustomLogs.v3.discover.getMovies(
              withGenres: '10751',
              language: 'en-US',
              withOrginalLanguage: 'hi',
            ),
        'musicHindiFilms': () =>
            tmdbWithCustomLogs.v3.discover.getMovies(
              withGenres: '10402',
              language: 'en-US',
              withOrginalLanguage: 'hi',
            ),
      };

      for (var category in categories.keys) {
        final cachedData = hindiMoviesBox.get(category);
        if (cachedData != null) {
          hindiMoviesData[category] = cachedData;
        } else {
          final response = await categories[category]!();
          final results = response['results'];
          hindiMoviesData[category] = results;
          await hindiMoviesBox.put(category, results);
        }
      }
      setState(() {});
    } catch (e) {
      print("Error Loading Movies : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HindiUpcomingMovies(hindiUpcomingMovies: hindiMoviesData['upcomingHindiMovies']!),
          ),
          SliverToBoxAdapter(
            child: HindiHorrorMovies(hindiHorrorMovies: hindiMoviesData['horrorHindiMovies']!),
          ),
          SliverToBoxAdapter(
            child: HindiThrillerMovies(hindiThrillerMovies: hindiMoviesData['thrillerHindiMovies']!),
          ),
          SliverToBoxAdapter(
            child: HindiAdventureMovies(hindiAdventureMovies: hindiMoviesData['adventureHindiMovies']!),
          ),
          SliverToBoxAdapter(
            child: HindiAnimationMovies(hindiAnimationMovies: hindiMoviesData['animationHindiMovies']!),
          ),
          SliverToBoxAdapter(
            child: HindiComedyMovies(hindiComedyMovies: hindiMoviesData['comedyHindiMovies']!),
          ),
          SliverToBoxAdapter(
            child: HindiRomanceMovies(hindiRomanceMovies: hindiMoviesData['romanceHindiMovies']!),
          ),
          SliverToBoxAdapter(
            child: HindiScienceFictionMovies(hindiSciFiMovies: hindiMoviesData['sciFiHindiMovies']!),
          ),
          SliverToBoxAdapter(
            child: HindiDocumentaryMovies(hindiDocumentaryMovies: hindiMoviesData['documentaryHindiMovies']!),
          ),
          SliverToBoxAdapter(
            child: HindiHistoryMovies(hindiHistoryMovies: hindiMoviesData['historyHindiMovies']!),
          ),
          SliverToBoxAdapter(
            child: HindiWesternMovies(hindiWesternMovies: hindiMoviesData['westernHindiMovies']!),
          ),
          SliverToBoxAdapter(
            child: HindiMysteryMovies(hindiMysteryMovies: hindiMoviesData['mysteryHindiMovies']!,),
          ),
          SliverToBoxAdapter(
            child: HindiDramaMovies(hindiDramaMovies: hindiMoviesData['dramaHindiMovies']!,),
          ),
          SliverToBoxAdapter(
            child: HindiFamilyMovies(hindiFamilyMovies: hindiMoviesData['familyHindiMovies']!,),
          ),
          SliverToBoxAdapter(
            child: HindiMusicFilms(hindiMusicFilms: hindiMoviesData['musicHindiFilms']!,),
          ),
        ],
      ),
    );
  }
}

