import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';

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
            height: 90,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _onButtonTapped(0),
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

class BookerLocation extends StatefulWidget {
  @override
  _BookerLocationState createState() => _BookerLocationState();
}

class _BookerLocationState extends State<BookerLocation> {
  late GoogleMapController mapController;

  final Map<String, LatLng> _dummyMarkers = {
    '📍 Booker 1 (Lahore)': const LatLng(31.5497, 74.3436),
    '📍 Booker 2 (Gulberg, Lahore)': const LatLng(31.5204, 74.3587),
    '📍 Booker 3 (DHA, Lahore)': const LatLng(31.4697, 74.4250),
    '📍 Booker 4 (Johar Town, Lahore)': const LatLng(31.4811, 74.3169),
  };

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _fitAllMarkers();
  }

  void _onMarkerSelected(String markerName) {
    LatLng? position = _dummyMarkers[markerName];
    if (position != null) {
      mapController.animateCamera(CameraUpdate.newLatLngZoom(position, 15));
    }
  }

  void _fitAllMarkers() {
    if (_dummyMarkers.isNotEmpty) {
      LatLngBounds bounds;
      LatLng southwest = LatLng(
        _dummyMarkers.values.map((latlng) => latlng.latitude).reduce((a, b) => a < b ? a : b),
        _dummyMarkers.values.map((latlng) => latlng.longitude).reduce((a, b) => a < b ? a : b),
      );
      LatLng northeast = LatLng(
        _dummyMarkers.values.map((latlng) => latlng.latitude).reduce((a, b) => a > b ? a : b),
        _dummyMarkers.values.map((latlng) => latlng.longitude).reduce((a, b) => a > b ? a : b),
      );
      bounds = LatLngBounds(southwest: southwest, northeast: northeast);

      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: DropdownSearch<String>(
                items: _dummyMarkers.keys.toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    _onMarkerSelected(newValue);
                  }
                },
                selectedItem: _dummyMarkers.keys.first,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Select Marker",
                    prefixIcon: const Icon(Icons.location_on),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: "Search Marker",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  menuProps: MenuProps(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            child: Container(
              width: double.infinity,
              height: 400,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(31.5497, 74.3436),
                    zoom: 12.0,
                  ),
                  markers: _dummyMarkers.entries.map((entry) {
                    return Marker(
                      markerId: MarkerId(entry.key),
                      position: entry.value,
                      infoWindow: InfoWindow(title: entry.key),
                    );
                  }).toSet(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RSMLocation extends StatefulWidget {
  @override
  _RSMLocationState createState() => _RSMLocationState();
}

class _RSMLocationState extends State<RSMLocation> {
  late GoogleMapController mapController;

  final Map<String, LatLng> _dummyMarkers = {
    '📍 RSM 1 (Karachi)': const LatLng(24.8607, 67.0011),
    '📍 RSM 2 (Clifton, Karachi)': const LatLng(24.8120, 67.0325),
    '📍 RSM 3 (Gulshan, Karachi)': const LatLng(24.9263, 67.1128),
    '📍 RSM 4 (DHA, Karachi)': const LatLng(24.8013, 67.0351),
  };

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _fitAllMarkers();
  }

  void _onMarkerSelected(String markerName) {
    LatLng? position = _dummyMarkers[markerName];
    if (position != null) {
      mapController.animateCamera(CameraUpdate.newLatLngZoom(position, 15));
    }
  }

  void _fitAllMarkers() {
    if (_dummyMarkers.isNotEmpty) {
      LatLngBounds bounds;
      LatLng southwest = LatLng(
        _dummyMarkers.values.map((latlng) => latlng.latitude).reduce((a, b) => a < b ? a : b),
        _dummyMarkers.values.map((latlng) => latlng.longitude).reduce((a, b) => a < b ? a : b),
      );
      LatLng northeast = LatLng(
        _dummyMarkers.values.map((latlng) => latlng.latitude).reduce((a, b) => a > b ? a : b),
        _dummyMarkers.values.map((latlng) => latlng.longitude).reduce((a, b) => a > b ? a : b),
      );
      bounds = LatLngBounds(southwest: southwest, northeast: northeast);

      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: DropdownSearch<String>(
                items: _dummyMarkers.keys.toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    _onMarkerSelected(newValue);
                  }
                },
                selectedItem: _dummyMarkers.keys.first,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Select Marker",
                    prefixIcon: const Icon(Icons.location_on),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: "Search Marker",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  menuProps: MenuProps(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            child: Container(
              width: double.infinity,
              height: 400,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(24.8607, 67.0011),
                    zoom: 12.0,
                  ),
                  markers: _dummyMarkers.entries.map((entry) {
                    return Marker(
                      markerId: MarkerId(entry.key),
                      position: entry.value,
                      infoWindow: InfoWindow(title: entry.key),
                    );
                  }).toSet(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
