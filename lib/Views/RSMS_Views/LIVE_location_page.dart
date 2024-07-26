import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';

class LiveLocationPage extends StatefulWidget {
  @override
  _LiveLocationPageState createState() => _LiveLocationPageState();
}

class _LiveLocationPageState extends State<LiveLocationPage> {
  late GoogleMapController mapController;

  final Map<String, LatLng> _dummyMarkers = {
    '📍 Booker 1 (Islamabad)': const LatLng(33.6844, 73.0479),  // Islamabad
    '📍 Booker 2 (Lahore)': const LatLng(31.5497, 74.3436),     // Lahore
    '📍 Booker 3 (Sialkot)': const LatLng(32.5149, 74.5430),     // Sialkot
    '📍 Booker 4 (Peshawar)': const LatLng(34.0151, 71.5249),    // Peshawar
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
        CameraUpdate.newLatLngBounds(bounds, 50), // Padding of 50 pixels
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booker's Live Location"),
        backgroundColor: Colors.green,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.greenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
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
                height: 400, // Adjust height here
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(30.3753, 69.3451), // Central position in Pakistan
                      zoom: 4.0,
                    ),
                    markers: _dummyMarkers.entries.map((entry) {
                      return Marker(
                        markerId: MarkerId(entry.key),
                        position: entry.value,
                        infoWindow: InfoWindow(title: entry.key),
                      );
                    }).toSet(),
                    // You can apply a custom map style here
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mapController.animateCamera(CameraUpdate.newLatLngZoom(
              const LatLng(30.3753, 69.3451), 6)); // Center camera on Pakistan
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}
