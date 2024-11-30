import 'package:cineflix/widgets/englishMovies/action.dart';
import 'package:cineflix/widgets/englishMovies/adventureMovies.dart';
import 'package:cineflix/widgets/englishMovies/animationMovies.dart';
import 'package:cineflix/widgets/englishMovies/comedyMovies.dart';
import 'package:cineflix/widgets/englishMovies/documentaryMovies.dart';
import 'package:cineflix/widgets/englishMovies/dramaMovies.dart';
import 'package:cineflix/widgets/englishMovies/familyMovies.dart';
import 'package:cineflix/widgets/englishMovies/historyMovies.dart';
import 'package:cineflix/widgets/englishMovies/horrorMovies.dart';
import 'package:cineflix/widgets/englishMovies/musicFilms.dart';
import 'package:cineflix/widgets/englishMovies/mysteryMovies.dart';
import 'package:cineflix/widgets/englishMovies/popular.dart';
import 'package:cineflix/widgets/englishMovies/romanceMovies.dart';
import 'package:cineflix/widgets/englishMovies/scienceFictionMovies.dart';
import 'package:cineflix/widgets/englishMovies/thriller.dart';
import 'package:cineflix/widgets/englishMovies/topRated.dart';
import 'package:cineflix/widgets/englishMovies/trendingMovies.dart';
import 'package:cineflix/widgets/englishMovies/upcomingMovies.dart';
import 'package:cineflix/widgets/englishMovies/westernMovies.dart';
import 'package:cineflix/widgets/englishSeries/action.dart';
import 'package:cineflix/widgets/englishSeries/animation.dart';
import 'package:cineflix/widgets/englishSeries/comedy.dart';
import 'package:cineflix/widgets/englishSeries/family.dart';
import 'package:cineflix/widgets/englishSeries/mystery.dart';
import 'package:cineflix/widgets/englishSeries/reality.dart';
import 'package:cineflix/widgets/englishSeries/romance.dart';
import 'package:cineflix/widgets/englishSeries/documentary.dart';
import 'package:cineflix/widgets/englishSeries/talk.dart';
import 'package:cineflix/widgets/englishSeries/topRatedSeries.dart';
import 'package:cineflix/widgets/englishSeries/tv.dart';
import 'package:cineflix/widgets/englishSeries/drama.dart';
import 'package:cineflix/widgets/englishSeries/western.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tmdb_api/tmdb_api.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List trendingMovies = [];
  List topRatedMovies = [];
  List tvShows = [];
  List popular = [];
  List topRatedSeries = [];
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
  List dramaSeries = [];
  List comedySeries = [];
  List talk = [];
  List actionSeries = [];
  List animationSeries = [];
  List romanceSeries = [];
  List documentarySeries = [];
  List westernSeries = [];
  List mysterySeries = [];
  List realityShow = [];
  List familyShow = [];

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
      Map<String, dynamic> tvShowsResult = await tmdbWithCustomLogs.v3.tv.getPopular(language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> popularResult = await tmdbWithCustomLogs.v3.movies.getPopular(language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> topRatedSeriesResult = await tmdbWithCustomLogs.v3.tv.getTopRated(language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> upcomingMoviesResult = await tmdbWithCustomLogs.v3.movies.getUpcoming(language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> horrorMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '27', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> thrillerMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '53', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> actionMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '28', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> actionSeriesResult = await tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '10759', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> adventureMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '12', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> animationMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '16', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> animationSeriesResult = await tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '16', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> comedyMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '35', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> comedySeriesResult = await tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '18', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> romanceMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '10749', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> romanceSeriesResult = await tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '10749', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> scienceFictionMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '878', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> documentaryMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '99', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> docSeriesResult = await tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '99', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> historyMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '36', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> mysteryMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '9648', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> mysterySeriesResult = await tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '9648', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> westernMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '37', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> westernSeriesResult = await tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '37', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> dramaMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '18', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> dramaSeriesResult = await tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '18', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> familyMoviesResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '10751', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> familyShowResult = await tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '10751', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> musicFilmsResult = await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: '10402', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> talkSeriesResult = await tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '10767', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> realityShowResult = await tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '10764', language: 'en-US') as Map<String, dynamic>;

      setState(() {
        trendingMovies = trendingResults['results'];
        topRatedMovies = topRatedMovieResult['results'];
        tvShows = tvShowsResult['results'];
        popular = popularResult['results'];
        topRatedSeries = topRatedSeriesResult['results'];
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
        dramaSeries = dramaSeriesResult['results'];
        comedySeries = comedySeriesResult['results'];
        talk = talkSeriesResult['results'];
        actionSeries = actionSeriesResult['results'];
        animationSeries = animationSeriesResult['results'];
        romanceSeries = romanceSeriesResult['results'];
        documentarySeries = docSeriesResult['results'];
        westernSeries = westernSeriesResult['results'];
        mysterySeries = mysterySeriesResult['results'];
        realityShow = realityShowResult['results'];
        familyShow = familyShowResult['results'];
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
      appBar: AppBar(
        title: Text(
          'Cineflix',
          style: GoogleFonts.aboreto(
            color: Colors.purple,
            fontSize: fontSize * 2.2,
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SizedBox(height: height * 0.01),

          TrendingMovies(trending: trendingMovies,),
          TvShows(tv: tvShows,),
          Toprated(topRated: topRatedMovies,),
          TopRatedSeries(topRatedSeries: topRatedSeries,),
          Popular(popular: popular,),
          UpcomingMovies(upcomingMovies: upcomingMovies,),
          HorrorMovies(horrorMovies: horrorMovies,),
          ThrillerMovies(thrillerMovies: thrillerMovies,),
          ActionMovies(actionMovies: actionMovies,),
          ActionSeries(actionSeries: actionSeries,),
          AdventureMovies(adventureMovies: adventureMovies),
          AnimationMovies(animationMovies: animationMovies,),
          AnimationSeries(animationSeries: animationSeries,),
          ComedyMovies(comedyMovies: comedyMovies,),
          Comedy(comedySeries: comedySeries,),
          RomanceMovies(romanceMovies: romanceMovies,),
          RomanceSeries(romanceSeries: romanceSeries,),
          ScienceFictionMovies(sciFiMovies: sciFiMovies,),
          DocumentaryMovies(documentaryMovies: documentaryMovies,),
          DocSeries(documentarySeries: documentarySeries,),
          HistoryMovies(historyMovies: historyMovies,),
          WesternMovies(westernMovies: westernMovies,),
          WesternSeries(westernSeries: westernSeries,),
          MysteryMovies(mysteryMovies: mysteryMovies,),
          MysterySeries(mysterySeries: mysterySeries,),
          DramaMovies(dramaMovies: dramaMovies,),
          Drama(dramaSeries: dramaSeries,),
          FamilyMovies(familyMovies: familyMovies,),
          FamilySeries(familyShow: familyShow,),
          MusicFilms(musicFilms: musicFilms,),
          Talk(talkSeries: talk,),
          Reality(realityShow: realityShow,),
        ],
      ),
    );
  }
}
