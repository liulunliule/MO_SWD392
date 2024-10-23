import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../layouts/second_layout.dart';

class WalletScreen extends StatefulWidget {
  final String accessToken;

  WalletScreen({required this.accessToken});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double balance = 0.0;
  bool isLoading = true;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchWalletBalance();
  }

  Future<void> fetchWalletBalance() async {
    final url = 'http://167.71.220.5:8080/wallet/view';
    try {
      String? accessToken = await _storage.read(key: 'accessToken');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final data = json.decode(response.body);
        setState(() {
          balance = data['balance'] ?? 0.0; // Update balance
          isLoading = false; // Loading complete
        });
      } else {
        // Handle error response
        setState(() {
          isLoading = false; // Loading complete
        });
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load balance')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Loading complete
      });
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SecondLayout(
      title: 'Wallet',
      currentPage: 'wallet',
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Loading indicator
          : Column(
              children: [
                // Balance box
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 200,
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    children: [
                      Positioned(
                        top: -50,
                        left: -50,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.green[700],
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -20,
                        right: -20,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.green[700],
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      // Balance display
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Your balance',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${balance.toStringAsFixed(2)} VNĐ', // Display balance with 2 decimal points
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // End box balance
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // "Deposit"
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle Deposit action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Deposit',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      // "Transaction History"
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle Transaction History action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Transaction History',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // "Select Deposit Method"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Select Deposit Method',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // "Bank Transfer"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle Bank Transfer action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Text(
                            'Bank Transfer',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle another Deposit Method action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Text(
                            'Other Method',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
