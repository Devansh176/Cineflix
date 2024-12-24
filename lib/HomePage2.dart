import 'package:cineflix/hindiMovies.dart';
import 'package:cineflix/hindiSeries.dart';
import 'package:cineflix/provider/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homepage2 extends StatefulWidget {
  const Homepage2({super.key});

  @override
  State<Homepage2> createState() => _Homepage2State();
}

class _Homepage2State extends State<Homepage2> {

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
            alignment: Alignment.centerRight,
            child: Container(
              width: width * 0.53,
              color: Colors.black,
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
                HindiMovies(),
                HindiSeries(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
