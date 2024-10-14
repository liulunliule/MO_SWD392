import 'package:flutter/material.dart';
import '../layouts/second_layout.dart';

class SearchMentorScreen extends StatefulWidget {
  @override
  _SearchMentorScreenState createState() => _SearchMentorScreenState();
}

class _SearchMentorScreenState extends State<SearchMentorScreen> {
  // Quản lý trạng thái lựa chọn cho các lĩnh vực
  Map<String, bool> selectedFields = {
    "Software Development": true,
    "Data Science": false,
    "Web Development": false,
    "UI/UX Design": false,
    "Cybersecurity": false,
    "AI": false,
  };

  // Quản lý trạng thái giá
  String? selectedPriceOption;

  // Hàm để hiển thị popup filter
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
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề Category
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
                  // Tiêu đề Price
                  Text(
                    "Price per meeting",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
                  // Nút Apply
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
            right: 80, // Dịch về phải để không chồng lên nút filter
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.grey, // Viền màu xám
                  width: 1.5, // Độ dày viền
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
            right: 16, // Căn phải
            child: Container(
              margin: EdgeInsets.only(left: 10), // Tạo khoảng cách từ bên trái
              decoration: BoxDecoration(
                color: Color(0xFFB5ED3D),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  _showFilterDialog(); // Gọi hàm hiển thị popup khi nhấn vào filter
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
