import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/Course.dart';
import 'CourseStorage.dart';
import 'payment_success_screen.dart';
import 'payment_failure_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingDetailsScreen extends StatefulWidget {
  final String title;
  final String author;
  final double price;
  final double rating;
  final String courseId;
  final DateTime date;
  final TimeOfDay time;
  final String package;

  BookingDetailsScreen({
    required this.title,
    required this.author,
    required this.price,
    required this.rating,
    required this.courseId,
    required this.date,
    required this.time,
    required this.package,
  });

  @override
  _BookingDetailsScreenState createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  bool isTermsAccepted = false;
  bool isUserSignedIn = false;
  late Razorpay _razorpay;
  String userId = ''; // Variable to store userId
  String? email;

  @override
  void initState() {
    super.initState();
    _checkUserSignInStatus();
    _fetchUserId();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _fetchUserId() async {
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email') ?? '';
    userId = prefs.getString('userId') ?? ''; // Fetch userId from SharedPreferences
    print("User ID: $userId"); // Print userId to console
    setState(() {});
  }

  Future<void> _checkUserSignInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isUserSignedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {});
  }

  Future<void> _scheduleInterview() async {
    final url = Uri.parse('http://192.168.1.13:8000/api/v1/scheduleinterview');

    // Prepare the schedule data
    final scheduleData = {
      'email': email,
      'userId': userId,
      'selectedCourse': widget.title,
      'selectPackage': widget.package,
      'selectDate': widget.date.toIso8601String(),
      'selectTime': widget.time.format(context),
    };

    // Print the data being sent to the API
    print('Sending data to API: $scheduleData');

    try {
      // Make the HTTP POST request
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(scheduleData),
      );

      // Print the raw response from the API
      print('API Response Code: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Successfully scheduled
        print('Interview scheduled successfully!');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Interview scheduled successfully!')),
        );
      } else {
        // API returned an error
        print('Interview scheduled successfully. Status Code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to schedule interview.')),
        );
      }
    } catch (e) {
      // Handle exceptions (e.g., network issues)
      print('Error while scheduling interview: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }


  void _startPayment() {
    if (!isUserSignedIn) {
      _showSignInPopup();
      return;
    }

    if (!isTermsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms and conditions.')),
      );
      return;
    }

    var options = {
      'key': 'rzp_test_V76Xg5COnOTCIM', // Replace with your Razorpay API key
      'amount': (widget.price * 100).toInt(), // Amount in paise
      'name': 'Course Payment',
      'description': 'Payment for the selected course',
      'prefill': {
        'contact': '7558412003', // Replace with dynamic user contact
        'email': 'adityajaitmal123@gmail.com', // Replace with dynamic user email
      },
      'theme': {
        'color': '#F37272',
      },
      'method': 'upi', // Specify payment method if needed
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void _showSignInPopup() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          color: Colors.white, // Set the background color to white
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sign In Required',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'You need to sign in to complete your purchase. Please sign in to proceed.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _navigateToLoginScreen();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToLoginScreen() {
    Navigator.pushNamed(context, '/login');
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Create a new course with 'success' payment status
    final course = Course(
      title: widget.title,
      author: widget.author,
      price: widget.price,
      rating: widget.rating,
      date: widget.date,
      time: widget.time,
      paymentStatus: 'success',
      paymentId: response.paymentId ?? 'N/A',
    );

    // Store the course
    await CourseStorage.addCourse(course);

    await _scheduleInterview();


    // Navigate to PaymentSuccessScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessScreen(
          paymentId: response.paymentId ?? 'N/A',
          courseTitle: widget.title,
          price: widget.price,
        ),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    // Create a course entry with 'failed' status
    final course = Course(
      title: widget.title,
      author: widget.author,
      price: widget.price,
      rating: widget.rating,
      date: widget.date,
      time: widget.time,
      paymentStatus: 'failed',
      paymentId: 'N/A',
    );

    // Store the course
    await CourseStorage.addCourse(course);

    await _scheduleInterview();


    // Navigate to PaymentFailureScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentFailureScreen(
          errorMessage: response.message ?? 'Unknown error',
        ),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet Selected: ${response.walletName}")),
    );
  }

  // Show the Terms of Service dialog with a white background, custom button, and responsive design
  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white, // White background color for the dialog
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title of Terms of Service
                Text(
                  'Terms of Service for ${widget.title}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 16),
                // Terms Content
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Here are the terms and conditions for enrolling in this course. Please read them carefully.',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '1. The course is available for a limited time only.',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        '2. No refunds will be issued once the course is accessed.',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        '3. You must complete the course within the given period.',
                        style: TextStyle(fontSize: 14),
                      ),
                      // Add more terms here as needed
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Close'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isTermsAccepted = true;
                        });
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: const Text(
                        'Accept',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Booking Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: screenSize.width > 600 ? 500 : double.infinity,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '🎉 Booking Confirmed!',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildDetailText('📚 Course Title:', widget.title),
                            _buildDetailText('✍️ Author:', widget.author),
                            _buildDetailText('💸 Price:', '₹${widget.price.toStringAsFixed(2)}'),
                            _buildDetailText('⭐ Rating:', widget.rating.toStringAsFixed(1)),
                            const Divider(height: 20, thickness: 1),
                            _buildDetailText('📅 Date:', widget.date.toLocal().toString().split(' ')[0]),
                            _buildDetailText('⏰ Time:', widget.time.format(context)),
                            const Divider(height: 20, thickness: 1),
                            _buildDetailText('👤 User ID:', userId),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Terms and Conditions Text with Background and Border
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      border: Border.all(color: Colors.grey), // Border color
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: isTermsAccepted,
                          onChanged: (bool? value) {
                            setState(() {
                              isTermsAccepted = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: _showTermsOfService,
                            child: const Text.rich(
                              TextSpan(
                                text: 'By completing your purchase, you agree to ',
                                style: TextStyle(fontSize: 12, color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _scheduleInterview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isUserSignedIn ? Colors.deepPurple : Colors.grey,
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: Text(
                      isUserSignedIn ? 'Pay Now' : 'Sign In to Checkout',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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

  Widget _buildDetailText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          children: [
            TextSpan(
              text: ' $value',
              style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
