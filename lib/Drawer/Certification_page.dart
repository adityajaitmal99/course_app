import 'package:flutter/material.dart';

class CertificationPage extends StatelessWidget {
  final Color appBarColor;
  final Color cardColor;
  final Color titleColor;
  final Color descriptionColor;
  final double cardElevation;
  final double cardRadius;
  final double imageSize;

  const CertificationPage({
    Key? key,
    this.appBarColor = Colors.blueAccent,
    this.cardColor = Colors.white,
    this.titleColor = Colors.black,
    this.descriptionColor = Colors.grey,
    this.cardElevation = 10.0,
    this.cardRadius = 10.0,
    this.imageSize = 70.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Certifications'),
        backgroundColor: appBarColor,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: certifications.length,
        itemBuilder: (context, index) {
          return CertificationCard(
            certification: certifications[index],
            cardColor: cardColor,
            titleColor: titleColor,
            descriptionColor: descriptionColor,
            cardElevation: cardElevation,
            cardRadius: cardRadius,
            imageSize: imageSize,
            titleFontSize: screenWidth * 0.05, // Responsive font size
            descriptionFontSize: screenWidth * 0.03, // Responsive font size
          );
        },
      ),
    );
  }
}

class CertificationCard extends StatelessWidget {
  final Certification certification;
  final Color cardColor;
  final Color titleColor;
  final Color descriptionColor;
  final double cardElevation;
  final double cardRadius;
  final double imageSize;
  final double titleFontSize;
  final double descriptionFontSize;

  const CertificationCard({
    required this.certification,
    this.cardColor = Colors.white,
    this.titleColor = Colors.black,
    this.descriptionColor = Colors.grey,
    this.cardElevation = 4.0,
    this.cardRadius = 10.0,
    this.imageSize = 80.0,
    this.titleFontSize = 18.0,
    this.descriptionFontSize = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      elevation: cardElevation,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              certification.imagePath,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    certification.title,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    certification.description,
                    style: TextStyle(
                      fontSize: descriptionFontSize,
                      color: descriptionColor,
                    ),
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

class Certification {
  final String title;
  final String description;
  final String imagePath;

  Certification({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

// Dummy data for demonstration purposes
final List<Certification> certifications = [
  Certification(
    title: 'Flutter Development Certificate',
    description: 'Certified by XYZ Institute for completing Flutter course.',
    imagePath: 'assets/img_4.png',
  ),
  Certification(
    title: 'Web Development Certificate',
    description: 'Certified by ABC Academy for completing Web Development.',
    imagePath: 'assets/img_4.png',
  ),
  // Add more certifications here
];
