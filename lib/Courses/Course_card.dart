import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Course_detail_screen.dart';
import 'Courses.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  List<dynamic> courses = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadCourseData();
  }

  Future<void> loadCourseData() async {
    const String apiUrl = 'http://192.168.1.45:8000/api/v1/courses';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          courses = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load courses: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : SingleChildScrollView(
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
            // Horizontal list of courses
            SizedBox(
              height: 225,
              child: ListView.builder(
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
                      rating: double.tryParse(course['courseRating'].toString()) ??
                          0.0,
                      ratingCount: course['ratingCount'] ?? 0,
                      price: double.tryParse(course['price'].toString()) ?? 0.0,
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
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
              child: Text(
                'Learn more & save',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Vertical list of courses
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Column(
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
                          rating: double.tryParse(course['courseRating'].toString()) ?? 0.0,
                          ratingCount: course['ratingCount'] ?? 0,
                          price: double.tryParse(course['price'].toString()) ?? 0.0,
                          isBestseller: course['isBestseller'] ?? false,
                          cardWidth: screenWidth,
                          cardHeight: 123,
                          imageHeight: 123 * 0.50,
                          imageWidth: screenWidth * 0.23,
                          courseDescription: course['courseDescription'] ?? 'No Description',
                          courseId: course['_id'] ?? 'No ID',
                          courseInfo: List<String>.from(course['courseInfo'] ?? []),
                        ),
                        const SizedBox(height: 2),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
