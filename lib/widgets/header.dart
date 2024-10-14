import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
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
          Positioned(
            top: 50,
            left: 20,
            right: 20, // Ensure the content stays within bounds
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Align for the first part (notifications + user greeting)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/notifications');
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                              size: 40,
                            ),
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Hello, User",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    height:
                        30), // Add space between the greeting and the buttons

                // Align for the buttons (to the right)
                Align(
                  alignment: Alignment.centerRight,
                  child: Wrap(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signIn');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Login"),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signUp');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Sign Up"),
                      ),
                    ],
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
