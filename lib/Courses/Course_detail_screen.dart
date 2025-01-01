import 'package:course_app/Common/Custome_button.dart';
import 'package:course_app/courses/Datetime_shedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

import '../Bottom_navigation/Package.dart';
import '../widgets/CurriculumSection.dart';
import '../widgets/PackageSection.dart';
import '../widgets/WhatYouWillLearnSection.dart';
import '../widgets/courseEncludeSection.dart';
import '../widgets/skillSection.dart';

class CourseDetailScreen extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String author;
  final double price;
  final double rating;
  /*final int ratingCount;
  final bool isBestseller;*/
  final String courseDescription;
  final String courseId;
  final List<String> courseInfo;

  CourseDetailScreen({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.price,
    required this.rating,
    /*required this.ratingCount,
    required this.isBestseller,*/
    required this.courseDescription,
    required this.courseId,
    required this.courseInfo,
  }) : super(key: key);

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _showIcons = true;
  bool _showFullText = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(begin: const Offset(1.5, 0.0), end: const Offset(0.0, 0.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (_showIcons) setState(() => _showIcons = false);
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (!_showIcons) setState(() => _showIcons = true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleText() {
    setState(() {
      _showFullText = !_showFullText;
    });
  }

  void _shareCourse() {
    final shareContent = '''
Check out this course on Flutter:

Title: ${widget.title}
Author: ${widget.author}
Price: ₹${widget.price}
Image: ${widget.imageUrl}
courseId: ${widget.courseId}

For more details, visit our app!
''';

    Share.share(shareContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Course Details'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        leading: _showIcons
            ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        )
            : null,
        actions: _showIcons
            ? [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: _shareCourse,
          ),
        ]
            : [],
      ),
      extendBodyBehindAppBar: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          return Stack(
            children: [
              ListView(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 80, left: 8, right: 8, top: 11),
                children: [
                  const SizedBox(height: 94),
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 225,
                        child: Image.network(
                          widget.imageUrl,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 80,
                                color: Colors.grey,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(1, 10, 1, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: screenWidth < 600 ? 20 : 24,
                            fontWeight: FontWeight.bold,
                            color: screenWidth < 600 ? Colors.black : Colors.indigo,
                          ),
                        ),
                        Text(
                          'By ${widget.author}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow[700]),
                                const SizedBox(width: 4),
                                Text(widget.rating.toString()),
                                const SizedBox(width: 4),
                                //Text('(${widget.ratingCount})'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _showFullText
                              ? widget.courseDescription
                              : (widget.courseDescription.length > 100
                              ? widget.courseDescription.substring(0, 100) + '...'
                              : widget.courseDescription),
                          style: const TextStyle(fontSize: 16),
                        ),
                        TextButton(
                          onPressed: _toggleText,
                          child: Text(_showFullText ? 'Read Less' : 'Read More'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.deepPurple,
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                        ),
                        // Pass courseInfo to SkillsSection
                        SkillsSection(skills: widget.courseInfo),
                        const SizedBox(height: 16),
                        WhatYouWillLearnSection(),
                        const SizedBox(height: 16),
                        CourseIncludesSection(),
                        const SizedBox(height: 1),
                        const SizedBox(height: 1),
                        CurriculumSection(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Center the button
                    children: [
                      CustomeButton(
                        height: 45,
                        width: 300,
                        buttonColor: Colors.deepPurple,
                        text: "Continue", // Change button text to "Continue"
                        textColor: Colors.white,
                        textSize: 19,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        borderRadius: 0,
                        onTap: () {
                          // Ensure courseId is passed correctly; if it's empty, pass a default value or handle the error
                          if (widget.courseId.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PackageScreen(
                                  title: widget.title, // Passing the title
                                  author: widget.author, // Passing the author
                                  rating: widget.rating, // Passing the rating
                                  courseId: widget.courseId, // Passing the courseId here
                                ),
                              ),
                            );
                          } else {
                            // You can handle the case where courseId is empty or null here
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Course ID Missing'),
                                  content: const Text('No course ID found for this course. Please try again later.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Close the popup
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Displaying courseId at the bottom of the screen
              Positioned(
                bottom: 80,
                left: 16,
                child: Text(
                  "Course ID: ${widget.courseId}",
                  style: const TextStyle(fontSize: 16, color: Colors.deepPurple),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
