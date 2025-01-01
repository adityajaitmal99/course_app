import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to Our Online Course App!',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Please read the following terms and conditions carefully before using the app. By using this app, you agree to be bound by these terms and conditions.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 20.0),
              Text(
                '1. Acceptance of Terms',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'By accessing and using our app, you accept and agree to be bound by the terms and conditions of this agreement. In addition, when using these particular services, you shall be subject to any posted guidelines or rules applicable to such services.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 20.0),
              Text(
                '2. Changes to Terms',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'We reserve the right to change these terms and conditions at any time. Any changes will be posted on this page, and your continued use of the app will signify your acceptance of any adjusted terms.',
                style: TextStyle(fontSize: 16.0),
              ),
              // Add more sections as needed
              SizedBox(height: 20.0),
              Text(
                '3. User Responsibilities',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'As a user, you agree to use the app responsibly and not engage in any activity that would disrupt or harm other users or the platform itself. This includes but is not limited to spamming, hacking, or using the app for illegal activities.',
                style: TextStyle(fontSize: 16.0),
              ),
              // More terms and conditions can be added here
              SizedBox(height: 30.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Implement the logic for agreeing to terms
                    Navigator.pop(context);
                  },
                  child: Text('Accept and Continue'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                    backgroundColor: Colors.blueAccent,
                    textStyle: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}
