import 'package:cineflix/widgets/series/action.dart';
import 'package:cineflix/widgets/series/animation.dart';
import 'package:cineflix/widgets/series/comedy.dart';
import 'package:cineflix/widgets/series/documentary.dart';
import 'package:cineflix/widgets/series/drama.dart';
import 'package:cineflix/widgets/series/family.dart';
import 'package:cineflix/widgets/series/mystery.dart';
import 'package:cineflix/widgets/series/reality.dart';
import 'package:cineflix/widgets/series/romance.dart';
import 'package:cineflix/widgets/series/talk.dart';
import 'package:cineflix/widgets/series/topRatedSeries.dart';
import 'package:cineflix/widgets/series/tv.dart';
import 'package:cineflix/widgets/series/western.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';

class EngSeries extends StatefulWidget {
  const EngSeries({super.key});

  @override
  State<EngSeries> createState() => _EngSeriesState();
}

class _EngSeriesState extends State<EngSeries> {

  List tvShows = [];
  List topRatedSeries = [];
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
      Map<String, dynamic> tvShowsResult = await tmdbWithCustomLogs.v3.tv.getPopular(language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> topRatedSeriesResult = await tmdbWithCustomLogs.v3.tv.getTopRated(language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> actionSeriesResult = await tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '10759', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> animationSeriesResult = await tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '16', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> comedySeriesResult = await tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '18', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> romanceSeriesResult = await tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '10749', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> docSeriesResult = await tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '99', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> mysterySeriesResult = await tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '9648', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> westernSeriesResult = await tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '37', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> dramaSeriesResult = await tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '18', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> familyShowResult = await tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '10751', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> talkSeriesResult = await tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '10767', language: 'en-US') as Map<String, dynamic>;
      Map<String, dynamic> realityShowResult = await tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '10764', language: 'en-US') as Map<String, dynamic>;

      setState(() {
        tvShows = tvShowsResult['results'];
        topRatedSeries = topRatedSeriesResult['results'];
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
      body: ListView(
        children: [
          SizedBox(height: height * 0.01),

          TvShows(tv: tvShows,),
          TopRatedSeries(topRatedSeries: topRatedSeries,),
          ActionSeries(actionSeries: actionSeries,),
          AnimationSeries(animationSeries: animationSeries,),
          Comedy(comedySeries: comedySeries,),
          RomanceSeries(romanceSeries: romanceSeries,),
          DocSeries(documentarySeries: documentarySeries,),
          WesternSeries(westernSeries: westernSeries,),
          MysterySeries(mysterySeries: mysterySeries,),
          Drama(dramaSeries: dramaSeries,),
          FamilySeries(familyShow: familyShow,),
          Talk(talkSeries: talk,),
          Reality(realityShow: realityShow,),
        ],
      ),
    );
  }
}
