import 'package:flutter/material.dart';
import '../layouts/second_layout.dart';

class SearchMentorScreen extends StatefulWidget {
  @override
  _SearchMentorScreenState createState() => _SearchMentorScreenState();
}

class _SearchMentorScreenState extends State<SearchMentorScreen> {
  Map<String, bool> selectedFields = {
    "Software Development": true,
    "Data Science": false,
    "Web Development": false,
    "UI/UX Design": false,
    "Cybersecurity": false,
    "AI": false,
  };

  String? selectedPriceOption;
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();

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
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Category",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: selectedFields.keys.map((field) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFields[field] = !selectedFields[field]!;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              color: selectedFields[field]!
                                  ? Color(0xFFB5ED3D)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: selectedFields[field]!
                                      ? Colors.green
                                      : Colors.grey),
                            ),
                            child: Text(
                              field,
                              style: TextStyle(
                                color: selectedFields[field]!
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Price per meeting",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: minPriceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Min Price',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: maxPriceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Max Price',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    RadioListTile<String>(
                      title: Text("Ascending price"),
                      value: "Ascending",
                      groupValue: selectedPriceOption,
                      onChanged: (value) {
                        setState(() {
                          selectedPriceOption = value;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text("Descending price"),
                      value: "Descending",
                      groupValue: selectedPriceOption,
                      onChanged: (value) {
                        setState(() {
                          selectedPriceOption = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
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
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SecondLayout(
      title: 'Search Mentor',
      currentPage: 'search',
      body: Stack(
        children: [
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
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          Positioned(
            top: 15.5,
            right: 16,
            child: Container(
              margin: EdgeInsets.only(left: 10),
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
        ],
      ),
    );
  }
}
