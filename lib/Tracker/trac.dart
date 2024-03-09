import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nanoid/nanoid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../API/Globals.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import '../Databases/DBHelper.dart';
import '../Models/LocationModel.dart';

import '../View_Models/LocationViewModel.dart';

var gpx;
var track;
var segment;
var trkpt;
var longi;
var lat;
final locationViewModel = Get.put(LocationViewModel());
String gpxString="";

Future<void> startTimer() async {
  startTimerFromSavedTime();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Timer.periodic(Duration(seconds: 1), (timer) async {
    secondsPassed++;
    await prefs.setInt('secondsPassed', secondsPassed);
  });
}

void startTimerFromSavedTime() {
  SharedPreferences.getInstance().then((prefs) async {
    String savedTime = prefs.getString('savedTime') ?? '00:00:00';
    List<String> timeComponents = savedTime.split(':');
    int hours = int.parse(timeComponents[0]);
    int minutes = int.parse(timeComponents[1]);
    int seconds = int.parse(timeComponents[2]);
    int totalSavedSeconds = hours * 3600 + minutes * 60 + seconds;
    final now = DateTime.now();
    int totalCurrentSeconds = now.hour * 3600 + now.minute * 60 + now.second;
    secondsPassed = totalCurrentSeconds - totalSavedSeconds;
    if (secondsPassed < 0) {
      secondsPassed = 0;
    }
    await prefs.setInt('secondsPassed', secondsPassed);
    print("Loaded Saved Time");
  });
}



Future<void> postFile() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  double totalDistance = pref.getDouble("TotalDistance") ?? 0.0;
  pref.setDouble("TotalDistance", totalDistance);
  print('Distance:$totalDistance');
  final date = DateFormat('dd-MM-yyyy').format(DateTime.now());
  // final downloadDirectory = await getDownloadsDirectory();
  // final filePath = File('${downloadDirectory?.path}/track$date.gpx');

  final downloadDirectory = await getDownloadsDirectory();
  final gpxFilePath = '${downloadDirectory!.path}/track$date.gpx';
  final maingpxFile = File(gpxFilePath);
  // Read the GPX file
  List<int> gpxBytesList = await maingpxFile.readAsBytes();
  Uint8List gpxBytes = Uint8List.fromList(gpxBytesList);
  var id = await customAlphabet('1234567890', 10);
  if (!maingpxFile.existsSync()) {
    print('GPX file does not exist');
    return;
  }
  locationViewModel.addLocation(LocationModel(
    id: int.parse(id),
    userId: userId,
    userName: userNames,
    totalDistance: pref.getDouble("TotalDistance").toString(),
    fileName: "${_getFormattedDate1()}.gpx",
    date: _getFormattedDate1(),
   body: gpxBytes,
  ));
  print(userId);
  print(userid);
  print(userNames);
   postLocationData();
    // var request = http.MultipartRequest("POST",
    //     Uri.parse(
    //         "https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/location/post/"));
    // var gpxFile = await http.MultipartFile.fromPath('body', filePath.path);
    // request.files.add(gpxFile);
    //
    // // Add other fields if needed
    // request.fields['userId'] = pref.getString('userId') ?? "";
    // request.fields['userName'] = pref.getString('userNames') ?? "";
    // request.fields['fileName'] = "${_getFormattedDate1()}.gpx";
    // request.fields['date'] = _getFormattedDate1();
    // request.fields['totalDistance'] = "${totalDistance.toString()} KM"; // Add totalDistance as a field
    //
    // try {
    //   var response = await request.send();
    //   if (response.statusCode == 200) {
    //     var responseData = await response.stream.toBytes();
    //     var result = String.fromCharCodes(responseData);
    //     print("Results: Post Successfully");
    //
    //     // Save the current post ID
    //     pref.setString('postId', currentPostId);
    //
    //     //deleteGPXFile();
    //     pref.setDouble("TotalDistance", totalDistance);
    //     print('Distance:$totalDistance');
    //   } else {
    //     print("Failed to upload file. Status code: ${response.statusCode}");
    //   }
    // } catch (e) {
    //   print("Error: $e");
    // }
  }
Future<void> postLocationData() async {
  DBHelper dbHelper = DBHelper();
  await dbHelper.postlocationdata();
}


String _getFormattedDate1() {
  final now = DateTime.now();
  final formatter = DateFormat('dd-MMM-yyyy  [hh:mm a] ');
  return formatter.format(now);
}
// Total distance is stored in the shared Prefernces "TotalDistance" when the user clock out.