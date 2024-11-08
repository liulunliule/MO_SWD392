import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../layouts/second_layout.dart';

class SearchMentorScreen extends StatefulWidget {
  @override
  _SearchMentorScreenState createState() => _SearchMentorScreenState();
}

class _SearchMentorScreenState extends State<SearchMentorScreen> {
  bool isLoading = true;
  Map<String, bool> selectedFields = {};

  String selectedPriceOption = "Ascending";
  String minPrice = '0';
  String maxPrice = '9999999999999';
  String searchQuery = '';
  String selectedSpecialization = '';

  List<Map<String, dynamic>> mentors = [];

  Future<void> _fetchMentors() async {
    setState(() {
      isLoading = true; // Start loading
    });
    String? sort;
    if (selectedPriceOption == "Descending") {
      sort = 'desc';
    } else {
      sort = 'asc';
    }
    final response = await http.get(Uri.parse(
        'http://167.71.220.5:8080/account/search-mentor?name=$searchQuery&minPrice=$minPrice&maxPrice=$maxPrice&specializations=$selectedSpecialization&sort=service.price&sort=$sort'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      setState(() {
        mentors = data.map((mentor) => mentor as Map<String, dynamic>).toList();
        isLoading = false;
      });

      if (mentors.isEmpty) {}
    } else {
      setState(() {
        isLoading = false; // API has finished loading even on error
      });
      throw Exception('Failed to load mentors');
    }
  }

  List<String> specializationsList = [];
  Future<void> _fetchSpecializations() async {
    final response = await http.get(
        Uri.parse('http://167.71.220.5:8080/account/specialization/get-all'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data['code'] == 200) {
        setState(() {
          specializationsList = List<String>.from(data['data']);
        });
      } else {
        throw Exception('Failed to load specializations');
      }
    } else {
      throw Exception('Failed to load specializations');
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Specializations Section
                    Text(
                      "Specializations",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),

                    // Loading specializations if not yet loaded
                    specializationsList.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: specializationsList.map((specialization) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedFields.updateAll(
                                        (key, value) => false); // Reset all
                                    selectedFields[specialization] =
                                        true; // Select this field
                                    selectedSpecialization = specialization;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: selectedFields[specialization] ??
                                            false
                                        ? Color(
                                            0xFFB5ED3D) // Green when selected
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: selectedFields[specialization] ??
                                              false
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                  ),
                                  child: Text(
                                    specialization,
                                    style: TextStyle(
                                      color: selectedFields[specialization] ??
                                              false
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                    SizedBox(height: 20),

                    // Price Sorting Section (Ascending/Descending)
                    Text(
                      "Price per meeting",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPriceOption =
                                  "Ascending"; // Select Ascending
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              color: selectedPriceOption == "Ascending"
                                  ? Color(0xFFB5ED3D) // Green when selected
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selectedPriceOption == "Ascending"
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                            child: Text(
                              "Ascending",
                              style: TextStyle(
                                color: selectedPriceOption == "Ascending"
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPriceOption =
                                  "Descending"; // Select Descending
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              color: selectedPriceOption == "Descending"
                                  ? Color(0xFFB5ED3D) // Green when selected
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selectedPriceOption == "Descending"
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                            child: Text(
                              "Descending",
                              style: TextStyle(
                                color: selectedPriceOption == "Descending"
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Min and Max Price TextFields
                    Text(
                      "Min Price",
                      style: TextStyle(fontSize: 16),
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          minPrice = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Enter Min Price",
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        filled: true,
                        fillColor: Colors.white, // Background color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.green, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.grey[300]!, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15), // Inner padding
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Max Price",
                      style: TextStyle(fontSize: 16),
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          maxPrice = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Enter Max Price",
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        filled: true,
                        fillColor: Colors.white, // Background color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.green, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.grey[300]!, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15), // Inner padding
                      ),
                    ),
                    SizedBox(height: 20),

                    // Apply and Reset Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Reset Button
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              // Reset all filters to default values
                              selectedPriceOption = "Ascending";
                              minPrice = '0';
                              maxPrice = '9999999999999';
                              searchQuery = '';
                              selectedSpecialization = '';
                              selectedFields.updateAll((key, value) =>
                                  false); // Clear all specializations
                            });
                            Navigator.of(context).pop();
                            _fetchMentors(); // Fetch mentors after applying Reset
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Reset",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),

                        // Apply Button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _fetchMentors(); // Fetch mentors after applying filters
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFB5ED3D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text("Apply"),
                        ),
                      ],
                    ),
                    SizedBox(height: 10), // Thêm khoảng trống cuối cùng
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchSpecializations();
    _fetchMentors();
  }

  @override
  Widget build(BuildContext context) {
    return SecondLayout(
      title: 'Search Mentor',
      currentPage: 'search',
      body: Stack(
        children: [
          // TextField
          Positioned(
            top: 10,
            left: 16,
            right: 80,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.grey,
                  width: 1.5,
                ),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
                onSubmitted: (value) {
                  _fetchMentors();
                },
              ),
            ),
          ),
          // Filter Button
          Positioned(
            top: 15.5,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFB5ED3D),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  _showFilterDialog();
                },
                icon: Icon(Icons.tune, color: Colors.white),
              ),
            ),
          ),
          // Mentor List
          Positioned(
            top: 80,
            left: 40,
            right: 40,
            bottom: 10,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : mentors.isEmpty
                    ? Center(
                        child: Text(
                          'Have no mentor',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: mentors.length,
                        itemBuilder: (context, index) {
                          var mentor = mentors[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/mentorProfile',
                                arguments: mentor['accountId'],
                              );
                            },
                            child: Card(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 10,
                              color: Color(0xFFF7F9F1),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Color(0xFFB5ED3D),
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Avatar
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      child: AspectRatio(
                                        aspectRatio: 1.5, // Đảm bảo tỉ lệ ảnh
                                        child: Image.network(
                                          mentor['avatar'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    // Thông tin mentor
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Specializations
                                          Text(
                                            mentor['specializationList']
                                                .join('\n'),
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                            softWrap: true,
                                          ),
                                          SizedBox(height: 10),
                                          // Account Name
                                          Text(
                                            mentor['accountName'],
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          // Account Email
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(Icons.email,
                                                  size: 20, color: Colors.grey),
                                              SizedBox(width: 5),
                                              Expanded(
                                                child: Text(
                                                  mentor['accountEmail'],
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 20,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Price Per Hour
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.monetization_on,
                                                size: 18,
                                                color: Colors.green,
                                              ),
                                              SizedBox(width: 5),
                                              Expanded(
                                                child: Text(
                                                  'Price: ${mentor['pricePerHour']}',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
