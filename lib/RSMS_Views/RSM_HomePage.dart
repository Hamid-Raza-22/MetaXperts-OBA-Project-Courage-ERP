import 'package:flutter/material.dart';
// Import other pages if needed

class RSMHomepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildCard(context, 'RSM-SHOP VISIT', Icons.store, Colors.green),
            _buildCard(context, 'RSM-BOOKER DETAILS', Icons.person, Colors.green),
            _buildCard(context, 'RSM SHOP DETAIL', Icons.info, Colors.green),
            _buildCard(context, 'RSM BOOKING BOOK', Icons.book, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, Color color) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
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
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
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
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'avenir next',
                      fontSize: 18,
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
      case 'RSM-SHOP VISIT':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShopVisitPage()),
        );
        break;
      case 'RSM-BOOKER DETAILS':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookerDetailsPage()),
        );
        break;
      case 'RSM SHOP DETAIL':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShopDetailPage()),
        );
        break;
      case 'RSM BOOKING BOOK':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookingBookPage()),
        );
        break;
    }
  }
}

class BookerDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RSM-BOOKER DETAILS'),
      ),
      body: const Center(child: Text('Booker Details Page')),
    );
  }
}

class ShopDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RSM SHOP DETAIL'),
      ),
      body: const Center(child: Text('Shop Detail Page')),
    );
  }
}

class BookingBookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('RSM BOOKING BOOK'),
        ),
        body: const Center(child: Text('Booking Book Page')),
        );
    }
}
class ShopVisitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('RSM BOOKING BOOK'),
        ),
        body: const Center(child: Text('Booking Book Page')),
        );
    }
}