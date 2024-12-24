import 'package:cineflix/provider/historyProvider.dart';
import 'package:cineflix/provider/themeProvider.dart';
import 'package:cineflix/tabs.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;


class BookedHistory extends StatefulWidget {
  const BookedHistory({super.key});

  @override
  State<BookedHistory> createState() => _BookedHistoryState();
}

class _BookedHistoryState extends State<BookedHistory> {

  Color getRandomBrightColor() {
    math.Random random = math.Random();
    return Color.fromARGB(
      255,
      random.nextInt(156) + 100,
      random.nextInt(156) + 100,
      random.nextInt(156) + 100,
    );
  }

  Color getRandomDarkColor() {
    math.Random random = math.Random();
    return Color.fromARGB(
      255,
      random.nextInt(100),
      random.nextInt(100),
      random.nextInt(100),
    );
  }


  @override
  void initState() {
    super.initState();
    context.read<HistoryProvider>().getInitialHistory();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final padding = width * 0.05;
    final fontSize = width * 0.05;

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.getTheme()
            ? Colors.black
            : Colors.white,
        title: Text("Booking History",
          style: GoogleFonts.afacad(
            color: Colors.red[700],
            fontSize: fontSize * 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            color: Colors.red[700],
            onPressed: (){
              Navigator.push(
                context, MaterialPageRoute(
                  builder: (context) => Tabs(),
                ),
              );
            },
            icon: Icon(Icons.home,),
          ),
        ],
      ),
      backgroundColor: themeProvider.getTheme()
          ? Colors.black
          : Colors.white,
      body: Consumer<HistoryProvider>(
        builder: (ctx, historyProvider, __) {
          var allData = historyProvider.getData();
          print("Booking history: $allData");
          return allData.isNotEmpty
              ? Container(
            margin: EdgeInsets.all(padding * 0.2),
            child: ListView.builder(
              itemCount: allData.length,
              itemBuilder: (context, index) {
                var item = allData[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: padding * 0.1),
                  child: GestureDetector(
                    onTap: () {
                    },
                    child: Card(
                      elevation: 5,
                      color: Colors.white10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: padding * 0.5,
                          vertical: padding * 0.3,
                        ),
                        title: Text(
                          item['title'] ?? 'Unknown',
                          style: GoogleFonts.afacad(
                            fontSize: fontSize * 1.3,
                            color: themeProvider.getTheme() ? getRandomBrightColor() : getRandomDarkColor(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date: ${item['date'] ?? 'N/A'}",
                              style: TextStyle(
                                color: themeProvider.getTheme() ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              "Time: ${item['time'] ?? 'N/A'}",
                              style: TextStyle(
                                color: themeProvider.getTheme() ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        trailing: Column(
                          children: [
                            Text(
                              "₹${item['cost'] ?? '0'}",
                              style: TextStyle(
                                fontSize: fontSize * 0.9,
                                color: item['status'] == 'Success'
                                    ? (themeProvider.getTheme() ? Colors.green : Colors.green[800])
                                    : Colors.red[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "${item['status'] ?? 'N/A'}",
                              style: TextStyle(
                                fontSize: fontSize * 0.9,
                                color: item['status'] == 'Success'
                                    ? (themeProvider.getTheme() ? Colors.green : Colors.green[800])
                                    : Colors.red[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "No shows booked yet...!!!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
