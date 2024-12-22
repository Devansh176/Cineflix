import 'package:cineflix/HomePage1.dart';
import 'package:cineflix/HomePage2.dart';
import 'package:cineflix/history.dart';
import 'package:cineflix/provider/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final fontSize = width * 0.05;

    final themeProvider = Provider.of<ThemeProvider>(context);

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.more_time_rounded,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookedHistory(),
                ),
              );
            },
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            'Cineflex',
            style: GoogleFonts.aboreto(
              color: Colors.purpleAccent,
              fontSize: fontSize * 2.2,
              fontWeight: FontWeight.w900,
            ),
          ),
          actions: [
            Consumer<ThemeProvider>(
              builder: (ctx, provider, __){
                return IconButton(
                  onPressed: () {
                    provider.updateTheme(
                      value: !themeProvider.getTheme(),
                    );
                  },
                  icon: Icon(
                    themeProvider.getTheme() ? Icons.nightlight_outlined : Icons.sunny,
                  ),
                );
              }),
          ],
          bottom: TabBar(
            dividerColor: Colors.purple,
            labelColor: Colors.purpleAccent,
            indicatorColor: Colors.purpleAccent,
            indicatorWeight: 5,
            tabAlignment: TabAlignment.fill,
            unselectedLabelColor: Colors.purple,
            tabs: const [
              Tab(text: 'English',),
              Tab(text: 'Hindi',),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Homepage1(),
            Homepage2(),
          ],
        ),
      ),
    );
  }
}
