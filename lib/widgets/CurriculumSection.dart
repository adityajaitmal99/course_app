import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurriculumSection extends StatefulWidget {
  @override
  _CurriculumSectionState createState() => _CurriculumSectionState();
}

class _CurriculumSectionState extends State<CurriculumSection> {
  bool _isExpanded1 = false;
  bool _isExpanded2 = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(0.0),
          child: Text(
            'Curriculum',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              child: Text(
                'Section 1 - Course Introduction',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: Icon(
                _isExpanded1 ? Icons.expand_less : Icons.expand_more,
                color: Colors.deepPurple,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded1 = !_isExpanded1;
                });
              },
            ),
          ],
        ),
        if (_isExpanded1)
          Column(
            children: [
              ListTile(
                leading:
                Icon(Icons.play_circle_outline, color: Colors.black),
                title: Text('1. Course Overview',
                    style: TextStyle(color: Colors.black)),
                trailing: Text('5 min',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading:
                Icon(Icons.play_circle_outline, color: Colors.black),
                title: Text('2. Meet Your Instructor',
                    style: TextStyle(color: Colors.black)),
                trailing: Text('8 min',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              child: Text(
                'Section 2 - Basics of Flutter',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: Icon(
                _isExpanded2 ? Icons.expand_less : Icons.expand_more,
                color: Colors.deepPurple,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded2 = !_isExpanded2;
                });
              },
            ),
          ],
        ),
        if (_isExpanded2)
          Column(
            children: [
              ListTile(
                leading:
                Icon(Icons.play_circle_outline, color: Colors.black),
                title: Text('1. Setting Up Flutter',
                    style: TextStyle(color: Colors.black)),
                trailing: Text('10 min',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading:
                Icon(Icons.play_circle_outline, color: Colors.black),
                title: Text('2. Hello World in Flutter',
                    style: TextStyle(color: Colors.black)),
                trailing: Text('7 min',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
      ],
    );
  }
}
