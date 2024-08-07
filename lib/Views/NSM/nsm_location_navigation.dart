import 'package:flutter/material.dart';
import 'NSM LOCATIONS/Booker_location_NSM.dart';
import 'NSM LOCATIONS/RSM_Location_SM.dart';
import 'NSM LOCATIONS/SM_Location_NSM.dart';

class NsmLocationNavigation extends StatefulWidget {
  const NsmLocationNavigation({super.key});

  @override
  _NsmLocationNavigationState createState() => _NsmLocationNavigationState();
}

class _NsmLocationNavigationState extends State<NsmLocationNavigation> {
  int _selectedIndex = 0;

  void _onButtonTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _widgetOptions = <Widget>[
    const BookerLocationnsm(),
    const SMLocationnsm(),
    const RSMLocationnsm(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => _onButtonTapped(0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedIndex == 0 ? Colors.green : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: const Text(
                        'BOOKER',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => _onButtonTapped(1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedIndex == 1 ? Colors.green : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: const Text(
                        'SM',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => _onButtonTapped(2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedIndex == 2 ? Colors.green : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: const Text(
                        'RSM',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
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










