import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mutex/mutex.dart';
import 'package:order_booking_shop/Databases/DBHelper.dart';
class PostingStatus {
  static final ValueNotifier<bool> isPosting = ValueNotifier<bool>(false);
}

DBHelper dbHelper = DBHelper();
String currentPostId= "";
bool _isPosting = false;
dynamic version = "v: 0.9.3";
String pending ="PENDING";
String SellectedproductName= "";
double? globalnetBalance;
String selectedShopCity= '';
String userDesignation = "";
String userBrand = "";
int? highestSerial;
int? RecoveryhighestSerial;
String userNames = "";
dynamic userNSM = "";
dynamic userRSM = "";
dynamic userSM = "";
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
String shopAddress = "";
bool locationbool = true;
//dynamic serialCounter ='';
String globalcurrentMonth= DateFormat('MMM').format(DateTime.now());

List<String>? cachedShopNames =[];

