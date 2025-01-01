import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _experienceController = TextEditingController();
  String? _profileImage;
  String? _selectedGender;
  DateTime? _selectedDateOfBirth;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _mobileController.text = prefs.getString('mobile') ?? '';
      _addressController.text = prefs.getString('address') ?? '';
      _experienceController.text = prefs.getString('experience') ?? '';
      _selectedGender = prefs.getString('gender');
      _profileImage = prefs.getString('photoUrl');
      String? dobString = prefs.getString('dateOfBirth');
      if (dobString != null) {
        _selectedDateOfBirth = DateTime.parse(dobString);
      }
    });
  }

  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save to SharedPreferences
    await prefs.setString('name', _nameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('mobile', _mobileController.text);
    await prefs.setString('address', _addressController.text);
    await prefs.setString('experience', _experienceController.text);
    if (_selectedGender != null) await prefs.setString('gender', _selectedGender!);
    if (_selectedDateOfBirth != null) {
      await prefs.setString('dateOfBirth', _selectedDateOfBirth!.toIso8601String());
    }
    if (_profileImage != null) await prefs.setString('photoUrl', _profileImage!);

    // Save to API
    await _updateProfileAPI();

    // Navigate back with updated data
    Navigator.pop(context, {
      'name': _nameController.text,
      'email': _emailController.text,
      'mobile': _mobileController.text,
      'address': _addressController.text,
      'experience': _experienceController.text,
      'gender': _selectedGender,
      'dateOfBirth': _selectedDateOfBirth?.toIso8601String(),
      'profileImage': _profileImage,
    });
  }

  Future<void> _updateProfileAPI() async {
    final url = Uri.parse('http://192.168.146.187:8000/api/v1/user'); // Replace with your API endpoint
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': _nameController.text,
        'email': _emailController.text,
        'mobile': _mobileController.text,
        'address': _addressController.text,
        'experience': _experienceController.text,
        'gender': _selectedGender,
        'dateOfBirth': _selectedDateOfBirth?.toIso8601String(),
        'profileImage': _profileImage,
      }),
    );

    if (response.statusCode == 200) {
      print('Profile updated successfully');
    } else {
      print('Failed to update profile: ${response.statusCode}');
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = pickedFile.path;
      });
    }
  }

  Future<void> _pickDateOfBirth() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.deepPurple,
            hintColor: Colors.deepPurple,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            scaffoldBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDateOfBirth = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle(fontSize: 18, color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildProfileImage(screenWidth),
                    SizedBox(height: 20),
                    _buildTextField(_nameController, 'Name', 'Enter your name', Icons.person),
                    SizedBox(height: 20),
                    _buildTextField(_emailController, 'Email', 'Enter your email', Icons.email),
                    SizedBox(height: 20),
                    _buildTextField(_mobileController, 'Mobile Number', 'Enter your mobile number', Icons.phone),
                    SizedBox(height: 20),
                    _buildTextField(_addressController, 'Address', 'Enter your address', Icons.location_on),
                    SizedBox(height: 20),
                    _buildGenderDropdown(),
                    SizedBox(height: 20),
                    _buildDateOfBirthPicker(),
                    SizedBox(height: 20),
                    _buildTextField(_experienceController, 'Experience', 'Enter your experience', Icons.work),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton(
                onPressed: _saveUserData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Save Changes', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(double screenWidth) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: screenWidth * 0.15,
          backgroundColor: Colors.grey[200],
          backgroundImage: _profileImage != null && _profileImage!.isNotEmpty
              ? (File(_profileImage!).existsSync()
              ? FileImage(File(_profileImage!))
              : null) // Fallback if file doesn't exist
              : null,
          child: (_profileImage == null || _profileImage!.isEmpty ||
              (_profileImage!.isNotEmpty && !File(_profileImage!).existsSync()))
              ? Text(
            _nameController.text.isNotEmpty
                ? _nameController.text[0].toUpperCase()
                : '?',
            style: TextStyle(
              fontSize: screenWidth * 0.10,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          )
              : null,
        ),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
            ),
            child: Icon(Icons.camera_alt, color: Colors.deepPurple),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      items: ['Male', 'Female', 'Other']
          .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
          .toList(),
      onChanged: (value) => setState(() => _selectedGender = value),
      decoration: InputDecoration(
        labelText: 'Gender',
        prefixIcon: Icon(Icons.person_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildDateOfBirthPicker() {
    return InkWell(
      onTap: _pickDateOfBirth,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          prefixIcon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          _selectedDateOfBirth != null
              ? '${_selectedDateOfBirth!.year}-${_selectedDateOfBirth!.month.toString().padLeft(2, '0')}-${_selectedDateOfBirth!.day.toString().padLeft(2, '0')}'
              : 'Select your date of birth',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
