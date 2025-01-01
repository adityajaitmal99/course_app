// course.dart

import 'package:flutter/material.dart';

class Course {
  final String title;
  final String author;
  final double price;
  final double rating;
  final DateTime date;
  final TimeOfDay time;
  final String paymentStatus; // 'success', 'pending', 'failed'
  final String paymentId;

  Course({
    required this.title,
    required this.author,
    required this.price,
    required this.rating,
    required this.date,
    required this.time,
    required this.paymentStatus,
    required this.paymentId,
  });

  // Convert Course to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'price': price,
      'rating': rating,
      'date': date.toIso8601String(),
      'time': '${time.hour}:${time.minute}',
      'paymentStatus': paymentStatus,
      'paymentId': paymentId,
    };
  }

  // Create a Course from Map
  factory Course.fromMap(Map<String, dynamic> map) {
    final timeParts = map['time'].split(':');
    return Course(
      title: map['title'],
      author: map['author'],
      price: map['price'],
      rating: map['rating'],
      date: DateTime.parse(map['date']),
      time: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      paymentStatus: map['paymentStatus'],
      paymentId: map['paymentId'],
    );
  }
}
