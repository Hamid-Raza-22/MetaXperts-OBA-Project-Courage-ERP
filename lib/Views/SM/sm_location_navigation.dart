import 'package:flutter/material.dart';
import 'SM LOCATION/Booker_Location.dart';
import 'SM LOCATION/RSM_Location.dart';

class smnavigation extends StatefulWidget {
  @override
  _smnavigationState createState() => _smnavigationState();
}

class _smnavigationState extends State<smnavigation> {
  int _selectedIndex = 0;

  void _onButtonTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _widgetOptions = <Widget>[
    BookerLocation(),
    RSMLocation(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            height: 65,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _onButtonTapped(0),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedIndex == 0 ? Colors.green : Colors.transparent,
                            width: 3.0,
                          ),
                        ),
                      ),
                      child: Text(
                        'BOOKER',
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
                    onTap: () => _onButtonTapped(1),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
              ],
            ),
          ),
          Expanded(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
    );
  }
}



