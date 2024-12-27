import 'dart:convert';
import 'dart:math';

import 'package:cineflix/booked/history.dart';
import 'package:cineflix/provider/historyProvider.dart';
import 'package:cineflix/provider/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

class Description extends StatefulWidget {
  final String name, description, bannerUrl, posterUrl, vote, launch_on;
  const Description({
    super.key,
    required this.name,
    required this.description,
    required this.bannerUrl,
    required this.posterUrl,
    required this.vote,
    required this.launch_on,
  });

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> with WidgetsBindingObserver{
  late Razorpay _razorpay;
  late ScrollController _scrollController;
  String customerEmail = '';
  String customerContact = '';
  bool showFields = false;
  final _formKey = GlobalKey<FormState>();
  String? youtubeVideoKey;
  YoutubePlayerController? _youtubePlayerController;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _scrollController = ScrollController();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    WidgetsBinding.instance.addObserver(this);
    fetchTeaserVideo();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _youtubePlayerController?.pause();
    }
  }

  @override
  void deactivate() {
    if (_youtubePlayerController != null) {
      print('Forcing video to pause');
      _youtubePlayerController?.pause();
    }
    super.deactivate();
  }

  final ytKey = "AIzaSyAiwCCHVjHQONJdV8nR1GX8huxcFdO0nfc";

  Future<void> fetchTeaserVideo() async {
    final url =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=${widget.name} movie trailer&type=video&key=$ytKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['items'].isNotEmpty) {
          setState(() {
            youtubeVideoKey = data['items'][0]['id']['videoId'];
            _youtubePlayerController = YoutubePlayerController(
              initialVideoId: youtubeVideoKey!,
              flags: const YoutubePlayerFlags(
                autoPlay: false,
                mute: false,
                forceHD: true,
                loop: true,
              ),
            );
          });
        } else {
          throw Exception('No video found');
        }
      } else {
        throw Exception('Failed to load YouTube video');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load video: $error')),
      );
    }
  }



  int? _randomAmount;
  Future<void> _startPayment(String email, String contact) async {
    _youtubePlayerController?.pause();

    _randomAmount = (Random().nextInt(21) + 10) * 10;
    var options = {
      'key': 'rzp_test_OWIoYondzA2igG',
      'amount': _randomAmount! * 97,
      'currency': 'INR',
      'name': 'Cineflix',
      'description': 'Movie Ticket Booking',
      'prefill': {
        'email': email,
        'contact': contact,
      },
      'theme': {
        'color': '#3399cc'
      },
      'external' : {
        'wallets' : ['paytm']
      },
    };
    _razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
      historyProvider.addData(
        title: widget.name,
        cost: _randomAmount.toString(),
        date: DateTime.now().toLocal().toString().split(' ')[0],
        time: DateTime.now().toLocal().toString().split(' ')[1],
        status: "Success",
      );
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Payment Successful"),
        content: Text(
          "Payment ID: ${response.paymentId}\nOrder ID: ${response.orderId}",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BookedHistory(),
              ),
            ),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    WidgetsBinding.instance.addPostFrameCallback((_){
      final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
      historyProvider.addData(
        title: widget.name,
        cost: _randomAmount.toString(),
        date: DateTime.now().toLocal().toString().split(' ')[0],
        time: DateTime.now().toLocal().toString().split(' ')[1],
        status: "Failed",
      );
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Payment Failed"),
        content: Text(
          "Reason: ${response.message ?? "Unknown error"}\nCode: ${response.code}",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BookedHistory(),
              ),
            ),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 50,),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _youtubePlayerController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _razorpay.clear();
    _scrollController.dispose();
    _youtubePlayerController?.dispose();
    super.dispose();
  }

  final String? Function(String?) _validateContactNumber = (String? value) {
    if (value == null || value.length != 10) {
      return 'Contact number must be 10 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Only digits are allowed';
    }
    return null;
  };

  final String? Function(String?) _validateEmail = (String? value) {
    if(value == null || !value.contains('@gmail.com') || value.isEmpty){
      return 'Please enter a valid email address';
    }
    if(value != value.toLowerCase()) {
      return 'Email must be in lowercase';
    }
    return null;
  };

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    final width = screenSize.width;
    final height = screenSize.height;
    final fontSize = width * 0.05;
    final padding = width * 0.05;

    final themeProvider = Provider.of<ThemeProvider>(context);

    String getValidImageUrl(String? url) {
      return (url != null && url.isNotEmpty)
          ? url
          : 'https://via.placeholder.com/300';
    }
    return Scaffold(
      backgroundColor: themeProvider.getTheme()
          ? Colors.black
          : Colors.white,
      body: ListView(
        controller: _scrollController,
        children: <Widget>[
          SizedBox(
            height: height * 0.35,
            child: youtubeVideoKey != null && _youtubePlayerController != null ?
              YoutubePlayer(
                controller: _youtubePlayerController!,
              ) :
              Image.network(
                getValidImageUrl(widget.bannerUrl.isNotEmpty ? widget.bannerUrl : widget.posterUrl),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: height * 0.15,
                    ),
                  );
                },
              ),
          ),
          SizedBox(height: height * 0.005,),
          Center(
            child: Text(
              widget.name,
              style: GoogleFonts.afacad(
                fontSize: fontSize * 1.7,
                fontWeight: FontWeight.w800,
                color: themeProvider.getTheme() ? Colors.redAccent : Colors.red[900],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: height * 0.02,),
          Padding(
            padding: EdgeInsets.only(left: padding * 0.7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '⭐ Rating : ${widget.vote}',
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize * 0.9,
                    color: themeProvider.getTheme() ? Colors.redAccent : Colors.red[900],
                  ),
                ),
                Text(
                  'Release date : ${widget.launch_on.isNotEmpty ? widget.launch_on : "First Air Date: N/A"}',
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize * 0.9,
                    color: themeProvider.getTheme() ? Colors.redAccent : Colors.red[900],
                  ),
                ),
                SizedBox(height: height * 0.01),
                Container(
                  height: height * 0.27,
                  width: width * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        getValidImageUrl(widget.posterUrl.isNotEmpty
                            ? widget.posterUrl
                            : widget.bannerUrl),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Padding(
                  padding: EdgeInsets.all(padding * 0.6),
                  child: Text(
                    widget.description,
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w600,
                      fontSize: fontSize * 0.9,
                      color: themeProvider.getTheme() ? Colors.redAccent : Colors.red[900],
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.03),
          if(!showFields)
            Center(
              child: SizedBox(
                width: width * 0.4,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showFields = true;
                    });
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeProvider.getTheme() ? Colors.black : Colors.white,
                    textStyle: TextStyle(
                      fontSize: fontSize * 0.9,
                      fontWeight: FontWeight.bold,
                    ),
                    side: BorderSide(
                      color: themeProvider.getTheme() ? Colors.redAccent : (Colors.red[900] ?? Colors.red),
                    ),
                  ),
                  child: Text(
                    "Book Now",
                    style: GoogleFonts.afacad(
                      color: themeProvider.getTheme() ? Colors.redAccent : Colors.red[900],
                    ),
                  ),
                ),
              ),
            ),
          if(showFields)
            Padding(
              padding: EdgeInsets.all(width * 0.05,),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      style: GoogleFonts.afacad(
                        color: themeProvider.getTheme() ? Colors.red : Colors.red[900],
                        fontSize: fontSize,
                      ),
                      cursorColor: Colors.red,
                      onChanged: (value) => customerEmail = value,
                      validator: _validateEmail,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: GoogleFonts.afacad(
                          color: Colors.red[900],
                        ),
                        hintText: "Enter your email",
                        hintStyle: GoogleFonts.afacad(
                          color: Colors.red[900],
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        fillColor: themeProvider.getTheme() ? Colors.black : Colors.white,
                        filled: true,
                      ),
                    ),
                    SizedBox(height: height * 0.02),

                    TextFormField(
                      style: GoogleFonts.afacad(
                        color: themeProvider.getTheme() ? Colors.red : Colors.red[900],
                        fontSize: fontSize,
                      ),
                      cursorColor: Colors.red,
                      onChanged: (value) => customerContact = value,
                      validator: _validateContactNumber,
                      decoration: InputDecoration(
                        labelText: "Contact Number",
                        labelStyle: GoogleFonts.afacad(
                          color: Colors.red[900],
                        ),
                        hintText: "Enter your contact number",
                        hintStyle: GoogleFonts.afacad(
                          color: Colors.red[900],
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        fillColor: themeProvider.getTheme() ? Colors.black : Colors.white,
                        filled: true,
                      ),
                      keyboardType: TextInputType.phone,
                    ),

                    SizedBox(height: height * 0.02),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (customerEmail.isNotEmpty && customerContact.isNotEmpty) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _youtubePlayerController?.pause();
                            });
                            _startPayment(customerEmail, customerContact);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Please fill all the details")),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please fill all fields correctly")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeProvider.getTheme() ? Colors.red[700] : Colors.red[900],
                        textStyle: TextStyle(
                          fontSize: fontSize * 0.85,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Text(
                        "Proceed to Pay",
                        style: GoogleFonts.afacad(
                          color: themeProvider.getTheme() ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}