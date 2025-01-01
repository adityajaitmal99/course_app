import 'dart:io';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Bottom_navigation/Home_page.dart';
import '../Bottom_navigation/Search_screen.dart';
import '../drawer/My_course_screen.dart';
import '../drawer/Certification_page.dart';
import '../courses/Payment.dart';
import '../login/LogIn_screen.dart';
import 'Profile_edit.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userId;
  String? userEmail;
  String? userName;
  String? userImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();

  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
      userEmail = prefs.getString('email') ?? 'Guest';
      userName = prefs.getString('name') ?? 'User Name';
      userImage = prefs.getString('photoUrl');
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, screenWidth, screenHeight),
            Expanded(child: _buildProfileOptions(context)),
            _buildLogoutButton(context, screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double screenWidth, double screenHeight) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: screenHeight * 0.30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: screenWidth * 0.15,
                backgroundColor: Colors.grey[200],
                backgroundImage: (userImage != null && File(userImage!).existsSync())
                    ? FileImage(File(userImage!))
                    : null,
                child: (userImage == null || !File(userImage!).existsSync())
                    ? Text(
                  userName != null && userName!.isNotEmpty
                      ? userName![0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    fontSize: screenWidth * 0.10,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                )
                    : null,
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () async {
                    var updatedData = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfileScreen()),
                      /*userId: userId,
                      userEmail: userEmail,*/
                    );
                    if (updatedData != null) {
                      _loadUserData(); // Refresh data after editing
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Colors.deepPurple,
                      size: screenWidth * 0.06,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            userName ?? 'User Name',
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            userEmail ?? 'Guest',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptions(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        _buildActionTile(
          context,
          'Home',
          Icons.home,
          Colors.blue,
              () => Navigator.push(
            context,
            PageTransition(type: PageTransitionType.rightToLeft, child: HomeScreen()),
          ),
        ),
        _buildActionTile(
          context,
          'Explore',
          Icons.search,
          Colors.orange,
              () => Navigator.push(
            context,
            PageTransition(type: PageTransitionType.rightToLeft, child: SearchScreen()),
          ),
        ),
        _buildActionTile(
          context,
          'My Courses',
          Icons.book,
          Colors.green,
              () => Navigator.push(
            context,
            PageTransition(type: PageTransitionType.rightToLeft, child: MyCourseScreen()),
          ),
        ),
        _buildActionTile(
          context,
          'Certificates',
          Icons.card_giftcard,
          Colors.red,
              () => Navigator.push(
            context,
            PageTransition(type: PageTransitionType.rightToLeft, child: CertificationPage()),
          ),
        ),
        _buildActionTile(
          context,
          'Packages',
          Icons.payment,
          Colors.purple,
              () => Navigator.push(
            context,
            PageTransition(type: PageTransitionType.rightToLeft, child: PaymentGatewayScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: color),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () => _showLogoutDialog(context),
        child: Text('Logout', style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performLogout();
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _performLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
