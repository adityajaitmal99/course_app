// course_storage.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/Course.dart';


class CourseStorage {
  static const String _coursesKey = 'my_courses';

  // Retrieve the list of courses
  static Future<List<Course>> getCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? coursesJson = prefs.getString(_coursesKey);
    if (coursesJson == null) return [];
    final List<dynamic> decoded = json.decode(coursesJson);
    return decoded.map((e) => Course.fromMap(e)).toList();
  }

  // Add a new course
  static Future<void> addCourse(Course course) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Course> courses = await getCourses();
    courses.add(course);
    final String encoded = json.encode(courses.map((c) => c.toMap()).toList());
    await prefs.setString(_coursesKey, encoded);
  }

  // Update an existing course's payment status
  static Future<void> updateCourseStatus(String paymentId, String newStatus) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Course> courses = await getCourses();
    final index = courses.indexWhere((course) => course.paymentId == paymentId);
    if (index != -1) {
      final updatedCourse = Course(
        title: courses[index].title,
        author: courses[index].author,
        price: courses[index].price,
        rating: courses[index].rating,
        date: courses[index].date,
        time: courses[index].time,
        paymentStatus: newStatus,
        paymentId: courses[index].paymentId,
      );
      courses[index] = updatedCourse;
      final String encoded = json.encode(courses.map((c) => c.toMap()).toList());
      await prefs.setString(_coursesKey, encoded);
    }
  }
}
