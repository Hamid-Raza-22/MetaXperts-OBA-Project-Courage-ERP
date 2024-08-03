import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';

class NsmLocationNavigation extends StatefulWidget {
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

  List<Widget> _widgetOptions = <Widget>[
    BookerLocationnsm(),
    SMLocationnsm(),
    RSMLocationnsm(),
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
                      padding: EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedIndex == 0 ? Colors.green : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
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
                      padding: EdgeInsets.symmetric(vertical: 17),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedIndex == 1 ? Colors.green : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
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
                      padding: EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedIndex == 2 ? Colors.green : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
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

class BookerLocationnsm extends StatefulWidget {
  @override
  _BookerLocationnsmState createState() => _BookerLocationnsmState();
}

class _BookerLocationnsmState extends State<BookerLocationnsm> {
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
                    target: LatLng(30.3753, 69.3451),
                    zoom: 4.0,
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

class SMLocationnsm extends StatefulWidget {
  @override
  _SMLocationnsmState createState() => _SMLocationnsmState();
}

class _SMLocationnsmState extends State<SMLocationnsm> {
  late GoogleMapController mapController;

  final Map<String, LatLng> _dummyMarkers = {
    '📍 SM 1 (Sialkot)': const LatLng(32.4945, 74.5229),
    '📍 SM 2 (Cantt, Sialkot)': const LatLng(32.5021, 74.5158),
    '📍 SM 3 (Model Town, Sialkot)': const LatLng(32.4932, 74.5233),
    '📍 SM 4 (Ugoki, Sialkot)': const LatLng(32.4717, 74.4551),
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
                    target: LatLng(30.3753, 69.3451),
                    zoom: 4.0,
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

class RSMLocationnsm extends StatefulWidget {
  @override
  _RSMLocationnsmState createState() => _RSMLocationnsmState();
}

class _RSMLocationnsmState extends State<RSMLocationnsm> {
  late GoogleMapController mapController;

  final Map<String, LatLng> _dummyMarkers = {
    '📍 RSM 1 (Karachi)': const LatLng(24.8607, 67.0011),
    '📍 RSM 2 (Clifton, Karachi)': const LatLng(24.8066, 67.0377),
    '📍 RSM 3 (Korangi, Karachi)': const LatLng(24.8434, 67.1271),
    '📍 RSM 4 (Gulshan, Karachi)': const LatLng(24.9146, 67.0894),
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
                    target: LatLng(30.3753, 69.3451),
                    zoom: 4.0,
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
