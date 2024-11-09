import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../layouts/third_layout.dart';

class WalletScreen extends StatefulWidget {
  final String accessToken;

  WalletScreen({required this.accessToken});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double total = 0.0;
  bool isLoading = true;
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  List<dynamic> transactionHistory = []; // Danh sách lịch sử giao dịch

  @override
  void initState() {
    super.initState();
    fetchWalletBalance();
    fetchTransactionHistory();
  }

  // Hàm lấy số dư ví
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
        final data = json.decode(response.body)['data'];
        setState(() {
          total = data['total'] ?? 0.0;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load balance')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Hàm lấy lịch sử giao dịch
  Future<void> fetchTransactionHistory() async {
    final url = 'http://167.71.220.5:8080/wallet-log/view';
    try {
      String? accessToken = await _storage.read(key: 'accessToken');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        setState(() {
          transactionHistory = data;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load transaction history')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Hàm hiển thị một item của lịch sử giao dịch
  Widget buildTransactionItem(dynamic log) {
    String type = log['type'];
    double amount = log['amount'];
    String createdAt = log['createdAt'];
    String from = log['from']?.toString() ?? 'N/A';
    String to = log['to']?.toString() ?? 'N/A';

    return ListTile(
      leading: Icon(
        type == 'DEPOSIT' ? Icons.arrow_downward : Icons.arrow_upward,
        color: type == 'DEPOSIT' ? Colors.green : Colors.red,
      ),
      title: Text(
        type,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('From: $from - To: $to\nDate: $createdAt'),
      trailing: Text(
        '${amount.toStringAsFixed(2)} VNĐ',
        style: TextStyle(
          color: type == 'DEPOSIT' ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThirdLayout(
      title: 'Wallet',
      currentPage: 'wallet',
      body: isLoading
          ? Center(child: CircularProgressIndicator())
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
                              '${total.toStringAsFixed(2)} VNĐ',
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

                // "Transaction History"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Transaction History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // List of Transaction History
                Expanded(
                  child: ListView.builder(
                    itemCount: transactionHistory.length,
                    itemBuilder: (context, index) {
                      return buildTransactionItem(transactionHistory[index]);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
