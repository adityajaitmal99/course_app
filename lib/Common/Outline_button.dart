import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String label;
  final double fontSize;
  final Color borderColor;
  final Color textColor;
  final Color? backgroundColor; // New: Background color for the button
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final String? iconPath; // Optional: Path to asset icon
  final double? width;     // Optional: Custom width for the button
  final double? height;    // Optional: Custom height for the button

  const CustomOutlinedButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.fontSize = 16,
    this.borderColor = Colors.blue,
    this.textColor = Colors.blue,
    this.backgroundColor, // Optional background color
    this.padding = const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    this.borderRadius = 8.0,
    this.iconPath, // Optional: Icon path for image asset
    this.width,     // Optional width
    this.height,    // Optional height
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,  // Set the custom width
      height: height, // Set the custom height
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: padding,
          side: BorderSide(color: borderColor),
          backgroundColor: backgroundColor, // Set the background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconPath != null) ...[
              Image.asset(
                iconPath!,
                height: 10, // Set your desired height for the icon
                width: 10,  // Set your desired width for the icon
              ),
              const SizedBox(width: 5), // Space between icon and text
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Outlined Button Example',
      home: Scaffold(
        appBar: AppBar(title: const Text('Outlined Button')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomOutlinedButton(
                label: 'Click Me',
                onPressed: () {
                  // Handle button press
                  print('Button Pressed!');
                },
                fontSize: 16,
                borderColor: Colors.deepPurple,
                textColor: Colors.white,
                backgroundColor: Colors.deepPurple, // Example background color
                padding: EdgeInsets.all(10),
                borderRadius: 8.0,
                iconPath: 'assets/icons/click.png', // Example icon path
                width: 150, // Custom width
                height: 50, // Custom height
              ),
            ],
          ),
        ),
      ),
    );
  }
}
