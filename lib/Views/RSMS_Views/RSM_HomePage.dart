import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:nanoid/nanoid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'dart:io' show File, InternetAddress, SocketException;

import '../../API/Globals.dart';
import '../../Databases/DBHelper.dart';
import '../../Models/AttendanceModel.dart';
import '../../Tracker/trac.dart';
import '../../location00.dart';
import '../../main.dart';
import '../HomePage.dart';
import 'LIVE_location_page.dart';
import 'BookerStatus.dart';
import 'RSM_ShopDetails.dart';
import 'RSM_ShopVisit.dart';
import 'RSM_bookerbookingdetails.dart';
import 'landing_page.dart';
// Import other pages if needed

class RSMHomepage extends StatefulWidget {
  const RSMHomepage({Key? key}) : super(key: key);

  @override
  _RSMHomepageState createState() => _RSMHomepageState();
}

class _RSMHomepageState extends State<RSMHomepage> {
  int? attendanceId;
  int? attendanceId1;
  double? globalLatitude1;
  double? globalLongitude1;
  DBHelper dbHelper = DBHelper();
  bool isLoadingReturn= false;
  final loc.Location location = loc.Location();
  bool isLoading = false; // Define isLoading variable
  Timer? _timer;


  @override
  void initState() {
    super.initState();

    // backgroundTask();
    // WidgetsBinding.instance.addObserver(this);
    _loadClockStatus();

    _retrieveSavedValues();
    _clockRefresh();
    if (kDebugMode) {
      print("B1000 ${name.toString()}");
    }
    //_requestPermission();
    // location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    // location.enableBackgroundMode(enable: true);
    _getFormattedDate();

    _checkForUpdate(); // Check for updates when the screen opens
  }
  void _checkForUpdate() async {
    try {
      final AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      if (e is PlatformException && e.code == 'TASK_FAILURE' && e.message?.contains('Install Error(-10)') == true) {
        if (kDebugMode) {
          print("The app is not owned by any user on this device. Update check skipped.");
        }
      } else {
        if (kDebugMode) {
          print("Failed to check for updates: $e");
        }
      }
    }
  }

