// my_course_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Common/Outline_button.dart';
import '../Courses/Booking_details_screen.dart';
import '../Courses/CourseStorage.dart';
import '../model/Course.dart';

class MyCourseScreen extends StatefulWidget {
  @override
  _MyCourseScreenState createState() => _MyCourseScreenState();
}

class _MyCourseScreenState extends State<MyCourseScreen> with TickerProviderStateMixin {
  List<Course> courses = [];

  @override
  void initState() {
    super.initState();
    _loadCourseDetails();
  }

  Future<void> _loadCourseDetails() async {
    final fetchedCourses = await CourseStorage.getCourses();
    setState(() {
      courses = fetchedCourses;
    });
  }

  Future<void> _deleteCourse(int index) async {
    final courseToDelete = courses[index];
    //await CourseStorage.deleteCourse(courseToDelete.paymentId);
    setState(() {
      courses.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Course deleted successfully.')),
    );
  }

  void _navigateToBookingScreen(int index) async {
    final selectedCourse = courses[index];
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingDetailsScreen(
          title: selectedCourse.title,
          author: selectedCourse.author,
          price: selectedCourse.price,
          rating: selectedCourse.rating,
          date: selectedCourse.date,
          time: selectedCourse.time,
          courseId: '',
          package: '',
        ),
      ),
    );

    if (result != null) {
      // Handle any updates if necessary
      _loadCourseDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: courses.isEmpty
          ? const Center(
        child: Text(
          'No courses enrolled yet.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            color: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Author: ${course.author}'),
                  Text('Price: ₹${course.price.toStringAsFixed(2)}'),
                  Text('Rating: ${course.rating.toStringAsFixed(1)} ⭐'),
                  Text('Date: ${course.date.toLocal().toString().split(' ')[0]}'),
                  Text('Time: ${course.time.format(context)}'),
                  SizedBox(height: 8),
                  Text(
                    'Payment Status: ${_getPaymentStatusText(course.paymentStatus)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _getPaymentStatusColor(course.paymentStatus),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _AnimatedButton(
                        label: 'Update',
                        onPressed: () {
                          _navigateToBookingScreen(index);
                        },
                        borderColor: Colors.deepPurple,
                        backgroundColor: Colors.deepPurple,
                      ),
                      const SizedBox(width: 8),
                      _AnimatedButton(
                        label: 'Delete',
                        onPressed: () {
                          _deleteCourse(index);
                        },
                        borderColor: Colors.redAccent,
                        backgroundColor: Colors.redAccent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getPaymentStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return 'Successful';
      case 'pending':
        return 'Pending';
      case 'failed':
        return 'Failed';
      case 'deleted':
        return 'Deleted';
      default:
        return 'Unknown';
    }
  }

  Color _getPaymentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      case 'deleted':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}

class _AnimatedButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Color borderColor;
  final Color backgroundColor;
  final double textSize; // New parameter for customizable text size
  final double iconSize; // New parameter for customizable icon size

  const _AnimatedButton({
    required this.label,
    required this.onPressed,
    required this.borderColor,
    required this.backgroundColor,
    this.textSize = 16.0, // Default text size
    this.iconSize = 16.0, // Default icon size
  });

  @override
  __AnimatedButtonState createState() => __AnimatedButtonState();
}

class __AnimatedButtonState extends State<_AnimatedButton> {
  double _scale = 1.0;

  void _onPressDown(_) {
    setState(() {
      _scale = 0.9; // Scale down on press
    });
  }

  void _onPressUp(_) {
    setState(() {
      _scale = 1.0; // Scale back up
    });
    widget.onPressed(); // Call the onPressed callback
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onPressDown,
      onTapUp: _onPressUp,
      onTapCancel: () => setState(() => _scale = 1.0), // Reset on cancel
      child: Transform.scale(
        scale: _scale,
        child: CustomOutlinedButton(
          label: widget.label,
          onPressed: widget.onPressed,
          fontSize: widget.textSize, // Use customizable text size
          borderColor: widget.borderColor,
          textColor: Colors.white,
          backgroundColor: widget.backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          borderRadius: 8.0,
          iconPath: 'assets/icons/${widget.label.toLowerCase()}.png', // Ensure icons exist
          width: 90,
          height: 35,
        ),
      ),
    );
  }
}
