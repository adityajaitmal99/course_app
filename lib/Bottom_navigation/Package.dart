/*
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import for JSON encoding/decoding
import '../Common/Custome_button.dart';
import '../Courses/Courses.dart';
import '../Courses/Datetime_shedule.dart'; // Import course-related screens

class PackageScreen extends StatefulWidget {
  final String title;
  final String author;
  final double rating;
  final String courseId;

  const PackageScreen({
    super.key,
    required this.title,
    required this.author,
    required this.rating,
    required this.courseId,
  });

  @override
  _PackageScreenState createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  List<Package> packages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPackages();

    // Print the courseId to verify it's being passed
    print("Course ID passed to PackageScreen: ${widget.courseId}");
  }

  Future<void> fetchPackages() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.234.187:8000/api/v1/packages')); // Replace with your API URL
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.isNotEmpty) {
          setState(() {
            packages = jsonResponse.map((pkg) => Package.fromJson(pkg)).toList();
            isLoading = false; // Stop loading once data is fetched
          });
        } else {
          throw Exception('No packages found');
        }
      } else {
        // Handle error case
        throw Exception('Failed to load packages');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false; // Stop loading even if there's an error
      });
    }
  }

  void _navigateToScreen(String? courseId, double price) {
    if (courseId != '') {
      // If courseId is provided, navigate to InterviewBookingScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InterviewBookingScreen(
            price: price,
            title: widget.title,
            author: widget.author,
            rating: widget.rating,
            courseId: widget.courseId,

          ),
        ),
      );
    } else {
      // If courseId is not provided, show a popup to select a course
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white, // Set the background color of the dialog
            title: const Text(
              'Select a Course',
              style: TextStyle(color: Colors.black), // Set title text color to black
            ),
            content: const Text(
              'Please select a course to proceed with booking.',
              style: TextStyle(color: Colors.black), // Set content text color to black
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the popup
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.black, // Set Cancel button text color to black
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to the CourseCardScreen when Select Course is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Courses(), // Replace with your actual CourseCardScreen
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // Set background color of Select Course button
                ),
                child: const Text(
                  'Select Course',
                  style: TextStyle(
                    color: Colors.white, // Set Select Course button text color to white
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading spinner while fetching data
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 27),
          child: Column(
            children: packages.map((package) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: buildPackageCard(
                  context,
                  title: package.title,
                  price: package.price,
                  features: package.features,
                  courseId: widget.courseId, // Pass courseId here
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget buildPackageCard(
      BuildContext context, {
        required String title,
        required String price,
        required List<String> features,
        required String courseId, // Add courseId as a parameter
      }) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: screenWidth * 0.75,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 18.0),
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: features.map((feature) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        const Icon(Icons.check, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10), // Space before button
            CustomeButton(
              height: 45,
              width: 280,
              buttonColor: Colors.deepPurple,
              text: "Select Plan",
              textColor: Colors.white,
              textSize: 18,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              borderRadius: 0,
              onTap: () {
                // Convert price to double before passing
                double priceValue = double.tryParse(price) ?? 0.0;

                // Print courseId when button is pressed
                print("Course ID when button is pressed: $courseId");

                // Navigate to appropriate screen based on courseId
                _navigateToScreen(courseId, priceValue);
              },
            ),
            const SizedBox(height: 16), // Ensure the button doesn't overlap
          ],
        ),
      ),
    );
  }
}

class Package {
  final String title;
  final String price;
  final List<String> features;

  Package({
    required this.title,
    required this.price,
    required this.features,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      title: json['name'] as String, // Use 'name' from the API response
      price: json['price'] as String,
      features: List<String>.from(json['features'] as List<dynamic>),
    );
  }
}
*/


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import for JSON encoding/decoding
import '../Common/Custome_button.dart';
import '../Courses/Courses.dart';
import '../Courses/Datetime_shedule.dart';

class PackageScreen extends StatefulWidget {
  final String title;
  final String author;
  final double rating;
  final String courseId;

  const PackageScreen({
    super.key,
    required this.title,
    required this.author,
    required this.rating,
    required this.courseId,
  });

  @override
  _PackageScreenState createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  List<Package> packages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPackages();

    // Print the courseId to verify it's being passed
    print("Course ID passed to PackageScreen: ${widget.courseId}");
  }

  Future<void> fetchPackages() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.45:8000/api/v1/packages')); // Replace with your API URL
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.isNotEmpty) {
          setState(() {
            packages = jsonResponse.map((pkg) => Package.fromJson(pkg)).toList();
            isLoading = false; // Stop loading once data is fetched
          });
        } else {
          throw Exception('No packages found');
        }
      } else {
        throw Exception('Failed to load packages');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false; // Stop loading even if there's an error
      });
    }
  }

  void _navigateToScreen(String? courseId, double price, String package) {
    if (courseId != '') {
      // Navigate to InterviewBookingScreen with package title
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InterviewBookingScreen(
            price: price,
            title: widget.title,
            author: widget.author,
            rating: widget.rating,
            courseId: widget.courseId,
            package: package, // Pass package title
          ),
        ),
      );
    } else {
      // Show popup to select a course
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Select a Course',
              style: TextStyle(color: Colors.black),
            ),
            content: const Text(
              'Please select a course to proceed with booking.',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the popup
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Courses(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text(
                  'Select Course',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 27),
          child: Column(
            children: packages.map((package) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: buildPackageCard(
                  context,
                  title: package.title,
                  price: package.price,
                  features: package.features,
                  courseId: widget.courseId, // Pass courseId
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget buildPackageCard(
      BuildContext context, {
        required String title,
        required String price,
        required List<String> features,
        required String courseId, // Add courseId
      }) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: screenWidth * 0.75,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 18.0),
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: features.map((feature) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        const Icon(Icons.check, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            CustomeButton(
              height: 45,
              width: 280,
              buttonColor: Colors.deepPurple,
              text: "Select Plan",
              textColor: Colors.white,
              textSize: 18,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              borderRadius: 0,
              onTap: () {
                double priceValue = double.tryParse(price) ?? 0.0;

                // Navigate to appropriate screen with package title
                _navigateToScreen(courseId, priceValue, title);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class Package {
  final String title;
  final String price;
  final List<String> features;

  Package({
    required this.title,
    required this.price,
    required this.features,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      title: json['name'] as String, // Use 'name' from the API response
      price: json['price'] as String,
      features: List<String>.from(json['features'] as List<dynamic>),
    );
  }
}
