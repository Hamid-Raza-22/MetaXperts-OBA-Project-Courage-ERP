import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:nanoid/nanoid.dart';

import 'package:order_booking_shop/API/Globals.dart';
import 'package:order_booking_shop/Views/SM/sm_shopdetails.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart' as loc;
import '../../Databases/DBHelper.dart';
import '../../Models/AttendanceModel.dart';
import '../../Tracker/trac.dart';
import '../../location00.dart';
import '../../main.dart';
import '../HomePage.dart';
import 'SM_bookerbookingdetails.dart';
import 'sm_bookingstatus.dart';
import 'sm_location_navigation.dart';
import 'sm_shopvisit.dart';

class SMHomepage extends StatefulWidget {
  const SMHomepage({super.key});

  @override
  _SMHomepageState createState() => _SMHomepageState();
}

class _SMHomepageState extends State<SMHomepage> {
  int? attendanceId;
  int? attendanceId1;
  double? globalLatitude1;
  double? globalLongitude1;
  DBHelper dbHelper = DBHelper();
  bool isLoadingReturn= false;
  final loc.Location location = loc.Location();
  bool isLoading = false; // Define isLoading variable
  Timer? _timer;
  bool pressClockIn = false;
  late StreamSubscription<ServiceStatus> locationServiceStatusStream;


  @override
  void initState() {
    super.initState();

    // backgroundTask();
    // WidgetsBinding.instance.addObserver(this);
    _loadClockStatus();
    _monitorLocationService();
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
  @override
  void dispose() {
    locationServiceStatusStream.cancel();
    super.dispose();
  }
  void _monitorLocationService() {
    locationServiceStatusStream = Geolocator.getServiceStatusStream().listen((ServiceStatus status) async {
      if (status == ServiceStatus.disabled && isClockedIn) {
        await _handleClockOut();
      }
    });
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
  Future<void> _handleClockOut() async {
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
    final service = FlutterBackgroundService();
    Completer<void> completer = Completer<void>();
    bool newIsClockedIn = !isClockedIn;
    // Perform clock-out operations here
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isClockedIn', false);


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

    setState(() {
      isClockedIn = newIsClockedIn;
    });
    // setState(() {
    //   isClockedIn = false;
    // });

    // Optionally, show a notification or alert dialog to inform the user
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Clock Out'),
          content: const Text('You have been clocked out due to location services being disabled.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    await Future.delayed(const Duration(seconds: 10));
    Navigator.pop(context); // Close the loading indicator dialog
    completer.complete();
    return completer.future;
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
        title: const Center(
          child: Text(
            'SM DASHBOARD',
            style: TextStyle(
              fontFamily: 'avenir next',
              fontSize: 17,
            ),
          ),
        ),
        backgroundColor: Colors.white, // White background
        elevation: 1, // Add a subtle shadow

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.green),
            onPressed: () {
              // Add reload functionality here
            },
          ),
        ],
      ),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
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
                    {'title': 'Location', 'icon': Icons.location_on},
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'TIMER: ${_formatDuration(newsecondpassed.toString())}',
                  style: const TextStyle(
                    fontFamily: 'avenir next',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 50),
                ElevatedButton.icon(
                  onPressed: _toggleClockInOut,
                  icon: Icon(isClockedIn ? Icons.timer_off : Icons.timer,color: isClockedIn ? Colors.red : Colors.white),
                  label: Text(
                    isClockedIn ? 'Clock Out' : 'Clock In',
                    style: const TextStyle(
                      // color: Colors.white,
                      fontFamily: 'avenir next',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: isClockedIn ? Colors.red : Colors.white,
                    backgroundColor: Colors.green, // Background color
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
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
        if (isClockedIn) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ShopVisitPage(),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Clock In Required'),
              content: const Text('Please clock in before visiting a shop.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const ShopVisitPage()),
        // );
        break;
      case 'Booker Status':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookingStatus()),
        );
        break;
      case 'Shop Details':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SMShopDetailPage()),
        );
        break;
      case 'Booker Order Details':

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SMBookingBookPage()),
        );
        break;
      case 'Location':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => smnavigation()),
        );
        break;
    }
  }
}
