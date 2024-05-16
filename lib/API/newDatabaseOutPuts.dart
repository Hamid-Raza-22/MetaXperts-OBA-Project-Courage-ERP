import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Databases/DBHelper.dart';
import '../main.dart';
import 'ApiServices.dart';

class newDatabaseOutputs{
  Future<void> checkFirstRun() async {
    SharedPreferences SP = await SharedPreferences.getInstance();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstrun = SP.getBool('firstrun') ?? true;
    if(firstrun == true){
      await SP.setBool('firstrun', false);
      await initializeData();
      DateTime now = DateTime.now();
      String formattedDateTime = DateFormat('dd-MMM-yyyy-HH:mm:ss').format(now);
      await prefs.setString('lastInitializationDateTime', formattedDateTime);
      if (kDebugMode) {
        print(formattedDateTime);
      }
    }else{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? formattedDateTime = prefs.getString('lastInitializationDateTime');

      await updateAllDatabase();
      DateTime now = DateTime.now();
      formattedDateTime= DateFormat('dd-MMM-yyyy-HH:mm:ss').format(now);
      await prefs.setString('lastInitializationDateTime', formattedDateTime);

    //  await initializeData();
      if (kDebugMode) {
        print(formattedDateTime);
        print("UPDATING.......................................");
      }
    }
  }

