import 'dart:async';

import 'package:intl/intl.dart';
import 'package:order_booking_shop/Databases/DBHelper.dart';
DBHelper dbHelper = DBHelper();

int? highestSerial;
int? RecoveryhighestSerial;
String userNames = "";
String username= "";
String username2="";
String userId= "";
String userCitys= "";
String orderno= "";
String Receipt = "REC";
String globalselectedbrand= "";
String orderMasterid= "";
bool isClockedIn = false;
late Timer timer;
int secondsPassed=0;
String selectedorderno ="";
String globalselectedimageurl ="";
String userid="95";
String checkbox1="";
String checkbox2="";
String checkbox3="";
String checkbox4="";
String shopName="";
String OrderMasterid= "";
String address = "";
bool locationbool = true;
//dynamic serialCounter ='';
String globalcurrentMonth= DateFormat('MMM').format(DateTime.now());

