import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:nanoid/async.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../API/Globals.dart';
import '../../Models/HeadsShopVistModels.dart';
import '../../Models/ShopVisitModels.dart';
import '../../View_Models/LoginViewModel.dart';
import '../../View_Models/OwnerViewModel.dart';
import '../../View_Models/ShopVisitViewModel.dart';
import 'nsm_homepage.dart';



class NSMShopVisitPage extends StatefulWidget {
  const NSMShopVisitPage({
    Key? key,
  }) : super(key: key);

  @override
  NSMShopVisitPageState createState() => NSMShopVisitPageState();
}

class NSMShopVisitPageState extends State<NSMShopVisitPage> {
  TextEditingController regionController = TextEditingController();
  TextEditingController bookerController = TextEditingController();
  TextEditingController shopController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();
  bool isGpsEnabled = false;
  bool isLoadingLocation = false; // Loading state variable

  dynamic latitude = '';
  dynamic longitude = '';
  bool isLocationFetched = false;
  bool isLocationChecked = false; // Checkbox state
  final ownerViewModel = Get.put(OwnerViewModel());
  final loginViewModel = Get.put(LoginViewModel());
  final shopVisitViewModel = Get.put(ShopVisitViewModel());
  List<String> dropdownItems = [];
  List<String> bookersDropdownItems = [];
  List<String> citiesDropdownItems = [];
  final TextEditingController NSMNameController = TextEditingController(text: userNames);
  final String currentDate = DateFormat('dd-MMMM-yyyy hh:mm a').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _checkUserIdAndFetchShopNames();
    fetchBookerNamesByNSMDesignation();
    fetchCitiesNames();
  }

  Future<void> fetchCitiesNames() async {
    List<dynamic> businessNames = await dbHelper.getCitiesNames();
    setState(() {
      citiesDropdownItems = businessNames.map((dynamic item) => item.toString()).toSet().toList();
    });
  }

  Future<void> _checkUserIdAndFetchShopNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDesignation = prefs.getString('userDesignation');

    var boxName = (userDesignation == 'NSM') ? 'shopNames' : 'shopNamesByCities';
    var box = await Hive.openBox(boxName);

    cachedShopNames = box.get(boxName) as List<String>?;
    await box.close();

    if (cachedShopNames != null && cachedShopNames!.isNotEmpty) {
      setState(() {
        dropdownItems = cachedShopNames!.map((dynamic item) => item.toString()).toSet().toList();
      });
    } else {
      if (userDesignation == 'NSM') {
        await fetchShopNamesAll();
      }
    }
  }

  Future<void> saveCurrentLocation(BuildContext context) async {
    setState(() {
      isLoadingLocation = true; // Start loading
    });

    PermissionStatus permission = await Permission.location.request();

    if (permission.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        double latitude = position.latitude;
        double longitude = position.longitude;

        if (kDebugMode) {
          print('Latitude: $latitude, Longitude: $longitude');
        }

        List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
        Placemark currentPlace = placemarks[0];

        String address1 = "${currentPlace.thoroughfare} ${currentPlace.subLocality}, ${currentPlace.locality}${currentPlace.postalCode}, ${currentPlace.country}";
        address = address1;
        isLocationFetched = true; // Set location fetched to true
        isGpsEnabled = true; // GPS is enabled

        if (kDebugMode) {
          print('Address is: $address1');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error getting location: $e');
        }
        isGpsEnabled = false; // GPS is not enabled
      }
    } else {
      if (kDebugMode) {
        print('Location permission is not granted');
      }
      // Ensure GPS remains disabled
      isGpsEnabled = false;
      // Navigate to NSMHomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NSMHomepage()),
      );
    }
    setState(() {
      isLoadingLocation = false; // Stop loading
    }); // Update UI after location fetch
  }

  Future<void> fetchShopNamesAll() async {
    ownerViewModel.fetchShopNames();
    List<String> shopNames = ownerViewModel.shopNames.map((dynamic item) => item.toString()).toSet().toList();

    var box = await Hive.openBox('shopNames');
    await box.put('shopNames', shopNames);
    List<String> allShopNames = box.get('shopNames', defaultValue: <String>[]);
    if (kDebugMode) {
      print('All shop names: $allShopNames');
    }
    await box.close();

    setState(() {
      dropdownItems = shopNames.map((dynamic item) => item.toString()).toSet().toList();
    });
  }
  Future<void> fetchBookerNamesByNSMDesignation() async {
    loginViewModel.fetchBookerNamesByNSMDesignation();
    List<String> bookerNames = loginViewModel.bookerNamesByNSMDesignation.map((dynamic item) => item.toString()).toSet().toList();

    var box = await Hive.openBox('bookerNames');
    await box.put('bookerNames', bookerNames);
    List<String> allBookerNames = box.get('bookerNames', defaultValue: <String>[]);
    if (kDebugMode) {
      print('All shop names: $allBookerNames');
    }
    await box.close();

    setState(() {
      bookersDropdownItems = bookerNames.map((dynamic item) => item.toString()).toSet().toList();
    });
  }

  bool _isSubmitButtonEnabled() {
    return isLocationFetched &&
        regionController.text.isNotEmpty &&
        bookerController.text.isNotEmpty &&
        shopController.text.isNotEmpty &&
        feedbackController.text.isNotEmpty;
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }



  Future<void> onDropdownTapRegion() async {
    await fetchCitiesNames();
  }
  Future<void> onDropdownTapBooker() async {
   await fetchBookerNamesByNSMDesignation();
  }
  Future<void> onDropdownTapShop() async {
    await _checkUserIdAndFetchShopNames();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Visit Form'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAnimatedTextField('NSM Name', NSMNameController, Icons.person, readOnly: true),
            const SizedBox(height: 16),
            buildAnimatedDateField(currentDate),
            const SizedBox(height: 16),
            _buildAnimatedDropdown("Select City", citiesDropdownItems, Icons.location_on, regionController,onDropdownTapRegion),
            const SizedBox(height: 16),
            _buildAnimatedDropdown("Select Booker ID", bookersDropdownItems, Icons.book, bookerController, onDropdownTapBooker),
            const SizedBox(height: 16),
            _buildAnimatedDropdown("Select Shop", dropdownItems, Icons.store, shopController,onDropdownTapShop),
            const SizedBox(height: 16),
            _buildAnimatedFeedbackBox(),
            const SizedBox(height: 10),
            _buildGpsStatusWidget(),
            const SizedBox(height: 24),
            _buildAnimatedSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGpsStatusWidget() {
    return Row(
      children: [
        isLoadingLocation
            ? LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.green,
          size: 50.0,
        ) // Show loading indicator while fetching location
            : Checkbox(
          value: isGpsEnabled,
          onChanged: (bool? value) async {
            if (value == true) {
              // If checkbox is checked, call the function to save current location
              await saveCurrentLocation(context);
            } else {
              // If checkbox is unchecked, simply update the state
              setState(() {
                isGpsEnabled = false;
              });
            }
          },
        ),
        const Text(
          'GPS Enabled',
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildAnimatedTextField(String label, TextEditingController controller, IconData icon, {bool readOnly = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.green),
            labelText: label,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  buildAnimatedDateField(String currentDate) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: TextEditingController(text: currentDate),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.calendar_today, color: Colors.green),
            labelText: 'Date',
            border: InputBorder.none,
          ),
          readOnly: true,
        ),
      ),
    );
  }

  Widget _buildAnimatedDropdown(String label, List<String> items, IconData icon, TextEditingController controller, VoidCallback onTap) {
    return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DropdownSearch<String>(
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.green),
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            ),
          ),
          items: items,
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.green),
              labelText: label,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            ),
          ),
          onChanged: (value) {
            controller.text = value ?? '';
            setState(() {}); // Update the state to recheck the button enable status
          },
        ),
      ),
    ),
    );
  }

  Widget _buildAnimatedFeedbackBox() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Feedback or Note',
              style: TextStyle(
                color: Colors.green,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: feedbackController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your feedback here...',
              ),
              maxLines: 3,
              textInputAction: TextInputAction.newline,
              onChanged: (value) => setState(() {}), // Recheck button enable status
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  feedbackController.clear();
                },
                child: const Text(
                  'Clear',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSubmitButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: _isSubmitButtonEnabled()
            ? () async {
          await _handleLogin();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Form Submitted Successfully'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
            : null
        //     () {
        //   _showToast('Please fill all fields and make sure location is enabled.');
        // }
        , // Disable button if not enabled
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
          elevation: 8,
        ),
        child: const Text('Submit'),
      ),
    );
  }

  Future<void> _handleLogin() async {
    var id = await customAlphabet('1234567890', 10);
    await shopVisitViewModel.addHeadsShopVisit(HeadsShopVisitModel(
      id: int.parse(id),
      shopName: shopController.text,
      userId: userId,
      bookerName: NSMNameController.text,
      bookerId: bookerController.text,
      city: regionController.text,
      date: currentDate,
      feedback: feedbackController.text,
      address: address,
    ));
    await shopVisitViewModel.postHeadsShopVisit();
  }
}