  Future<void>  initializeData() async {
    final api = ApiServices();
    final db = DBHelper();


    var Productdata = await db.getProductsDB();
    var OrderMasterdata = await db.getOrderMasterDB();
    var OrderDetailsdata = await db.getOrderDetailsDB();
    // var NetBalancedata = await db.getNetBalanceDB();
    // var Accountsdata = await db.getAccoutsDB();
    var OrderBookingStatusdata= await db.getOrderBookingStatusDB();
    var Owerdata = await db.getOwnersDB();
    var Logindata = await db.getAllLogins();
    var PCdata = await db.getAllPCs();
    var RecoveryFormGetData = await db.getRecoverydataDB();

    //https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/muhammad_usman/login/get/
    // https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/login/get/
    // var username = 'yxeRFdCC0wjh1BYjXu1HFw..';
    // var password = 'KG-oKSMmf4DhqtFNmVtpMw..';

    if (Logindata == null || Logindata.isEmpty) {
      bool inserted = false;

      try {
        var response = await api.getApi("http://103.149.32.30:8080/ords/metaxperts/login/get/");
        inserted = await db.insertLogin(response);  // returns True or False

        if (inserted == true) {
          if (kDebugMode) {
            print("Login Data inserted successfully using first API.");
          }
        } else {
          throw Exception("Error inserting data using first API.");
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error with first API. Trying second API.");
        }

        try {
          var response = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/login/get/");
          inserted = await db.insertLogin(response);  // returns True or False

          if (inserted) {
            if (kDebugMode) {
              print("Login Data inserted successfully using second API.");
            }
          } else {
            if (kDebugMode) {
              print("Error inserting data using second API.");
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print("Error with second API as well. Unable to fetch or insert login data.");
          }
        }
      }
    }


    if (Owerdata == null || Owerdata.isEmpty ) {
      try {
        // https://apex.oracle.com/pls/apex/metaa/owner/get/
        //http://103.149.32.30:8080/ords/metaxperts/owner/get/
        var response = await api.getApi("https://apex.oracle.com/pls/apex/metaa/owner/get/");

        var results = await db.insertOwnerData(response);   //return True or False
        if (results) {
          if (kDebugMode) {
            print("Owner Data inserted successfully using first API..");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting data.");
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error with first API. Trying second API.");
        }
        var response = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/owner/get/");
        var results = await db.insertOwnerData(response);   //return True or False
        if (results) {
          if (kDebugMode) {
            print("Owner Data inserted successfully using second API..");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting data.");
          }
        }
      }
    } else {
      if (kDebugMode) {
        print("Data is available.");
      }
    }


    if (OrderBookingStatusdata == null || OrderBookingStatusdata.isEmpty ) {
      try {
        var response = await api.getApi("http://103.149.32.30:8080/ords/metaxperts/statusget/get/");
        var results = await db.insertOrderBookingStatusData1(response);   //return True or False
        if (results) {
          if (kDebugMode) {
            print("OrderBookingStatus Data inserted successfully using first API.");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting data.");
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error with first API. Trying second API.");
        }
        var response = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/statusget/get/");
        var results = await db.insertOrderBookingStatusData1(response);   //return True or False
        if (results) {
          if (kDebugMode) {
            print("OrderBookingStatus Data inserted successfully using second API..");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting data.");
          }
        }
      }
    }


    if (RecoveryFormGetData == null || RecoveryFormGetData.isEmpty ) {
      try {
        var response = await api.getApi("http://103.149.32.30:8080/ords/metaxperts/recovery/get/");

        var results1 = await db.insertRecoveryFormData1(response);   //return True or False
        if (results1) {
          if (kDebugMode) {
            print("RecoveryFormGetData Data inserted successfully using first API.");
          }
        } else {
          throw Exception('Insertion failed with first API');
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error with first API. Trying second API.");
        }
        var response= await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/recovery/get/");

        var results2 = await db.insertRecoveryFormData1(response);   //return True or False
        if (results2) {
          if (kDebugMode) {
            print("RecoveryFormGetData Data inserted successfully using second API.");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting data with both APIs.");
          }
        }
      }
    }

    if (OrderMasterdata == null || OrderMasterdata.isEmpty ) {
      try {
        var response1 = await api.getApi("http://103.149.32.30:8080/ords/metaxperts/masterget/get/");

        var results1 = await db.insertOrderMasterData1(response1);   //return True or False
        if (results1) {
          if (kDebugMode) {
            print("OrderMaster Data inserted successfully using first API.");
          }
        } else {
          throw Exception('Insertion failed with first API');
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error with first API. Trying second API.");
        }
        var response2 = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/masterget/get/");
        var results2 = await db.insertOrderMasterData1(response2);   //return True or False
        if (results2) {
          if (kDebugMode) {
            print("OrderMaster Data inserted successfully using second API.");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting data with both APIs.");
          }
        }
      }
    }


    if (OrderDetailsdata == null || OrderDetailsdata.isEmpty ) {
      try {
        var response1 = await api.getApi("http://103.149.32.30:8080/ords/metaxperts/detailget/get/");
        var results1 = await db.insertOrderDetailsData1(response1);   //return True or False
        if (results1) {
          if (kDebugMode) {
            print("OrderDetails Data inserted successfully using first API.");
          }
        } else {
          throw Exception('Insertion failed with first API');
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error with first API. Trying second API.");
        }
        var response2 = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/detailget/get/");
        var results2 = await db.insertOrderDetailsData1(response2);   //return True or False
        if (results2) {
          if (kDebugMode) {
            print("OrderDetails Data inserted successfully using second API.");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting data with both APIs.");
          }
        }
      }
    } else {
      if (kDebugMode) {
        print("Data is available.");
      }
    }


    if (Productdata == null || Productdata.isEmpty ) {
      try {
        var response1 = await api.getApi("http://103.149.32.30:8080/ords/metaxperts/product/get/");

        var results1 = await db.insertProductsData(response1);   //return True or False
        if (results1) {
          if (kDebugMode) {
            print("Products Data inserted successfully using first API.");
          }
        } else {
          throw Exception('Insertion failed with first API');
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error with first API. Trying second API.");
        }
        var response2 = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/product/get/");

        var results2 = await db.insertProductsData(response2);   //return True or False
        if (results2) {
          if (kDebugMode) {
            print("Products Data inserted successfully using second API.");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting data with both APIs.");
          }
        }
      }
    } else {
      if (kDebugMode) {
        print("Data is available.");
      }
    }

    // if (Distributordata == null || Distributordata.isEmpty ) {
    //   var response2 = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/distributorlist/get/");
    //   var results2 = await db.insertDistributorData(response2);   //return True or False
    //   if (results2) {
    //     print("Distributors Data inserted successfully.");
    //   } else {
    //     print("Error inserting data.");
    //   }
    // } else {
    //   print("Data is available.");
    // }

    if (PCdata == null || PCdata.isEmpty ) {
      try {
        var response1 = await api.getApi("http://103.149.32.30:8080/ords/metaxperts/brand/get/");
        var results1 = await db.insertProductCategory(response1);   //return True or False
        if (results1) {
          if (kDebugMode) {
            print("PC Data inserted successfully using first API.");
          }
        } else {
          throw Exception('Insertion failed with first API');
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error with first API. Trying second API.");
        }
        var response2 = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/brand/get/");

        var results2 = await db.insertProductCategory(response2);   //return True or False
        if (results2) {
          if (kDebugMode) {
            print("PC Data inserted successfully using second API.");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting data with both APIs.");
          }
        }
      }
    } else {
      if (kDebugMode) {
        print("Data is available.");
      }
    }

    //showAllTables();
  }

  Future<void> showAllTables() async {
    if (kDebugMode) {
      print("************Tables SHOWING**************");
    }
    if (kDebugMode) {
      print("************Tables Products**************");
    }
    final db = DBHelper();


    var data = await db.getProductsDB();
    int co = 0;
    for(var i in data!){
      co++;
      if (kDebugMode) {
        print("$co | ${i.toString()} \n");
      }
    }
    if (kDebugMode) {
      print("TOTAL of Products is $co");
    }

    if (kDebugMode) {
      print("************Tables Owners**************");
    }
    co=0;
    data = await db.getOwnersDB();
    for(var i in data!){
      co++;
      if (kDebugMode) {
        print("$co | ${i.toString()} \n");
      }
    }
    if (kDebugMode) {
      print("TOTAL of Owners is $co");
    }

    if (kDebugMode) {
      print("************Logins Owners**************");
    }
    co=0;
    data = await db.getAllLogins();
    for(var i in data!){
      co++;
      if (kDebugMode) {
        print("$co | ${i.toString()} \n");
      }
    }
    if (kDebugMode) {
      print("TOTAL of Logins is $co");
    }

    if (kDebugMode) {
      print("************ProductsCategories Owners**************");
    }
    co=0;
    data = await db.getAllPCs();
    for(var i in data!){
      co++;
      if (kDebugMode) {
        print("$co | ${i.toString()} \n");
      }
    }
    if (kDebugMode) {
      print("TOTAL of Products Categories is $co");
    }

    if (kDebugMode) {
      print("************Tables OrderMaster**************");
    }
    co=0;
    data = await db.getOrderMasterDB();
    for(var i in data!){
      co++;
      if (kDebugMode) {
        print("$co | ${i.toString()} \n");
      }
    }
    if (kDebugMode) {
      print("TOTAL of OrderMaster is $co");
    }

    if (kDebugMode) {
      print("************Tables Order Details**************");
    }
    co=0;
    data = await db.getOrderDetailsDB();
    for(var i in data!){
      co++;
      if (kDebugMode) {
        print("$co | ${i.toString()} \n");
      }
    }
    if (kDebugMode) {
      print("TOTAL of OrderDetails data is $co");
    }

    if (kDebugMode) {
      print("************Tables Order Booking Status**************");
    }
    co=0;
    data = await db.getOrderBookingStatusDB();
    for(var i in data!){
      co++;
      if (kDebugMode) {
        print("$co | ${i.toString()} \n");
      }
    }
    if (kDebugMode) {
      print("TOTAL of OrderBooking Status is $co");
    }

    if (kDebugMode) {
      print("TOTAL of netBalance is $co");
    }

    if (kDebugMode) {
      print("************Tables Net Balance**************");
    }
    co=0;
    data = await db.getNetBalanceDB();
    for(var i in data!){
      co++;
      if (kDebugMode) {
        print("$co | ${i.toString()} \n");
      }
    }
    if (kDebugMode) {
      print("TOTAL of Net Balance is $co");
    }

    if (kDebugMode) {
      print("************Tables Accounts**************");
    }
    co=0;
    data = await db.getAccoutsDB();
    for(var i in data!){
      co++;
      if (kDebugMode) {
        print("$co | ${i.toString()} \n");
      }
    }
    if (kDebugMode) {
      print("TOTAL of Accounts is $co");
    }


    if (kDebugMode) {
      print("************Tables Distributors**************");
    }
    co=0;
    data = await db.getDistributorsDB();
    for(var i in data!){
      co++;
      if (kDebugMode) {
        print("$co | ${i.toString()} \n");
      }
    }
    if (kDebugMode) {
      print("TOTAL of Distributors is $co");
    }

    if (kDebugMode) {
      print("************Tables Recovery Form Get**************");
    }
    co=0;
    data = await db.getRecoverydataDB();
    for(var i in data!){
      co++;
      if (kDebugMode) {
        print("$co | ${i.toString()} \n");
      }
    }
    if (kDebugMode) {
      print("TOTAL of Recovery Form Get is $co");
    }


  }
  Future<void> updateAllDatabase() async {
    await updateloginData();
    await updateOwnerData();
    // await updateorderBookingStatusData();
    // await updateproductCategoryData();
    // await updateProductsData();
    // await updateorderMasterData();
    // await updateorderDetailsData();
    // await updateaccountsData();
    // await updatenetBalanceData();
    // await updaterecoveryFormGetData();
  }

  Future<void> updateloginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? formattedDateTime = prefs.getString('lastInitializationDateTime');

    if (formattedDateTime != null) {
      String timedate = formattedDateTime;
      if (kDebugMode) {
        print(timedate);
      }
      final api = ApiServices();
      final db = DBHelper();
      var loginData = await api.getupdateData("http://103.149.32.30:8080/ords/metaxperts/logindata/get/$timedate");

      if (loginData != null && loginData.isNotEmpty) {
        bool inserted = await db.insertLogin(loginData);
        if (inserted) {
          if (kDebugMode) {
            print("login updated inserted successfully into local database.");
            print("Inserted data: $loginData");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting login updated into local database.");
          }
        }
      } else {
        if (kDebugMode) {
          print("No login updated data available for the timedate: $timedate");
        }
      }

    }
    else {
      // Handle the case where the value is not found in SharedPreferences
      if (kDebugMode) {
        print('No formatted date and time found in SharedPreferences');
      }
    }
  }  Future<void> updateOwnerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? formattedDateTime = prefs.getString('lastInitializationDateTime');

    if (formattedDateTime != null) {
      String timedate = formattedDateTime;
      if (kDebugMode) {
        print(timedate);
      }
      final api = ApiServices();
      final db = DBHelper();

      var ownerData = await api.getupdateData("http://103.149.32.30:8080/ords/metaxperts/shop1/get/$timedate");

      if (ownerData != null && ownerData.isNotEmpty) {
        bool inserted = await db.insertOwnerData(ownerData);
        if (inserted) {
          if (kDebugMode) {
            print("ownerData updated inserted successfully into local database.");
            print("Inserted data: $ownerData");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting ownerData updated into local database.");
          }
        }
      } else {
        if (kDebugMode) {
          print("No ownerData updated ownerData available for the timedate: $timedate");
        }
      }

    }
    else {
      // Handle the case where the value is not found in SharedPreferences
      if (kDebugMode) {
        print('No formatted date and time found in SharedPreferences');
      }
    }
  }  Future<void> updateProductsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? formattedDateTime = prefs.getString('lastInitializationDateTime');

    if (formattedDateTime != null) {
      String timedate = formattedDateTime;
      if (kDebugMode) {
        print(timedate);
      }
      final api = ApiServices();
      final db = DBHelper();

      var productsData = await api.getupdateData("http://103.149.32.30:8080/ords/metaxperts/login3/get/$timedate");

      if (productsData != null && productsData.isNotEmpty) {
        bool inserted = await db.insertProductsData(productsData);
        if (inserted) {
          if (kDebugMode) {
            print("productsData updated inserted successfully into local database.");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting productsData updated into local database.");
          }
        }
      } else {
        if (kDebugMode) {
          print("No productsData updated data available for the timedate: $timedate");
        }
      }

    }
    else {
      // Handle the case where the value is not found in SharedPreferences
      if (kDebugMode) {
        print('No formatted date and time found in SharedPreferences');
      }
    }
  }  Future<void> updateorderMasterData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? formattedDateTime = prefs.getString('lastInitializationDateTime');