  _saveClockStatus(bool clockedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isClockedIn', clockedIn);
    isClockedIn = clockedIn;
  }
  void _saveCurrentTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime currentTime = DateTime.now();
    String formattedTime = _formatDateTime(currentTime);
    prefs.setString('savedTime', formattedTime);
    if (kDebugMode) {
      print("Save Current Time");
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('HH:mm:ss');
    return formatter.format(dateTime);
  }
  int newsecondpassed = 0;
  void _clockRefresh() async {
    newsecondpassed = 0;
    timer = Timer.periodic(const Duration(seconds: 0), (timer) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        prefs.reload();
        newsecondpassed = prefs.getInt('secondsPassed')!;
      });
    });
  }


  String _formatDuration(String secondsString) {
    int seconds = int.parse(secondsString);
    Duration duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);

    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String secondsFormatted = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$secondsFormatted';
  }
  Future<bool> _isLocationEnabled() async {
    // Add your logic to check if location services are enabled
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    return isLocationEnabled;
  }
  _loadClockStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isClockedIn = prefs.getBool('isClockedIn') ?? false;
    if (isClockedIn == true) {
      startTimerFromSavedTime();
      // final service = FlutterBackgroundService();
      // service.startService();
      // _clockRefresh();
    }else{
      prefs.setInt('secondsPassed', 0);
    }
  }

  String _getFormattedtime() {
    final now = DateTime.now();
    final formatter = DateFormat('HH:mm:ss a');
    return formatter.format(now);
  }
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      throw Exception('Location services are disabled.');
    }

    // Check the location permission status.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Location permissions are denied
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Location permissions are permanently denied
      throw Exception('Location permissions are permanently denied.');
    }

    // Get the current position
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      // Save the location into the database (you need to implement this part)
      globalLatitude1 = position.latitude;
      globalLongitude1 = position.longitude;
      // Show a toast
    } catch (e) {
      if (kDebugMode) {
        print('Error getting current location: $e');
      }
    }
  }
  Future<String> _stopTimer() async {
    _timer?.cancel();
    String totalTime = _formatDuration(newsecondpassed.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('secondsPassed', 0);
    setState(() {
      secondsPassed = 0;
    });
    return totalTime;
  }
  Future<void> _toggleClockInOut() async {
    final service = FlutterBackgroundService();
    Completer<void> completer = Completer<void>();

    bool isLocationEnabled = await _isLocationEnabled();

    if (!isLocationEnabled) {
      Fluttertoast.showToast(
        msg: "Please enable GPS or location services before clocking in.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      completer.complete();
      return completer.future;
    }

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent users from dismissing the dialog
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Prevent back button from closing the dialog
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );

    bool isLocationPermissionGranted = await _checkLocationPermission();
    if (!isLocationPermissionGranted) {
      await _requestLocationPermission();
      Navigator.pop(context); // Close the loading indicator dialog if permission is not granted
      completer.complete();
      return completer.future;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await _getCurrentLocation();

    bool newIsClockedIn = !isClockedIn;

    if (newIsClockedIn) {
      await initializeServiceLocation();
      await location.enableBackgroundMode(enable: true);
      await location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
      locationbool = true;
      // startTimer();
      service.startService();

      var id = customAlphabet('1234567890', 10);
      await prefs.setString('clockInId', id);
      _saveCurrentTime();
      _saveClockStatus(true);
      _clockRefresh();
      isClockedIn = true;
      await Future.delayed(const Duration(seconds: 5));
      await attendanceViewModel.addAttendance(AttendanceModel(
        id: prefs.getString('clockInId'),
        timeIn: _getFormattedtime(),
        date: _getFormattedDate(),
        userId: userId.toString(),
        latIn: globalLatitude1,
        lngIn: globalLongitude1,
        bookerName: userNames,
        city: userCitys,
        designation: userDesignation,
      ));
      bool isConnected = await isInternetAvailable();

      if (isConnected) {
        await attendanceViewModel.postAttendance();
      }

      if (kDebugMode) {
        print('HomePage:$currentPostId');
      }
    } else {
      service.invoke("stopService");

      final date = DateFormat('dd-MM-yyyy').format(DateTime.now());
      final downloadDirectory = await getDownloadsDirectory();
      double totalDistance = await calculateTotalDistance(
          "${downloadDirectory?.path}/track$date.gpx");
      totalDistance ??= 0;
      await Future.delayed(const Duration(seconds: 4));
      await attendanceViewModel.addAttendanceOut(AttendanceOutModel(
        id: prefs.getString('clockInId'),
        timeOut: _getFormattedtime(),
        totalTime: _formatDuration(newsecondpassed.toString()),
        date: _getFormattedDate(),
        userId: userId.toString(),
        latOut: globalLatitude1,
        lngOut: globalLongitude1,
        totalDistance: totalDistance,
      ));
      isClockedIn = false;
      _saveClockStatus(false);
      await Future.delayed(const Duration(seconds: 10));

      await postFile();
      bool isConnected = await isInternetAvailable();

      if (isConnected) {
        await attendanceViewModel.postAttendanceOut();
      }

      _stopTimer();
      _clockRefresh();
      await prefs.remove('clockInId');
      await location.enableBackgroundMode(enable: false);
    }

    setState(() {
      isClockedIn = newIsClockedIn;
    });

    await Future.delayed(const Duration(seconds: 10));
    Navigator.pop(context); // Close the loading indicator dialog
    completer.complete();
    return completer.future;
  }
  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }
  String _getFormattedDate() {
    final now = DateTime.now();
    final formatter = DateFormat('dd-MMM-yyyy');
    return formatter.format(now);
  }
  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) {
      // Handle the case when permission is denied
      Fluttertoast.showToast(
        msg: "Location permissions are required to clock in.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
  _retrieveSavedValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
      userNames = prefs.getString('userNames') ?? '';
      userCitys = prefs.getString('userCitys') ?? '';
      userDesignation = prefs.getString('userDesignation') ?? '';
      userBrand = prefs.getString('userBrand') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      // Return false to prevent going back
      return false;
    },
    child: Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'RSM Homepage',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 24,
                color: Colors.white
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  //const Icon(Icons.info, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Timer: ${_formatDuration(newsecondpassed.toString())}',
                    style: const TextStyle(color: Colors.black, fontSize: 17),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await _toggleClockInOut();
                },
                icon: Icon(
                  isClockedIn ? Icons.timer_off : Icons.timer,
                  color: isClockedIn ? Colors.red : Colors.white
                ),
                label: Text(
                  isClockedIn ? 'Clock Out' : 'Clock In',
                  style: const TextStyle(fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: isClockedIn ? Colors.red : Colors.white,
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildCard(context, 'SHOP VISIT', Icons.store, Colors.green),
            _buildCard(context, 'BOOKERS STATUS', Icons.person, Colors.blue),
            _buildCard(context, 'SHOPS DETAILS', Icons.info, Colors.orange),
            _buildCard(context, 'BOOKERS ORDER DETAILS', Icons.book, Colors.purple),
            _buildCard(context, 'LIVE LOCATION', Icons.location_on, Colors.red),
          ],
        ),
      ),
     )
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
            Align(
              alignment: Alignment.center,
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
      case 'SHOP VISIT':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShopVisitPage()),
        );
        break;
      case 'BOOKERS STATUS':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RSMBookerStatus()),
        );
        break;
      case 'SHOPS DETAILS':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShopDetailPage()),
        );
        break;
      case 'BOOKERS ORDER DETAILS':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RSMBookingBookPage()),
        );
        break;
      case 'LIVE LOCATION':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LiveLocationPage()),
        );
        break;
    }
  }
}


