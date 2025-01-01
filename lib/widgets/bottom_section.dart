/*
import 'package:flutter/material.dart';

import '../Courses/Course_detail_screen.dart'; // Update with correct path to EnrollmentButton

class BottomSection extends StatelessWidget {
  final double? price;
  final bool isPackageSelected;
  final String? title;

  BottomSection({
    required this.price,
    required this.isPackageSelected,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -15,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          */
/*boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 2,
              offset: const Offset(0, -2),
            ),
          ],*//*

        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              price != null ? '₹${price!}' : 'Select Package',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            EnrollmentButton(
              title: title ?? 'Course Title',
              author: 'Course Author', // Modify if you have the author info
              price: price ?? 0,
              rating: 4.5, // Modify if you have a dynamic rating
              isPackageSelected: isPackageSelected,
            ),
          ],
        ),
      ),
    );
  }
}
*/
