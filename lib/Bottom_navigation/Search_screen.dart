import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // To load assets
import 'package:intl/intl.dart'; // For currency formatting
import 'package:http/http.dart' as http; // For API requests
import '../courses/Course_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>> _data = [];
  List<Map<String, dynamic>> _filteredData = [];
  String _searchQuery = '';
  List<String> _searchHistory = [];
  final List<String> _recommendedSearches = [
    "Flutter",
    "React",
    "Python",
    "Machine Learning",
    "Data Science",
    "Java",
    "Dart",
    "Node",
    "SQL"
  ];

  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _loadCourseData();
    _focusNode.addListener(_onFocusChange);
    // Adding test data for Latest Search
    _searchHistory.addAll([
      "Flutter",
      "React",
      "Python",
      "Machine Learning",
      "Data Science",
    ]);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  Future<void> _loadCourseData() async {
    final response = await http.get(Uri.parse('http://192.168.146.187:8000/api/v1/courses'));

    if (response.statusCode == 200) {
      setState(() {
        final List<dynamic> data = json.decode(response.body);
        _data = List<Map<String, dynamic>>.from(data);
        _filteredData = _data;
      });
    } else {
      throw Exception('Failed to load courses');
    }
  }

  void _filterData(String query) {
    setState(() {
      _searchQuery = query;
      _isTyping = query.isNotEmpty;

      _filteredData = _data
          .where((item) => item['courseName'] != null &&
          item['courseName'].toLowerCase().contains(query.toLowerCase()))
          .toList();

      if (_filteredData.isNotEmpty) {
        String courseTitle = _filteredData[0]['courseName'];
        if (!_searchHistory.contains(courseTitle)) {
          _searchHistory.add(courseTitle);
        }
      }
    });
  }

  void _clearSearchHistory() {
    setState(() {
      _searchHistory.clear();
    });
  }

  void _navigateToCourseDetail(Map<String, dynamic> course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailScreen(
          imageUrl: 'http://192.168.146.187:8000/api/v1/Images/${course['courseImage']}',
          title: course['courseName'] ?? '',
          author: course['author'] ?? '',
          price: double.tryParse(course['price']?.toString() ?? '0.0') ?? 0.0,
          rating: double.tryParse(course['courseRating']?.toString() ?? '0.0') ?? 0.0,
          /*ratingCount: course['ratingCount'] ?? 0,
          isBestseller: course['isBestseller'] ?? false,*/
          courseDescription: course['courseDescription'] ?? 'No description available',
          courseInfo: List<String>.from(course['courseInfo'] ?? []), // Pass the courseInfo
          courseId: course['id'] ?? 'No ID',
        ),
      ),
    );
  }


  Widget buildVerticalLayout(
      String imageUrl, String title, String author,
      double rating, int ratingCount, double price,
      bool isBestseller, String courseDescription, String courseId) {
    NumberFormat formatter = NumberFormat.simpleCurrency();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.network(
              imageUrl.isNotEmpty ? imageUrl : 'https://via.placeholder.com/90',
              width: 90,
              height: 90,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/default_image.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.fill,
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.isNotEmpty ? title : 'No Title Available',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  author.isNotEmpty ? author : 'Unknown Author',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Row(
                  children: [
                    Text(
                      '$rating',
                      style: const TextStyle(
                          color: Colors.orange, fontSize: 14),
                    ),
                    const Icon(Icons.star, color: Colors.orange, size: 14),
                    const SizedBox(width: 5),
                    Text(
                      '($ratingCount)',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Text(
                  formatter.format(price),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                if (isBestseller)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    child: const Text(
                      'Bestseller',
                      style: TextStyle(fontSize: 10, color: Colors.black),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Search bar in the body with white background
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 50,
              width: screenWidth * 0.95,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isTyping
                      ? Colors.deepPurple
                      : _isFocused ? Colors.deepPurple : Colors.grey,
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isFocused ? Colors.deepPurple.withOpacity(0.0) : Colors.black.withOpacity(0.0),
                    offset: Offset(0, 4),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: TextField(
                focusNode: _focusNode,
                onChanged: _filterData,
                decoration: InputDecoration(
                  hintText: 'Search for courses...',
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: _isFocused ? Colors.deepPurple : Colors.grey,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                style: const TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),

            // Latest Search section aligned to the left
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Latest Search: ${_searchHistory.isNotEmpty ? _searchHistory.last : 'No Search History'}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),

            // Show search history if available
            if (_searchHistory.isNotEmpty)
              Container(
                height: 100,
                width: screenWidth,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _searchHistory.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _filterData(_searchHistory[index]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Chip(
                          label: Text(
                            _searchHistory[index],
                            style: TextStyle(fontSize: 14),
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Clear History Text button aligned to the right
            /*Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _clearSearchHistory,
                child: Text(
                  'Clear History',
                  style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),*/

            // Search results section
            Expanded(
              child: ListView(
                children: [
                  if (_searchQuery.isNotEmpty && _filteredData.isEmpty)
                    Center(
                      child: Text(
                        'No results found for "$_searchQuery".',
                        style: TextStyle(color: Colors.blue, fontSize: 12),
                      ),
                    ),
                  if (_searchQuery.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _filteredData.length,
                      itemBuilder: (context, index) {
                        final item = _filteredData[index];

                        double parsedPrice = double.tryParse(item['price']?.toString() ?? '0.0') ?? 0.0;
                        double parsedRating = double.tryParse(item['courseRating']?.toString() ?? '0.0') ?? 0.0;
                        int ratingCount = item['ratingCount'] ?? 0;

/*
                        return GestureDetector(
                          onTap: () => _navigateToCourseDetail(item),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            color: Colors.white, // White background for cards
                            child: buildVerticalLayout(
                              'http://192.168.146.187:8000/api/v1/Images/${item['courseImage']}',
                              item['courseName'] ?? '',
                              item['author'] ?? '',
                              //parsedRating,
                              //ratingCount,
                              parsedPrice,
                              item['isBestseller'] ?? false,
                              //item['courseDescription'] ?? 'No description available',
                              //item['id'] ?? 'No ID',
                            ),
                          ),
                        );
*/
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
