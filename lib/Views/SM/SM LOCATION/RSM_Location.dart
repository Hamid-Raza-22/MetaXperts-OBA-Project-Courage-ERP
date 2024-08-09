import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_booking_shop/API/Globals.dart';

Future<Map<String, LatLng>> fetchRSMMarkers() async {
  Map<String, LatLng> markers = {};
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('location') // Adjust this collection path as needed
      .where('designation', whereIn:  ['RSM']) // Fetch RSM markers
      .where('SM_ID', whereIn:  [userId]) // Fetch RSM markers
      .get();

  for (var doc in snapshot.docs) {
    final data = doc.data() as Map<String, dynamic>;
    markers[data['name']] = LatLng(data['latitude'], data['longitude']);
  }

  return markers;
}


class RSMLocation extends StatefulWidget {
  @override
  _RSMLocationState createState() => _RSMLocationState();
}

class _RSMLocationState extends State<RSMLocation> {
  late GoogleMapController mapController;
  Map<String, LatLng> _markers = {};
  LatLng _initialCameraPosition = const LatLng(24.8607, 67.0011);

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    Map<String, LatLng> fetchedMarkers = await fetchRSMMarkers();
    setState(() {
      _markers = fetchedMarkers; // Update state with fetched markers
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _fitAllMarkers();
  }

  void _onMarkerSelected(String markerName) {
    LatLng? position = _markers[markerName];
    if (position != null) {
      mapController.animateCamera(CameraUpdate.newLatLngZoom(position, 15));
    }
  }

  void _fitAllMarkers() {
    if (_markers.isNotEmpty) {
      LatLngBounds bounds;
      LatLng southwest = LatLng(
        _markers.values.map((latlng) => latlng.latitude).reduce((a, b) => a < b ? a : b),
        _markers.values.map((latlng) => latlng.longitude).reduce((a, b) => a < b ? a : b),
      );
      LatLng northeast = LatLng(
        _markers.values.map((latlng) => latlng.latitude).reduce((a, b) => a > b ? a : b),
        _markers.values.map((latlng) => latlng.longitude).reduce((a, b) => a > b ? a : b),
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
                  items: _markers.keys.toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _onMarkerSelected(newValue);
                    }
                  },
                  selectedItem: _markers.isNotEmpty ? _markers.keys.first : null,
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
                    initialCameraPosition: CameraPosition(
                      target: _initialCameraPosition,
                      zoom: 4.0,
                    ),
                    markers: _markers.entries.map((entry) {
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mapController.animateCamera(CameraUpdate.newLatLngZoom(_initialCameraPosition, 6));
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}