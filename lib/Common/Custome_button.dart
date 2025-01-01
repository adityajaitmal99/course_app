import 'package:flutter/material.dart';

class CustomeButton extends StatefulWidget {
  final double? height;
  final double? width;
  final Color buttonColor;
  final String text;
  final VoidCallback onTap;
  final Color textColor;
  final double textSize;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final IconData? icon; // Optional icon

  const CustomeButton({
    Key? key,
    this.height, // Optional
    this.width,  // Optional
    required this.buttonColor,
    required this.text,
    this.icon, // Icon made optional
    required this.onTap,
    required this.textColor,
    this.textSize = 16.0, // Default text size
    this.padding, // Optional
    this.borderRadius = 8.0, // Default borderRadius
  }) : super(key: key);

  @override
  State<CustomeButton> createState() => _CustomeButtonState();
}

class _CustomeButtonState extends State<CustomeButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Transparent material for InkWell
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(widget.borderRadius), // Ripple effect matches borderRadius
        child: Container(
          height: widget.height,
          width: widget.width,
          padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Default padding
          decoration: BoxDecoration(
            color: widget.buttonColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) // If icon is provided, show it
                Icon(
                  widget.icon,
                  size: 25.0, // Fixed icon size set to 25.0
                  color: widget.textColor, // Match icon color with text color
                ),
              if (widget.icon != null) const SizedBox(width: 8), // Add spacing between icon and text if icon exists
              Text(
                widget.text,
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: widget.textSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
