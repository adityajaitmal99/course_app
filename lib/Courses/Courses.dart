import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http; // Import for API requests
import 'Course_detail_screen.dart'; // Ensure this file exists and is correctly implemented

class Courses extends StatelessWidget {
  const Courses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CourseScreen(), // Display the course list
    );
  }
}

class CourseScreen extends StatefulWidget {
  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  List courses = [];

  @override
  void initState() {
    super.initState();
    loadCourseData();
  }

  // API call to fetch course data
  Future<void> loadCourseData() async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.1.45:8000/api/v1/courses')); // Your API URL

      if (response.statusCode == 200) {
        setState(() {
          courses = json.decode(response.body); // Decode JSON response
        });
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      // Handle any errors here, such as displaying a snackbar or logging
      print('Error fetching courses: $e');
      // Optionally, you can set courses to an empty list or show an error message in the UI
      setState(() {
        courses = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white, // Set background color to white
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Recommended for you',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Horizontal scrollable list for recommended courses
            Container(
              height: 225,
              child: courses.isNotEmpty
                  ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: CourseCard(
                      imageUrl:
                      'http://192.168.1.45:8000/api/v1/Images/${course['courseImage']}',
                      title: course['courseName'] ?? 'Untitled',
                      author: course['author'] ?? 'Instructor',
                      rating: double.tryParse(
                          course['courseRating'].toString()) ??
                          0.0,
                      ratingCount: course['ratingCount'] ?? 0, // Updated
                      price: double.tryParse(course['price'].toString()) ??
                          0.0, // Updated
                      isBestseller: course['isBestseller'] ?? false,
                      cardWidth: 200,
                      cardHeight: 225,
                      imageHeight: 135 * 1.4,
                      imageWidth: 235,
                      isHorizontal: true,
                      courseDescription:
                      course['courseDescription'] ?? 'No Description',
                      courseId: course['_id'] ?? 'No ID',
                      courseInfo: List<String>.from(course['courseInfo'] ?? []),
                    ),
                  );
                },
              )
                  : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No courses available.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const Padding(
              padding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
              child: Text(
                'Learn more & save',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // List of all courses
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: courses.isNotEmpty
                  ? Column(
                children: List.generate(
                  courses.length,
                      (index) {
                    final course = courses[index];
                    return Column(
                      children: [
                        CourseCard(
                          imageUrl:
                          'http://192.168.1.45:8000/api/v1/Images/${course['courseImage']}',
                          title: course['courseName'] ?? 'Untitled',
                          author: course['author'] ?? 'Instructor',
                          rating: double.tryParse(
                              course['courseRating'].toString()) ??
                              0.0,
                          ratingCount: course['ratingCount'] ?? 0, // Updated
                          price: double.tryParse(
                              course['price'].toString()) ??
                              0.0, // Updated
                          isBestseller:
                          course['isBestseller'] ?? false, // Updated
                          cardWidth: screenWidth,
                          cardHeight: 123,
                          imageHeight: 123 * 0.50,
                          imageWidth: screenWidth * 0.23,
                          courseDescription:
                          course['courseDescription'] ??
                              'No Description',
                          courseId: course['_id'] ?? 'No ID',
                          courseInfo: List<String>.from(course['courseInfo'] ?? []),
                        ),
                        const SizedBox(height: 2),
                      ],
                    );
                  },
                ),
              )
                  : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No courses available.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final double rating;
  final int ratingCount;
  final double price;
  final bool isBestseller;
  final double cardWidth;
  final double cardHeight;
  final double imageHeight;
  final double imageWidth;
  final bool isHorizontal;
  final String courseDescription; // Added course description
  final String courseId; // Added course ID
  final List<String> courseInfo; // Added courseInfo

  CourseCard({
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.rating,
    required this.ratingCount,
    required this.price,
    this.isBestseller = false,
    required this.cardWidth,
    required this.cardHeight,
    required this.imageHeight,
    required this.imageWidth,
    this.isHorizontal = false,
    required this.courseDescription,
    required this.courseId,
    required this.courseInfo,
  });

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter =
    NumberFormat.simpleCurrency(locale: 'en_IN'); // Adjust locale as needed
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailScreen(
              imageUrl: imageUrl,
              title: title,
              author: author,
              rating: rating,
              //ratingCount: ratingCount,
              price: price,
              //isBestseller: isBestseller,
              courseDescription: courseDescription,
              courseId: courseId,
              courseInfo: courseInfo,
            ),
          ),
        );
      },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3.0),
          boxShadow: [
            const BoxShadow(
              color: Colors.black12,
              blurRadius: 5.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child:
        isHorizontal ? buildHorizontalLayout(formatter) : buildVerticalLayout(formatter),
      ),
    );
  }

  Widget buildHorizontalLayout(NumberFormat formatter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image with loading and error handling
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5.0),
            topRight: Radius.circular(5.0),
          ),
          child: Image.network(
            imageUrl,
            height: imageHeight * 0.5,
            width: cardWidth,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: imageHeight * 0.5,
                width: cardWidth,
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: imageHeight * 0.5,
                width: cardWidth,
                color: Colors.grey[200],
                child: const Icon(
                  Icons.image_not_supported,
                  size: 50,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // Author Name
              Text(
                author,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              // Rating
              Row(
                children: [
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(color: Colors.orange, fontSize: 14),
                  ),
                  const Icon(Icons.star, color: Colors.orange, size: 14),
                  const SizedBox(width: 10),
                  Text(
                    '($ratingCount)',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              // Price
              Text(
                formatter.format(price),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              // Bestseller Badge
              if (isBestseller)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.yellow[800],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Bestseller',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildVerticalLayout(NumberFormat formatter) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 8),
        // Image with loading and error handling
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.network(
              imageUrl,
              width: imageWidth,
              height: imageHeight,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: imageWidth,
                  height: imageHeight,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: imageWidth,
                  height: imageHeight,
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Course Details
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course Title
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Author Name
                Text(
                  author,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                // Rating
                Row(
                  children: [
                    Text(
                      rating.toStringAsFixed(1),
                      style:
                      const TextStyle(color: Colors.orange, fontSize: 14),
                    ),
                    const Icon(Icons.star, color: Colors.orange, size: 14),
                    const SizedBox(width: 10),
                    Text(
                      '($ratingCount)',
                      style:
                      const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Price
                Text(
                  formatter.format(price),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                // Bestseller Badge (Optional: You can add it here if needed)
                if (isBestseller)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.yellow[800],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Bestseller',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
