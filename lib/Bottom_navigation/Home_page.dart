import 'package:course_app/Bottom_navigation/Package.dart';
import 'package:course_app/Common/Custome_button.dart';
import 'package:course_app/courses/Course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import '../User_profile/Profile_edit.dart';
import '../courses/Courses.dart';
import '../drawer/My_course_screen.dart';
import '../User_profile/Profile.dart';
import '../login/LogIn_screen.dart';
import 'Search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool isLoggedIn = false; // Track login state

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data on init
  }
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false; // Check if logged in
    });
  }
  List<Widget> get _screens {
    List<Widget> screens = [
      CourseListScreen(), // Home screen
      Courses(),          // Courses screen
      SearchScreen(),     // Explore screen
      PackageScreen(title: '', author: '', rating: 0.0, courseId: '',),    // Package screen
    ];
    if (isLoggedIn) {
      screens.add(ProfilePage()); // Add Profile screen only if logged in
    }
    return screens;
  }

  // Titles for the app bar
  List<String> get _titles {
    List<String> titles = [
      'Home',
      'Courses',
      'Explore',
      'Package',
    ];
    if (isLoggedIn) {
      titles.add('Profile'); // Add Profile title only if logged in
    }
    return titles;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]), // Set title from _titles list
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      drawer: SignedInDrawer(onItemTapped: _onItemTapped, onLogout: () => _loadUserData()), // Update user data after logout
      body: _screens[_selectedIndex], // Switch between screens
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 24.0,
              height: 24.0,
              child: SvgPicture.asset(
                "assets/icons/home.svg",
                semanticsLabel: 'Courses',
              ),
            ),
            label: 'Home',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 24.0,
              height: 24.0,
              child: SvgPicture.asset(
                "assets/icons/course-svgrepo-com.svg",
                semanticsLabel: 'Courses',
              ),
            ),
            label: 'Courses',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 24.0,
              height: 24.0,
              child: SvgPicture.asset(
                "assets/icons/search.svg",
                semanticsLabel: 'Explore',
              ),
            ),
            label: 'Explore',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 35.0,
              height: 35.0,
              child: SvgPicture.asset(
                "assets/icons/package.svg",
                semanticsLabel: 'Package',
              ),
            ),
            label: 'Package',
            backgroundColor: Colors.white,
          ),
          // Only add Profile item if the user is logged in
          if (isLoggedIn)
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 24.0,
                height: 24.0,
                child: SvgPicture.asset(
                  "assets/icons/profile.svg",
                  semanticsLabel: 'Profile',
                ),
              ),
              label: 'Profile',
              backgroundColor: Colors.white,
            ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.white,
      ),
    );
  }
}

class SignedInDrawer extends StatefulWidget {
  final Function(int) onItemTapped; // Function to handle item tap
  final Function onLogout; // Function to handle logout action

  const SignedInDrawer({
    Key? key,
    required this.onItemTapped,
    required this.onLogout,
  }) : super(key: key);

  @override
  _SignedInDrawerState createState() => _SignedInDrawerState();
}

