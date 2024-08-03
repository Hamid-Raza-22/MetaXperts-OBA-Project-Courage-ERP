import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'NSM_bookerbookingdetails.dart';
import 'nsm_bookingStatus.dart';
import 'nsm_location_navigation.dart';
import 'nsm_shopdetails.dart';
import 'nsm_shopvisit.dart';

class NSMHomepage extends StatefulWidget {
  const NSMHomepage({super.key});

  @override
  _NSMHomepageState createState() => _NSMHomepageState();
}

class _NSMHomepageState extends State<NSMHomepage> {
  bool _isClockedIn = false;
  late Stopwatch _stopwatch;
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _ticker = Ticker((Duration elapsed) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _toggleClockInOut() {
    setState(() {
      if (_isClockedIn) {
        _stopwatch.stop();
      } else {
        _stopwatch.start();
      }
      _isClockedIn = !_isClockedIn;
    });
    if (_isClockedIn) {
      _ticker.start();
    } else {
      _ticker.stop();
    }
  }

  String _formattedTime() {
    final duration = _stopwatch.elapsed;
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'NSM DASHBOARD',
            style: TextStyle(
              fontFamily: 'avenir next',
              fontSize: 17 // Reduced font size for AppBar title
            ),
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.green), // Set back arrow color to green
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.green),
            onPressed: () {
              // Add reload functionality here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            // Grid view for cards
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: 5, // Updated item count
                itemBuilder: (context, index) {
                  final cardInfo = [
                    {'title': 'Shop Visit', 'icon': Icons.store},
                    {'title': 'Booker Status', 'icon': Icons.person},
                    {'title': 'Shop Details', 'icon': Icons.info},
                    {'title': 'Booker Order Details', 'icon': Icons.book},
                    {'title': 'Location', 'icon': Icons.location_on}, // New card
                  ][index];

                  return _buildCard(
                    context,
                    cardInfo['title'] as String,
                    cardInfo['icon'] as IconData,
                    Colors.green,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Timer display and Clock In/Clock Out button in a horizontal layout
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'TIMER: ${_formattedTime()}',
                  style: const TextStyle(
                    fontFamily: 'avenir next',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 40),
                ElevatedButton.icon(
                  onPressed: _toggleClockInOut,
                  icon: Icon(_isClockedIn ? Icons.timer_off : Icons.timer, color: Colors.white),
                  label: Text(
                    _isClockedIn ? 'Clock Out' : 'Clock In',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'avenir next',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Background color
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, Color color) {
    return Card(
      elevation: 4, // Slightly reduced elevation for a smaller card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Slightly smaller border radius
      ),
      child: InkWell(
        onTap: () {
          _navigateToPage(context, title);
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.3), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.circular(10.0), // Match border radius
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0), // Reduced padding
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 24, // Slightly smaller icon size
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12), // Reduced space between icon and title
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'avenir next',
                      fontSize: 12, // Slightly smaller font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, String title) {
    // Navigation logic based on the title
    switch (title) {
      case 'Shop Visit':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NSMShopVisitPage()),
        );
        break;
      case 'Booker Status':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NSMBookingStatus()),
        );
        break;
      case 'Shop Details':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NSMShopDetailPage()),
        );
        break;
      case 'Booker Order Details':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NSMBookingBookPage()),
        );
        break;
      case 'Location':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NsmLocationNavigation()),
        );
        break;
    }
  }
}
