import 'dart:convert'; // Thêm để decode json
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Thêm để thực hiện HTTP request
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
  String minPrice = '0';
  String maxPrice = '9999999999999';
  String searchQuery = ''; // Biến để lưu trữ từ khóa tìm kiếm

  // Danh sách mentor
  List<Map<String, dynamic>> mentors = [];

  // Hàm fetch data với từ khóa tìm kiếm
  Future<void> _fetchMentors() async {
    String name = searchQuery; // Dùng searchQuery làm giá trị cho name
    String specializations = '';
    String sort = 'asc';
    final response = await http.get(Uri.parse(
        'http://167.71.220.5:8080/account/search-mentor?name=$name&minPrice=$minPrice&maxPrice=$maxPrice&specializations=$specializations&sort=service.price&sort=$sort'));

    if (response.statusCode == 200) {
      // Parse JSON data và lưu vào biến mentors
      List<dynamic> data = json.decode(response.body)['data'];
      setState(() {
        mentors = data.map((mentor) => mentor as Map<String, dynamic>).toList();
      });
      if (mentors.isEmpty) {
        // In ra thông báo "Không có mentor" nếu danh sách trống
      }
    } else {
      throw Exception('Failed to load mentors');
    }
  }

  // Hàm hiển thị dialog lọc
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
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: 20), // Thêm padding trên và dưới
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
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: selectedFields.keys.map((field) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFields.updateAll(
                                  (key, value) => false); // Reset all
                              selectedFields[field] = true; // Select this field
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              color: selectedFields[field]!
                                  ? Color(0xFFB5ED3D) // Green when selected
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
                                      : Colors.grey),
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
                                      : Colors.grey),
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
    _fetchMentors(); // Gọi API khi màn hình được mở
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
                onChanged: (value) {
                  setState(() {
                    searchQuery = value; // Lưu từ khóa tìm kiếm khi thay đổi
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
                  _fetchMentors(); // Gọi lại hàm tìm kiếm khi người dùng nhấn Enter
                },
              ),
            ),
          ),
          Positioned(
            top: 15.5,
            right: 16,
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
          Positioned(
            top: 80,
            left: MediaQuery.of(context).size.width *
                0.125, // Để item chiếm 75% chiều rộng
            right: MediaQuery.of(context).size.width *
                0.125, // Để item chiếm 75% chiều rộng
            bottom: 10, // Khoảng cách từ dưới màn hình
            child: mentors.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: mentors.length,
                    itemBuilder: (context, index) {
                      var mentor = mentors[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 10, // Thêm bóng đổ cho card để nổi bật
                        color: Color(
                            0xFFF7F9F1), // Màu nền của card (tone xanh lá nhạt)
                        child: Container(
                          padding: EdgeInsets.all(0), // Không có padding
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  Color(0xFFB5ED3D), // Viền màu xanh lá nổi bật
                              width: 2, // Độ dày viền
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Avatar (hình vuông, bám sát phía trên khung item)
                              Builder(
                                builder: (context) {
                                  double width =
                                      MediaQuery.of(context).size.width *
                                          0.75; // 75% chiều rộng của màn hình
                                  return Container(
                                    width:
                                        width, // Avatar chiếm 100% chiều rộng của item
                                    height:
                                        width, // Chiều cao = chiều rộng, tạo thành hình vuông
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(
                                            15), // Bo góc dưới trái
                                        bottomRight: Radius.circular(
                                            15), // Bo góc dưới phải
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(mentor['avatar']),
                                        fit: BoxFit
                                            .cover, // Đảm bảo ảnh vừa khít
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 15),
                              // Thông tin Mentor
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                    vertical:
                                        15.0), // Khoảng cách bên trái, phải và dưới
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mentor['accountName'],
                                      style: TextStyle(
                                        fontSize: 22, // Tăng cỡ chữ cho tên
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      mentor['accountEmail'],
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(Icons.attach_money,
                                            size: 18, color: Colors.green),
                                        SizedBox(width: 5),
                                        Text(
                                          'Price: ${mentor['pricePerHour']}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight:
                                                FontWeight.bold, // In đậm
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(Icons.category,
                                            size: 18, color: Colors.grey),
                                        SizedBox(width: 5),
                                        Text(
                                          'Specializations: ${mentor['enumList'].join(', ')}',
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
