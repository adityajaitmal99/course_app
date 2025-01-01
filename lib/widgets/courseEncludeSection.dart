import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseIncludesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This course includes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.ondemand_video, color: Colors.black),
              SizedBox(width: 8),
              Text('5 hours of video content'),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.assignment, color: Colors.black),
              SizedBox(width: 8),
              Text('Course assignments'),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.article, color: Colors.black),
              SizedBox(width: 8),
              Text('Downloadable resources'),
            ],
          ),
        ],
      ),
    );
  }
}
