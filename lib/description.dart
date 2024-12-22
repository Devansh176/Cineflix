import 'dart:math';

import 'package:cineflix/provider/historyProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

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

class _DescriptionState extends State<Description> {
  late Razorpay _razorpay;
  late ScrollController _scrollController;
  String customerEmail = '';
  String customerContact = '';
  bool showFields = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _scrollController = ScrollController();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  int? _randomAmount;

  Future<void> _startPayment(String email, String contact) async {
    _randomAmount = (Random().nextInt(21) + 10) * 10;

    var options = {
      'key': 'rzp_test_OWIoYondzA2igG',
      'amount': _randomAmount! * 100,
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
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
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
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
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
    super.dispose();
    _razorpay.clear();
    _scrollController.dispose();
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

    String getValidImageUrl(String? url) {
      return (url != null && url.isNotEmpty)
          ? url
          : 'https://via.placeholder.com/300';
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        controller: _scrollController,
        children: <Widget>[
          SizedBox(
            height: height * 0.3,
            child: Image.network(
              getValidImageUrl(
                  widget.bannerUrl.isNotEmpty ? widget.bannerUrl : widget
                      .posterUrl),
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
          SizedBox(height: height * 0.005),
          Center(
            child: Text(
              widget.name,
              style: GoogleFonts.ibarraRealNova(
                fontSize: fontSize * 1.7,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: height * 0.02),
          Padding(
            padding: EdgeInsets.only(left: padding * 0.7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '⭐ Rating : ${widget.vote}',
                  style: GoogleFonts.taiHeritagePro(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize * 0.9,
                  ),
                ),
                Text(
                  'Release date : ${widget.launch_on.isNotEmpty ? widget.launch_on : "First Air Date: N/A"}',
                  style: GoogleFonts.taiHeritagePro(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize * 0.9,
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
                      fontWeight: FontWeight.w500,
                      fontSize: fontSize * 0.9,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.03),
          Center(
            child: SizedBox(
              width: width * 0.5,
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
                  backgroundColor: Colors.transparent,
                  textStyle: TextStyle(
                    fontSize: fontSize * 0.9,
                    fontWeight: FontWeight.bold,
                  ),
                  side: BorderSide(
                    color: Colors.purple,
                  ),
                ),
                child: Text(
                  "Book Now",
                  style: TextStyle(
                    color: Colors.purple,
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
                      onChanged: (value) => customerEmail = value,
                      validator: _validateEmail,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Enter your email",
                        border: OutlineInputBorder(),
                        fillColor: Colors.black,
                        filled: true,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    TextFormField(
                      onChanged: (value) => customerContact = value,
                      validator: _validateContactNumber,
                      decoration: InputDecoration(
                        labelText: "Contact Number",
                        hintText: "Enter your contact number",
                        border: OutlineInputBorder(),
                        fillColor: Colors.black,
                        filled: true,
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: height * 0.02),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (customerEmail.isNotEmpty && customerContact.isNotEmpty) {
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
                      child: Text("Proceed to Pay"),
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