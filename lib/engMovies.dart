import 'package:cineflix/widgets/movies/action.dart';
import 'package:cineflix/widgets/movies/adventureMovies.dart';
import 'package:cineflix/widgets/movies/animationMovies.dart';
import 'package:cineflix/widgets/movies/comedyMovies.dart';
import 'package:cineflix/widgets/movies/documentaryMovies.dart';
import 'package:cineflix/widgets/movies/dramaMovies.dart';
import 'package:cineflix/widgets/movies/familyMovies.dart';
import 'package:cineflix/widgets/movies/historyMovies.dart';
import 'package:cineflix/widgets/movies/horrorMovies.dart';
import 'package:cineflix/widgets/movies/musicFilms.dart';
import 'package:cineflix/widgets/movies/mysteryMovies.dart';
import 'package:cineflix/widgets/movies/popular.dart';
import 'package:cineflix/widgets/movies/romanceMovies.dart';
import 'package:cineflix/widgets/movies/scienceFictionMovies.dart';
import 'package:cineflix/widgets/movies/thriller.dart';
import 'package:cineflix/widgets/movies/topRated.dart';
import 'package:cineflix/widgets/movies/trendingMovies.dart';
import 'package:cineflix/widgets/movies/upcomingMovies.dart';
import 'package:cineflix/widgets/movies/westernMovies.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';

class EngMovies extends StatefulWidget {
  const EngMovies({super.key});

  @override
  State<EngMovies> createState() => _EngMoviesState();
}

class _EngMoviesState extends State<EngMovies> {
  List trendingMovies = [];
  List topRatedMovies = [];
  List popular = [];
  List upcomingMovies = [];
  List horrorMovies = [];
  List thrillerMovies = [];
  List actionMovies = [];
  List adventureMovies = [];
  List animationMovies = [];
  List comedyMovies = [];
  List romanceMovies = [];
  List sciFiMovies = [];
  List documentaryMovies = [];
  List historyMovies = [];
  List mysteryMovies = [];
  List westernMovies = [];
  List dramaMovies = [];
  List familyMovies = [];
  List musicFilms = [];

  final String apiKey = 'caab8223e29b6c77c16940d6e2ccfa5e';
  final String readAccessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjYWFiODIyM2UyOWI2Yzc3YzE2OTQwZDZlMmNjZmE1ZSIsIm5iZiI6MTczMjgwMDM1Mi43OTc0NTIyLCJzdWIiOiI2NzQ4NmQ2MjJlZDM5YTNhZjE3MWUxYjgiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.14l3iY-IjTx0kJwnE17stnAvxo58nsENZD1-kIoWY7I';

  late TMDB tmdbWithCustomLogs;

  @override
  void initState() {
    super.initState();
    tmdbWithCustomLogs = TMDB(ApiKeys(apiKey, readAccessToken), logConfig: ConfigLogger(showErrorLogs: true, showLogs: true));
    loadMovies();
  }

  Future<void> loadMovies() async {
    try {
      Map<String, dynamic> trendingResults = await tmdbWithCustomLogs.v3.trending.getTrending(language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> topRatedMovieResult = await tmdbWithCustomLogs.v3.movies.getTopRated(language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> popularResult = await tmdbWithCustomLogs.v3.movies.getPopular(language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> upcomingMoviesResult = await tmdbWithCustomLogs.v3.movies.getUpcoming(language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> horrorMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '27', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> thrillerMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '53', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> actionMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '28', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> adventureMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '12', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> animationMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '16', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> comedyMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '35', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> romanceMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '10749', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> scienceFictionMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '878', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> documentaryMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '99', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> historyMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '36', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> mysteryMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '9648', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> westernMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '37', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> dramaMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '18', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> familyMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '10751', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> musicFilmsResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '10402', language: 'en-US') as Map<String, dynamic>;

      setState(() {
        trendingMovies = trendingResults['results'];
        topRatedMovies = topRatedMovieResult['results'];
        popular = popularResult['results'];
        upcomingMovies = upcomingMoviesResult['results'];
        horrorMovies = horrorMoviesResult['results'];
        thrillerMovies = thrillerMoviesResult['results'];
        actionMovies = actionMoviesResult['results'];
        adventureMovies = adventureMoviesResult['results'];
        animationMovies = animationMoviesResult['results'];
        comedyMovies = comedyMoviesResult['results'];
        romanceMovies = romanceMoviesResult['results'];
        sciFiMovies = scienceFictionMoviesResult['results'];
        documentaryMovies = documentaryMoviesResult['results'];
        historyMovies = historyMoviesResult['results'];
        mysteryMovies = mysteryMoviesResult['results'];
        westernMovies = westernMoviesResult['results'];
        dramaMovies = dramaMoviesResult['results'];
        familyMovies = familyMoviesResult['results'];
        musicFilms = musicFilmsResult['results'];
      });
    } catch (e) {
      print("Error loading movies: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    final fontSize = width * 0.05;

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          SizedBox(height: height * 0.01),

          TrendingMovies(trending: trendingMovies,),
          Toprated(topRated: topRatedMovies,),
          Popular(popular: popular,),
          UpcomingMovies(upcomingMovies: upcomingMovies,),
          HorrorMovies(horrorMovies: horrorMovies,),
          ThrillerMovies(thrillerMovies: thrillerMovies,),
          ActionMovies(actionMovies: actionMovies,),
          AdventureMovies(adventureMovies: adventureMovies),
          AnimationMovies(animationMovies: animationMovies,),
          ComedyMovies(comedyMovies: comedyMovies,),
          RomanceMovies(romanceMovies: romanceMovies,),
          ScienceFictionMovies(sciFiMovies: sciFiMovies,),
          DocumentaryMovies(documentaryMovies: documentaryMovies,),
          HistoryMovies(historyMovies: historyMovies,),
          WesternMovies(westernMovies: westernMovies,),
          MysteryMovies(mysteryMovies: mysteryMovies,),
          DramaMovies(dramaMovies: dramaMovies,),
          FamilyMovies(familyMovies: familyMovies,),
          MusicFilms(musicFilms: musicFilms,),
        ],
      ),
    );
  }
}