class _SignedInDrawerState extends State<SignedInDrawer> {
  String? userEmail;
  String? userName;
  String? userPhotoUrl;
  bool isLoggedIn = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data on initialization
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      userEmail = prefs.getString('email');
      userName = prefs.getString('name');
      userPhotoUrl = prefs.getString('photoUrl');
    });
  }

  Future<void> _navigateToEditProfileScreen() async {
    final updatedData = await Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: EditProfileScreen(),
      ),
    );

    if (updatedData != null) {
      await _saveUserData(updatedData);
      _loadUserData(); // Refresh drawer with updated data
    }
  }

  Future<void> _saveUserData(Map<String, String> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', userData['email'] ?? "");
    prefs.setString('name', userData['name'] ?? "");
    prefs.setString('photoUrl', userData['profileImage'] ?? "");
    prefs.setBool('isLoggedIn', true);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 30),
            child: isLoggedIn
                ? DrawerHeader(
              decoration: const BoxDecoration(color: Colors.white),
              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: GestureDetector(
                onTap: _navigateToEditProfileScreen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: userPhotoUrl != null
                          ? NetworkImage(userPhotoUrl!)
                          : const AssetImage('assets/icons/user.png') as ImageProvider,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      userName ?? "",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      userEmail ?? "",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
                : const SizedBox.shrink(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              children: [
                if (isLoggedIn)
                  ListTile(
                    leading: SvgPicture.asset(
                      "assets/icons/home.svg",
                      width: 24.0,
                      height: 24.0,
                    ),
                    title: const Text('Home', style: TextStyle(color: Colors.deepPurple)),
                    onTap: () {
                      widget.onItemTapped(0);
                      Navigator.pop(context);
                    },
                  ),
                ListTile(
                  leading: SvgPicture.asset(
                    "assets/icons/course-svgrepo-com.svg",
                    width: 24.0,
                    height: 24.0,
                  ),
                  title: const Text('Courses', style: TextStyle(color: Colors.deepPurple)),
                  onTap: () {
                    widget.onItemTapped(1);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    "assets/icons/search.svg",
                    width: 24.0,
                    height: 24.0,
                  ),
                  title: const Text('Explore', style: TextStyle(color: Colors.deepPurple)),
                  onTap: () {
                    widget.onItemTapped(2);
                    Navigator.pop(context);
                  },
                ),
                if (isLoggedIn)
                  ListTile(
                    leading: SvgPicture.asset(
                      "assets/icons/courses-svgrepo-com.svg",
                      width: 24.0,
                      height: 24.0,
                    ),
                    title: const Text('My Courses', style: TextStyle(color: Colors.deepPurple)),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: MyCourseScreen(),
                        ),
                      );
                    },
                  ),
                ListTile(
                  leading: SvgPicture.asset(
                    "assets/icons/package.svg",
                    width: 28.0,
                    height: 28.0,
                  ),
                  title: const Text('Package', style: TextStyle(color: Colors.deepPurple)),
                  onTap: () {
                    widget.onItemTapped(3);
                    Navigator.pop(context);
                  },
                ),
                if (isLoggedIn)
                  ListTile(
                    leading: SvgPicture.asset(
                      "assets/icons/log-out-svgrepo-com.svg",
                      width: 24.0,
                      height: 24.0,
                    ),
                    title: const Text('Logout', style: TextStyle(color: Colors.deepPurple)),
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                if (!isLoggedIn)
                  ListTile(
                    leading: SvgPicture.asset(
                      "assets/icons/login-svgrepo-com (1).svg",
                      width: 24.0,
                      height: 24.0,
                    ),
                    title: const Text('Sign In', style: TextStyle(color: Colors.deepPurple)),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: LoginScreen(),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // Logout dialog code
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Logout',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        actions: [
          CustomeButton(
            height: 40,
            width: 90,
            buttonColor: Colors.deepPurple,
            text: "Logout",
            textColor: Colors.white,
            textSize: 15,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            borderRadius: 15,
            onTap: () async {
              Navigator.of(context).pop(); // Close the dialog
              await _handleLogout(); // Perform logout and clear data
            },
          ),
          CustomeButton(
            height: 40,
            width: 90,
            buttonColor: Colors.grey[300]!,
            text: "Cancel",
            textColor: Colors.deepPurple,
            textSize: 15,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            borderRadius: 15,
            onTap: () {
              Navigator.of(context).pop(); // Close the dialog without logging out
            },
          ),
        ],
      ),
    );
  }

  // Handle logout logic
  Future<void> _handleLogout() async {
    // Clear login data from SharedPreferences
    await _clearLoginData();
    // Sign out from Google
    await _googleSignIn.signOut();
    // Notify parent widget of logout
    widget.onLogout(); // Call the logout callback
    // Navigate to LoginScreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  // Clear login data from SharedPreferences
  Future<void> _clearLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('email'); // Clear the user's email
    await prefs.remove('name'); // Clear the user's name
    await prefs.remove('photoUrl'); // Clear the user's profile image URL
  }
}
