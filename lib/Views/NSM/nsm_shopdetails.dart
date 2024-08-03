import 'package:flutter/material.dart';

import 'nsm_shopdetails2..dart';

class NSMShopDetailPage extends StatefulWidget {
  @override
  _NSMShopDetailPageState createState() => _NSMShopDetailPageState();
}

class _NSMShopDetailPageState extends State<NSMShopDetailPage> {
  final List<Shop> _allShops = [
    Shop(
      name: 'Hamid store',
      city: 'Sialkot',
      address: 'gohad por',
    ),
    ...List.generate(
      10,
          (index) => Shop(
        name: 'Shop $index',
        city: 'City $index',
        address: 'Address $index',
      ),
    ),
  ];

  List<Shop> _filteredShops = [];
  final List<Shop> _displayedShops = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _filteredShops = _allShops;
    _addShopsToList(_filteredShops);
  }

  void _addShopsToList(List<Shop> shops) async {
    for (int i = 0; i < shops.length; i++) {
      if (!_displayedShops.contains(shops[i])) {
        _displayedShops.add(shops[i]);
        _listKey.currentState?.insertItem(_displayedShops.indexOf(shops[i]), duration: const Duration(seconds: 1));
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }
  }

  void _removeShopsFromList() async {
    for (int i = _displayedShops.length - 1; i >= 0; i--) {
      final removedShop = _displayedShops.removeAt(i);
      _listKey.currentState?.removeItem(
        i,
            (context, animation) => _buildShopCard(removedShop, animation),
        duration: const Duration(milliseconds: 300),
      );
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  void _filterShops() {
    final nameFilter = _nameController.text.toLowerCase();
    final cityFilter = _cityController.text.toLowerCase();
    _filteredShops = _allShops.where((shop) {
      final matchesName = shop.name.toLowerCase().contains(nameFilter);
      final matchesCity = shop.city.toLowerCase().contains(cityFilter);
      return matchesName && matchesCity;
    }).toList();
    _removeShopsFromList();
    _addShopsToList(_filteredShops);
  }

  Widget _buildTextField(String hint, TextEditingController controller, bool isDate, bool isReadOnly) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(
              isDate ? Icons.calendar_today : Icons.search,
              color: Colors.green,
            ),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[600]),
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green, width: 1.5),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          ),
          keyboardType: isDate ? TextInputType.datetime : TextInputType.text,
          readOnly: isReadOnly,
          onChanged: (value) {
            _filterShops();
          },
        ),
      ),
    );
  }

  Widget _buildShopCard(Shop shop, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NSMShopDetailsPage(shop: shop),
            ),
          );
        },
        child: Card(
          margin: const EdgeInsets.all(8.0),
          elevation: 4, // Reduced elevation
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Reduced border radius
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0), // Reduced padding
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0), // Reduced border radius
                  child: SizedBox(
                    width: 80, // Reduced image width
                    height: 80, // Reduced image height
                    child: Image.asset(
                      'assets/icons/shop-svg-3.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0), // Reduced spacing
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Reduced font size
                      ),
                      const SizedBox(height: 6.0), // Reduced spacing
                      Row(
                        children: [
                          const Icon(Icons.location_city, size: 14.0, color: Colors.green), // Reduced icon size
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: Text('City: ${shop.city}', style: const TextStyle(fontSize: 14)), // Reduced font size
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0), // Reduced spacing
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14.0, color: Colors.green), // Reduced icon size
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: Text('Address: ${shop.address}', style: const TextStyle(fontSize: 14)), // Reduced font size
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NSM SHOP DETAIL',
          style: TextStyle(color: Colors.black, fontSize: 18), // Reduced text size
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.green),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildTextField('Search by City', _cityController, false, false),
                    _buildTextField('Search by Shop Name', _nameController, false, false),
                  ],
                ),
              ),
            ),
            Expanded(
              child: AnimatedList(
                key: _listKey,
                initialItemCount: _displayedShops.length,
                itemBuilder: (context, index, animation) {
                  final shop = _displayedShops[index];
                  return _buildShopCard(shop, animation);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Shop {
  final String name;
  final String city;
  final String address;

  Shop({
    required this.name,
    required this.city,
    required this.address,
  });
}
