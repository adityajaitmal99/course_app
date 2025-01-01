import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WhatYouWillLearnSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What you will learn',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle_outline,
                      color: Colors.deepPurple),
                  SizedBox(width: 8),
                  Expanded(child: Text('Build beautiful UIs with Flutter.')),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.check_circle_outline,
                      color: Colors.deepPurple),
                  SizedBox(width: 8),
                  Expanded(
                      child: Text(
                          'Understand the basics of animations in Flutter.')),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.check_circle_outline,
                      color: Colors.deepPurple),
                  SizedBox(width: 8),
                  Expanded(
                      child: Text(
                          'Get hands-on experience with Dart language.')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}