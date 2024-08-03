import 'package:flutter/material.dart';
import 'package:order_booking_shop/Views/NSM/RSM_status.dart';
import '../RSMS_Views/BookerStatus.dart';

import 'nsm_sm_status.dart';

class NSMBookingStatus extends StatefulWidget {
  @override
  _NSMBookingStatusState createState() => _NSMBookingStatusState();
}

class _NSMBookingStatusState extends State<NSMBookingStatus> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  void _onButtonPressed(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            height: 90,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _onButtonPressed(0),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedIndex == 0 ? Colors.green : Colors.transparent,
                            width: 3.0,
                          ),
                        ),
                      ),
                      child: Text(
                        'SM',
                        style: TextStyle(
                          color: _selectedIndex == 0 ? Colors.green : Colors.black,
                          fontSize: 16, // Adjust text size if needed
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _onButtonPressed(1),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 12), // Adjusted padding
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedIndex == 1 ? Colors.green : Colors.transparent,
                            width: 3.0,
                          ),
                        ),
                      ),
                      child: Text(
                        'RSM',
                        style: TextStyle(
                          color: _selectedIndex == 1 ? Colors.green : Colors.black,
                          fontSize: 16, // Adjust text size if needed
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _onButtonPressed(2),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 12), // Adjusted padding
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedIndex == 2 ? Colors.green : Colors.transparent,
                            width: 3.0,
                          ),
                        ),
                      ),
                      child: Text(
                        'Booker',
                        style: TextStyle(
                          color: _selectedIndex == 2 ? Colors.green : Colors.black,
                          fontSize: 16, // Adjust text size if needed
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                NSM_SM_Status(),
                RSM_Status(), // Replace with your actual page widget
                RSMBookerStatus(), // Replace with your actual page widget
              ],
            ),
          ),
        ],
      ),
    );
  }
}
