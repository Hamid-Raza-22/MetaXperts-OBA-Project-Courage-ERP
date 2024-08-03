import 'package:flutter/material.dart';
import 'package:order_booking_shop/Views/SM/RSM_status.dart';


import 'SMBookerStatus.dart';



class BookingStatus extends StatefulWidget {
  @override
  _BookingStatusState createState() => _BookingStatusState();
}

class _BookingStatusState extends State<BookingStatus> {
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
                      padding: EdgeInsets.symmetric(vertical: 12), // Adjusted padding
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedIndex == 0 ? Colors.green : Colors.transparent,
                            width: 3.0,
                          ),
                        ),
                      ),
                      child: Text(
                        'RSM',
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
                        'BOOKER',
                        style: TextStyle(
                          color: _selectedIndex == 1 ? Colors.green : Colors.black,
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
                SM_RSMStatus(), // Replace with your actual page widget
                SMBookerStatus(), // Replace with your actual page widget
              ],
            ),
          ),
        ],
      ),
    );
  }
}
