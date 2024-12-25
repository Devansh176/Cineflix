import 'package:cineflix/engMovies.dart';
import 'package:cineflix/engSeries.dart';
import 'package:cineflix/provider/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homepage1 extends StatelessWidget {
  const Homepage1({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;

    final themeProvider = Provider.of<ThemeProvider>(context);

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: width * 0.53,
              color: themeProvider.getTheme()
                  ? Colors.black
                  : Colors.white,
              child: TabBar(
              dividerColor: themeProvider.getTheme() ? Colors.red : Colors.red[900],
              labelColor: themeProvider.getTheme() ? Colors.redAccent : Colors.redAccent[700],
              indicatorColor: themeProvider.getTheme() ? Colors.redAccent : Colors.redAccent[700],
              indicatorWeight: 3,
              unselectedLabelColor: themeProvider.getTheme() ? Colors.red : Colors.red[900],
                tabs: const [
                  Tab(text: 'Movies'),
                  Tab(text: 'Series'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                EngMovies(),
                EngSeries(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