    if (formattedDateTime != null) {
      String timedate = formattedDateTime;
      if (kDebugMode) {
        print(timedate);
      }
      final api = ApiServices();
      final db = DBHelper();

      var orderMasterData = await api.getupdateData("http://103.149.32.30:8080/ords/metaxperts/login3/get/$timedate");

      if (orderMasterData != null && orderMasterData.isNotEmpty) {
        bool inserted = await db.insertOrderMasterData1(orderMasterData);
        if (inserted) {
          if (kDebugMode) {
            print("orderMasterData updated inserted successfully into local database.");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting orderMasterData updated into local database.");
          }
        }
      } else {
        if (kDebugMode) {
          print("No orderMasterData updated data available for the timedate: $timedate");
        }
      }

    }
    else {
      // Handle the case where the value is not found in SharedPreferences
      if (kDebugMode) {
        print('No formatted date and time found in SharedPreferences');
      }
    }
  }  Future<void> updateorderDetailsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? formattedDateTime = prefs.getString('lastInitializationDateTime');

    if (formattedDateTime != null) {
      String timedate = formattedDateTime;
      if (kDebugMode) {
        print(timedate);
      }
      final api = ApiServices();
      final db = DBHelper();

      var orderDetailsData = await api.getupdateData("http://103.149.32.30:8080/ords/metaxperts/login3/get/$timedate");

      if (orderDetailsData != null && orderDetailsData.isNotEmpty) {
        bool inserted = await db.insertOrderDetailsData1(orderDetailsData);
        if (inserted) {
          if (kDebugMode) {
            print("orderDetailsData updated inserted successfully into local database.");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting orderDetailsData updated into local database.");
          }
        }
      } else {
        if (kDebugMode) {
          print("No orderDetailsData updated data available for the timedate: $timedate");
        }
      }

    }
    else {
      // Handle the case where the value is not found in SharedPreferences
      if (kDebugMode) {
        print('No formatted date and time found in SharedPreferences');
      }
    }
  }  Future<void> updateorderBookingStatusData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? formattedDateTime = prefs.getString('lastInitializationDateTime');

    if (formattedDateTime != null) {
      String timedate = formattedDateTime;
      if (kDebugMode) {
        print(timedate);
      }
      final api = ApiServices();
      final db = DBHelper();

      var orderBookingStatusData = await api.getupdateData("http://103.149.32.30:8080/ords/metaxperts/login3/get/$timedate");

      if (orderBookingStatusData != null && orderBookingStatusData.isNotEmpty) {
        bool inserted = await db.insertOrderBookingStatusData1(orderBookingStatusData);
        if (inserted) {
          if (kDebugMode) {
            print("login updated inserted successfully into local database.");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting login updated into local database.");
          }
        }
      } else {
        if (kDebugMode) {
          print("No login updated data available for the timedate: $timedate");
        }
      }

    }
    else {
      // Handle the case where the value is not found in SharedPreferences
      if (kDebugMode) {
        print('No formatted date and time found in SharedPreferences');
      }
    }
  }  Future<void> updatenetBalanceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? formattedDateTime = prefs.getString('lastInitializationDateTime');

    if (formattedDateTime != null) {
      String timedate = formattedDateTime;
      if (kDebugMode) {
        print(timedate);
      }
      final api = ApiServices();
      final db = DBHelper();

      var netBalance = await api.getupdateData("http://103.149.32.30:8080/ords/metaxperts/login3/get/$timedate");

      if (netBalance != null && netBalance.isNotEmpty) {
        bool inserted = await db.insertNetBalanceData(netBalance);
        if (inserted) {
          if (kDebugMode) {
            print("netBalance updated inserted successfully into local database.");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting netBalance updated into local database.");
          }
        }
      } else {
        if (kDebugMode) {
          print("No netBalance updated data available for the timedate: $timedate");
        }
      }

    }
    else {
      // Handle the case where the value is not found in SharedPreferences
      if (kDebugMode) {
        print('No formatted date and time found in SharedPreferences');
      }
    }
  }  Future<void> updateaccountsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? formattedDateTime = prefs.getString('lastInitializationDateTime');

    if (formattedDateTime != null) {
      String timedate = formattedDateTime;
      if (kDebugMode) {
        print(timedate);
      }
      final api = ApiServices();
      final db = DBHelper();

      var accounts = await api.getupdateData("http://103.149.32.30:8080/ords/metaxperts/login3/get/$timedate");

      if (accounts != null && accounts.isNotEmpty) {
        bool inserted = await db.insertAccoutsData(accounts);
        if (inserted) {
          if (kDebugMode) {
            print("accounts updated inserted successfully into local database.");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting accounts updated into local database.");
          }
        }
      } else {
        if (kDebugMode) {
          print("No accounts updated data available for the timedate: $timedate");
        }
      }

    }
    else {
      // Handle the case where the value is not found in SharedPreferences
      if (kDebugMode) {
        print('No formatted date and time found in SharedPreferences');
      }
    }
  }  Future<void> updateproductCategoryData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? formattedDateTime = prefs.getString('lastInitializationDateTime');

    if (formattedDateTime != null) {
      String timedate = formattedDateTime;
      if (kDebugMode) {
        print(timedate);
      }
      final api = ApiServices();
      final db = DBHelper();

      var productCategory = await api.getupdateData("http://103.149.32.30:8080/ords/metaxperts/login3/get/$timedate");
    if (productCategory != null && productCategory.isNotEmpty) {
        bool inserted = await db.insertProductCategory(productCategory);
        if (inserted) {
          if (kDebugMode) {
            print("productCategory updated inserted successfully into local database.");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting productCategory updated into local database.");
          }
        }
      } else {
        if (kDebugMode) {
          print("No productCategory updated data available for the timedate: $timedate");
        }
      }

    }
    else {
      // Handle the case where the value is not found in SharedPreferences
      if (kDebugMode) {
        print('No formatted date and time found in SharedPreferences');
      }
    }
  }  Future<void> updaterecoveryFormGetData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? formattedDateTime = prefs.getString('lastInitializationDateTime');

    if (formattedDateTime != null) {
      String timedate = formattedDateTime;
      if (kDebugMode) {
        print(timedate);
      }
      final api = ApiServices();
      final db = DBHelper();
  var recoveryFormGet = await api.getupdateData("http://103.149.32.30:8080/ords/metaxperts/login3/get/$timedate");
      if (recoveryFormGet != null && recoveryFormGet.isNotEmpty) {
        bool inserted = await db.insertRecoveryFormData1(recoveryFormGet);
        if (inserted) {
          if (kDebugMode) {
            print("recoveryFormGet updated inserted successfully into local database.");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting recoveryFormGet updated into local database.");
          }
        }
      } else {
        if (kDebugMode) {
          print("No recoveryFormGet updated data available for the timedate: $timedate");
        }
      }

    }
    else {
      // Handle the case where the value is not found in SharedPreferences
      if (kDebugMode) {
        print('No formatted date and time found in SharedPreferences');
      }
    }
  }

  Future<void> checkupdate() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? formattedDateTime = prefs.getString('lastInitializationDateTime');

    if (formattedDateTime != null) {
      String timedate = formattedDateTime;
      if (kDebugMode) {
        print(timedate);
      }

  }
  }
  Future<void> update() async {
    final db = DBHelper();
    if (kDebugMode) {
      print("DELETING.......................................");
    }
    await isInternetAvailable();

    //await db.deleteAllRecords();

  }

}