import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

import 'Booking_details_screen.dart';

class InterviewBookingScreen extends StatefulWidget {
  final String title;
  final String author;
  final double price;
  final double rating;
  final String courseId;
  final String package;

  const InterviewBookingScreen({
    Key? key,
    required this.title,
    required this.author,
    required this.price,
    required this.rating,
    required this.courseId,
    required this.package,
  }) : super(key: key);

  @override
  _InterviewBookingScreenState createState() =>
      _InterviewBookingScreenState();
}

class _InterviewBookingScreenState extends State<InterviewBookingScreen> {
  Map<String, List<String>> availableTimes = {};
  DateTime? selectedDate; // Allow null to handle no initial selection
  String? selectedTime;
  bool isLoading = false; // Track loading state
  String? errorMessage; // Track error messages

  @override
  void initState() {
    super.initState();
    fetchData();
    print("Course ID passed to DateandTime: ${widget.courseId}");
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final String courseId = widget.courseId; // Use the passed courseId
    final String apiUrl =
        'http://192.168.1.45:8000/api/v1/timemanagement/$courseId';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty && data[0]['availableTime'] != null) {
          final Map<String, dynamic> availableTime = data[0]['availableTime'];

          setState(() {
            availableTimes.clear();
            availableTime.forEach((date, times) {
              availableTimes[date] = List<String>.from(times);
            });

            // Optionally, set the initial selectedDate to the first available date
            if (availableTimes.isNotEmpty) {
              final firstAvailableDate = availableTimes.keys.first;
              selectedDate = DateTime.parse(firstAvailableDate);
            }
          });
        } else {
          setState(() {
            availableTimes.clear();
            errorMessage = 'No available time slots found.';
          });
        }
      } else {
        setState(() {
          errorMessage =
          'Failed to load data. Status Code: ${response.statusCode}';
        });
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred while fetching data.';
      });
      print("Error fetching data: $e");
      // Optionally, you can show a dialog or a Snackbar here
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }




  void _confirmBooking() {
    if (selectedTime != null && selectedDate != null) {
      try {
        // Check if the time is in 12-hour format (e.g., "2:00 PM") or 24-hour format (e.g., "14:00")
        final timeFormat = RegExp(r'(\d{1,2}):(\d{2})\s?(AM|PM)?');
        final match = timeFormat.firstMatch(selectedTime!);

        if (match != null) {
          final hour = int.parse(match.group(1)!);
          final minute = int.parse(match.group(2)!);
          String? ampm = match.group(3);

          // Convert to 24-hour format if it's in 12-hour format
          int adjustedHour = hour;
          if (ampm != null) {
            if (ampm.toUpperCase() == 'PM' && hour != 12) {
              adjustedHour = hour + 12;
            } else if (ampm.toUpperCase() == 'AM' && hour == 12) {
              adjustedHour = 0;
            }
          }

          // Now you have the adjusted hour and minute in 24-hour format
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingDetailsScreen(

                price: widget.price,
                rating: widget.rating,
                date: selectedDate!,
                time: TimeOfDay(hour: adjustedHour, minute: minute),
                title: widget.title, // Passing the title
                author: widget.author,
                courseId: widget.courseId,
                package: widget.package,
              ),
            ),
          );
        }
      } catch (e) {
        print("Error parsing time: $e");
        // Show a dialog if there's an error parsing the time
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Invalid Time Format'),
            content: const Text('Please select a valid time to proceed.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      }
    } else {
      // Show dialog if time isn't selected
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Rounded corners
          ),
          elevation: 5,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Wrap content
              children: [
                // Dialog Title
                Text(
                  'Selection Required',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                // Dialog Content Text
                Text(
                  'Please select both a date and time to proceed.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 24),
                // Button Row - Align button to the right
                Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Align the button to the right
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurple, // Text color
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded button
                        ),
                        elevation: 5, // Shadow effect
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Ok',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Course Details'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Book Your Session Slot',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06, // Responsive text size
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Select a date to see available time slots:',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045, // Responsive text size
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Calendar Section
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TableCalendar(
                        firstDay: DateTime.utc(
                            DateTime.now().year, DateTime.now().month, 1),
                        lastDay: DateTime.utc(
                            DateTime.now().year, DateTime.now().month + 1, 0),
                        focusedDay: selectedDate ?? DateTime.now(),
                        selectedDayPredicate: (day) => _isSameDay(selectedDate, day),
                        headerStyle: HeaderStyle(
                          titleCentered: true,
                          formatButtonVisible: false, // Removes "2 Weeks" button
                        ),
                        enabledDayPredicate: (day) {
                          final today = DateTime.now();
                          final dayString =
                              "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
                          final isAvailable = availableTimes.containsKey(dayString);
                          final isToday = _isSameDay(day, today);
                          return isAvailable && !isToday;
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            selectedDate = selectedDay;
                            selectedTime = null;
                          });
                        },
                        calendarStyle: CalendarStyle(
                          outsideDaysVisible: false,
                          defaultDecoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: Colors.deepPurple,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.deepPurpleAccent,
                              width: 1, // Reduced border size
                            ),
                          ),
                          todayDecoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          disabledDecoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                          disabledTextStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            final dateString =
                                "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
                            if (availableTimes[dateString] != null &&
                                availableTimes[dateString]!.isNotEmpty &&
                                !_isSameDay(day, DateTime.now())) {
                              return Container(
                                margin: EdgeInsets.all(screenWidth * 0.005), // Reduced padding
                                width: screenWidth * 0.08, // Responsive size
                                height: screenWidth * 0.08, // Responsive size
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.5,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${day.day}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenWidth * 0.035, // Responsive text
                                    ),
                                  ),
                                ),
                              );
                            }
                            return null; // Use default rendering for other days
                          },
                          disabledBuilder: (context, day, focusedDay) {
                            final today = DateTime.now();
                            final isToday = _isSameDay(day, today);
                            return Container(
                              margin: EdgeInsets.all(screenWidth * 0.005),
                              width: screenWidth * 0.08,
                              height: screenWidth * 0.08,
                              decoration: BoxDecoration(
                                color: isToday ? Colors.yellow[100] : Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${day.day}',
                                  style: TextStyle(
                                    color: isToday ? Colors.black : Colors.grey,
                                    fontSize: screenWidth * 0.035,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Time Slots Section
                  Text(
                    'Available Time Slots:',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Display loading indicator, error message, or time slots
                  if (isLoading)
                    Center(child: CircularProgressIndicator())
                  else if (errorMessage != null)
                    Center(
                      child: Text(
                        errorMessage!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: screenWidth * 0.04,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else if (selectedDate != null)
                      availableTimes[selectedDate!
                          .toIso8601String()
                          .split('T')
                          .first] !=
                          null
                          ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: availableTimes[selectedDate!
                              .toIso8601String()
                              .split('T')
                              .first]!
                              .map((time) => GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTime = time;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 8.0),
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01,
                                horizontal: screenWidth * 0.03,
                              ),
                              decoration: BoxDecoration(
                                color: selectedTime == time
                                    ? Colors.deepPurple
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selectedTime == time
                                      ? Colors.deepPurple
                                      : Colors.grey,
                                ),
                              ),
                              child: Text(
                                time,
                                style: TextStyle(
                                  color: selectedTime == time
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: screenWidth * 0.04, // Responsive text
                                ),
                              ),
                            ),
                          ))
                              .toList(),
                        ),
                      )
                          : Center(
                        child: Text(
                          'No available slots for this date',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                    else
                      Center(
                        child: Text(
                          'Please select a date to view available slots.',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),

                  SizedBox(height: 220),

                  // Confirm Booking Button
                  Center(
                    child: ElevatedButton(
                      onPressed: _confirmBooking,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurple,
                        shadowColor: Colors.deepPurpleAccent,
                        elevation: 5,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                      ),
                      child: const Text('Confirm Booking', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
