import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Package {
  final String name;
  final double price;
  final List<String> features;

  Package({
    required this.name,
    required this.price,
    required this.features,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      name: json['name'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      features: List<String>.from(json['features']),
    );
  }
}

class PackageSection extends StatefulWidget {
  final Function(double price) onPackageSelected;

  const PackageSection({Key? key, required this.onPackageSelected}) : super(key: key);

  @override
  _PackageSectionState createState() => _PackageSectionState();
}

class _PackageSectionState extends State<PackageSection> {
  List<Package> packages = [];
  List<bool> isExpandedList = [];
  bool isLoading = true;
  String errorMessage = '';
  Package? selectedPackage;

  @override
  void initState() {
    super.initState();
    fetchPackages();
  }

  Future<void> fetchPackages() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.146.187:8000/api/v1/packages'), // Replace with your API URL
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          packages = jsonResponse.map((pkg) => Package.fromJson(pkg)).toList();
          isExpandedList = List<bool>.filled(packages.length, false);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load packages');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching packages: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Package',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (errorMessage.isNotEmpty)
                Center(
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: packages.length,
                  itemBuilder: (context, index) {
                    final package = packages[index];
                    return Card(
                      color: Colors.white,
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              package.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${package.price}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isExpandedList[index])
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...package.features.map((feature) {
                                    return Text(
                                      '- $feature',
                                      style: TextStyle(fontSize: 14),
                                    );
                                  }).toList(),
                                  const SizedBox(height: 6),
                                ],
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isExpandedList[index] = !isExpandedList[index];
                                    });
                                  },
                                  child: Text(
                                    isExpandedList[index] ? 'Read Less' : 'Read More',
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedPackage = package; // Set the selected package
                                    });
                                    widget.onPackageSelected(package.price); // Pass the selected package price
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    backgroundColor: Colors.deepPurple,
                                    elevation: 4,
                                  ),
                                  child: const Text(
                                    'Select Package',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}
