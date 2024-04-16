
import 'package:shared_preferences/shared_preferences.dart';
import '../Databases/DBHelper.dart';
import '../main.dart';
import 'ApiServices.dart';

class DatabaseOutputs{
  Future<void> checkFirstRun() async {
    SharedPreferences SP = await SharedPreferences.getInstance();
    bool firstrun = await SP.getBool('firstrun') ?? true;
    if(firstrun == true){

      await SP.setBool('firstrun', false);
      await initializeData();
    }else{
      print("UPDATING.......................................");
      await update();
     await initializeData();
    }
  }
  Future<void> checkFirstRunAccounts() async {
    SharedPreferences SP = await SharedPreferences.getInstance();
    bool firstrun = await SP.getBool('firstrun') ?? true;
    if(firstrun == true){

      await SP.setBool('firstrun', false);
      await initializeData2();
    }else{
      print("UPDATING.......................................");
      await update2();
      await initializeData2();
    }
  }
  Future<void> check_OB() async{
    SharedPreferences SP = await SharedPreferences.getInstance();
    bool firstrun = await SP.getBool('firstrun') ?? true;
    if(firstrun == true){
      await initializeData();
      await SP.setBool('firstrun', false);
    }else{
      print("UPDATING.......................................");
      await update_orderbooking_status();
      initialize_orderbooking_status();
    }
  }
  Future<void> update_orderbooking_status() async{
    final db= DBHelper();
    print("DELETING.......................................");
    await db.deleteAllRecords();
  }
  void initialize_orderbooking_status() async{
    final api = ApiServices();
    final db= DBHelper();
    var OrderBookingStatusdata= await db.getOrderBookingStatusDB();

    //
    // if (OrderBookingStatusdata == null || OrderBookingStatusdata.isEmpty ) {
    //   var response2 = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/statusget/get/");
    //   var results2 = await db.insertOrderBookingStatusData(response2);   //return True or False
    //   if (results2) {
    //     print("Data inserted successfully.");
    //   } else {
    //     print("Error inserting data.");
    //   }
    // } else {
    //   print("Data is available.");
    // }
  }
  Future<void> initializeDatalogin() async {
    final api = ApiServices();
    final db = DBHelper();

    // Get existing data from local database
    // var Logindata = Set<Map<String, dynamic>>.from((await db.getAllLogins()) ?? []);
    var Owerdata = Set<Map<String, dynamic>>.from((await db.getOwnersDB()) ?? []);
    // var OrderBookingStatusdata = Set<Map<String, dynamic>>.from((await db.getOrderBookingStatusDB()) ?? []);
    // var RecoveryFormGetData = Set<Map<String, dynamic>>.from((await db.getRecoverydataDB()) ?? []);
    // var OrderMasterdata = Set<Map<String, dynamic>>.from((await db.getOrderMasterDB()) ?? []);
    // var OrderDetailsdata = Set<Map<String, dynamic>>.from((await db.getOrderDetailsDB()) ?? []);
    // var Productdata = Set<Map<String, dynamic>>.from((await db.getProductsDB()) ?? []);
    // var PCdata = Set<Map<String, dynamic>>.from((await db.getAllPCs()) ?? []);

    // Get data from API
   // var responseLogin = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/login/get/");
    var responseOwner = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/owner/get/");
    var responseOwner3 = await api.getApi("http://103.149.32.30:8080/ords/metaxperts/owner/get/");
    // var responseOrderBookingStatusdata = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/statusget/get/");
    // var responseRecoveryFormGetData = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/recovery/get/");
    // var responseOrderMasterdata = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/masterget/get/");
    // var responseOrderDetailsdata= await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/detailget/get/");
    // var responseProductdata = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/product/get/");
    // var responsePC = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/brand/get/");

    // // Convert API responses to sets for efficient operations
    // var apiLoginData = Set<Map<String, dynamic>>.from(responseLogin);
    // var apiOwnerData = Set<Map<String, dynamic>>.from(responseOwner);
    //  var apiOrderBookingStatusdata = Set<Map<String, dynamic>>.from(responseOrderBookingStatusdata);
    // var apiRecoveryFormGetData = Set<Map<String, dynamic>>.from(responseRecoveryFormGetData);
    // var apiOrderMasterdata = Set<Map<String, dynamic>>.from(responseOrderMasterdata);
    // var apiOrderDetailsdata = Set<Map<String, dynamic>>.from(responseOrderDetailsdata);
    // var apiProductdata = Set<Map<String, dynamic>>.from(responseProductdata);
    // var apiPCdata = Set<Map<String, dynamic>>.from(responsePC);
    //
    // // ... other API data sets ...
    // Get existing data from local database
    // var localLoginData = Set<Map<String, dynamic>>.from((await db.getAllLogins()) ?? []);
    //var localOwnerData = Set<Map<String, dynamic>>.from((await db.getOwnersDB()) ?? []);
    //  var localOrderBookingStatusdata = Set<Map<String, dynamic>>.from((await db.getOrderBookingStatusDB()) ?? []);
    // var localRecoveryFormGetData = Set<Map<String, dynamic>>.from((await db.getRecoverydataDB()) ?? []);
    // var localOrderMasterdata = Set<Map<String, dynamic>>.from((await db.getOrderMasterDB()) ?? []);
    // var localOrderDetailsdata = Set<Map<String, dynamic>>.from((await db.getOrderDetailsDB()) ?? []);
    // var localProductdata = Set<Map<String, dynamic>>.from((await db.getProductsDB()) ?? []);
    // var localPCdata = Set<Map<String, dynamic>>.from((await db.getAllPCs()) ?? []);
    // ... other local data sets ...
    // Find items to delete: items that are in local data but not in API data
    // var loginItemsToDelete = localLoginData.difference(apiLoginData);
    // var ownerItemsToDelete = localOwnerData.difference(apiOwnerData);
    //  var orderbookingstatusItemsToDelete = localOrderBookingStatusdata.difference(apiOrderBookingStatusdata);
    // var recoveryItemsToDelete = localRecoveryFormGetData.difference(apiRecoveryFormGetData);
    // var ordermasterItemsToDelete = localOrderMasterdata.difference(apiOrderMasterdata);
    // var orderdetailsToDelete = localOrderDetailsdata.difference(apiOrderDetailsdata);
    // var productsitemsToDelete = localProductdata.difference(apiProductdata);
    // var pcitemsToDelete = localPCdata.difference(apiPCdata);



    // ... other items to delete ...
    /// Process login data
// Process login data
//     for (var item in responseLogin) {
//       // Check if item already exists in local data
//       Map<String, dynamic>? existingItem;
//       try {
//         existingItem = Logindata.firstWhere((element) => element['user_id'] == item['user_id']);
//       } catch (e) {
//         existingItem = null;
//       }
//
//       if (existingItem == null) {
//         // If item does not exist, insert it
//         var results3 = await db.insertLogin([item]);
//         if (results3) {
//           print("Login Data inserted successfully.");
//           // Delete items from local database
//           // for (var item in loginItemsToDelete) {
//           //   await db.deleteLogin(item);
//           // }
//         } else {
//           print("Error inserting data.");
//         }
//       } else {
//         // If item exists, update it
//         var results3 = await db.updateLogin(item);
//         if (results3 != null && results3 > 0) {
//           print("Login Data updated successfully.");
//         } else {
//           print("Error updating data.");
//         }
//       }
//
//     }
    // Decide which API response to use
    var chosenResponse = responseOwner ?? responseOwner3;


// Process owner data
    if (chosenResponse != null) {
      // Process owner data
      for (var item in chosenResponse) {
        Map<String, dynamic>? existingItem;
        try {
          existingItem = Owerdata.firstWhere((element) => element['id'] == item['id']);
        } catch (e) {
          existingItem = null;
        }

        if (existingItem == null) {
          var results2 = await db.insertOwnerData([item]);
          var results3 = await db.insertOwnerData([item]);
          if (results2 && results3) {
            print("Owner Data inserted successfully.");
          } else {
            print("Error inserting data.");
          }
        } else {
          var results2 = await db.updateOwner(item);
          if (results2 > 0) {
            print(" Owner Data updated successfully.");
          } else {
            print("Error updating data.");
          }
        }
      }
    } else {
      print("Unable to fetch data from both APIs.");
    }

 //    // Process order Booking Status
 //    for (var item in responseOrderBookingStatusdata) {
 //      // Check if item already exists in local data
 //     // var existingItem = OrderBookingStatusdata?.firstWhere((element) => element['order_no'] == item['order_no'], orElse: () => {});
 //      Map<String, dynamic>? existingItem;
 //      try {
 //        existingItem = OrderBookingStatusdata.firstWhere((element) => element['order_no'] == item['order_no']);
 //      } catch (e) {
 //        existingItem = null;
 //      }
 //
 //      if (existingItem == null) {
 //
 //      //if (existingItem == null || existingItem.isEmpty) {
 //        // If item does not exist, insert it
 //        var results = await db.insertOrderBookingStatusData([item]);
 //        if (results) {
 //          print("order Booking Status Data inserted successfully.");
 //        } else {
 //          print("Error inserting data.");
 //        }
 //      } else {
 //        // If item exists, update it
 //        var results2 = await db.updateOrderBookingStutsData(item);
 //        if (results2 > 0) {
 //          print(" order Booking Status Data updated successfully.");
 //        } else {
 //          print("Error updating data.");
 //        }
 //      }
 //    }
 //    // Process RecoveryFormGetData
 //    for (var item in responseRecoveryFormGetData) {
 //      // Check if item already exists in local data
 //      //var existingItem = RecoveryFormGetData?.firstWhere((element) => element['recovery_id'] == item['recovery_id'], orElse: () => {});
 //      Map<String, dynamic>? existingItem;
 //      try {
 //        existingItem = RecoveryFormGetData.firstWhere((element) => element['recovery_id'] == item['recovery_id']);
 //      } catch (e) {
 //        existingItem = null;
 //      }
 //
 //      if (existingItem == null) {
 //
 //     // if (existingItem == null || existingItem.isEmpty) {
 //        // If item does not exist, insert it
 //        var results = await db.insertRecoveryFormData([item]);
 //        if (results) {
 //          print("RecoveryFormGetData inserted successfully.");
 //        } else {
 //          print("Error inserting data.");
 //        }
 //      } else {
 //        // If item exists, update it
 //        var results2 = await db.updateRecoveryFormGetData(item);
 //        if (results2 > 0) {
 //          print(" RecoveryFormGetData updated successfully.");
 //        } else {
 //          print("Error updating data.");
 //        }
 //      }
 //    }
 //    // Process OrderMasterdata
 //    for (var item in responseOrderMasterdata) {
 //      // Check if item already exists in local data
 //    //  var existingItem = OrderMasterdata?.firstWhere((element) => element['order_no'] == item['order_no'], orElse: () => {});
 //      Map<String, dynamic>? existingItem;
 //      try {
 //        existingItem = OrderMasterdata.firstWhere((element) => element['order_no'] == item['order_no']);
 //      } catch (e) {
 //        existingItem = null;
 //      }
 //
 //      if (existingItem == null) {
 //
 //   //   if (existingItem == null || existingItem.isEmpty) {
 //        // If item does not exist, insert it
 //        var results = await db.insertOrderMasterData([item]);
 //        if (results) {
 //          print("OrderMaster Data inserted successfully.");
 //        } else {
 //          print("Error inserting data.");
 //        }
 //      } else {
 //        // If item exists, update it
 //        var results2 = await db.updateOrderMasterData(item);
 //        if (results2 > 0) {
 //          print(" OrderMaster Data updated successfully.");
 //        } else {
 //          print("Error updating data.");
 //        }
 //      }
 //    }
 //    // Process OrderDetailsdata
 //    for (var item in responseOrderDetailsdata) {
 //      // Check if item already exists in local data
 //     // var existingItem = OrderDetailsdata?.firstWhere((element) => element['id'] == item['id'], orElse: () => {});
 //      Map<String, dynamic>? existingItem;
 //      try {
 //        existingItem = OrderDetailsdata.firstWhere((element) => element['id'] == item['id']);
 //      } catch (e) {
 //        existingItem = null;
 //      }
 //
 //      if (existingItem == null) {
 //     // if (existingItem == null || existingItem.isEmpty) {
 //        // If item does not exist, insert it
 //        var results = await db.insertOrderDetailsData([item]);
 //        if (results) {
 //          print("OrderDetailsdata Data inserted successfully.");
 //        } else {
 //          print("Error inserting data.");
 //        }
 //      } else {
 //        // If item exists, update it
 //        var results2 = await db.updateOrderDetailsdata(item);
 //        if (results2 > 0) {
 //          print(" OrderDetailsdataData updated successfully.");
 //        } else {
 //          print("Error updating data.");
 //        }
 //      }
 //    }
 //    // Process Productdata
 //    for (var item in responseProductdata) {
 //      // Check if item already exists in local data
 //      //var existingItem = Productdata?.firstWhere((element) => element['id'] == item['id'], orElse: () => {});
 //      Map<String, dynamic>? existingItem;
 //      try {
 //        existingItem = Productdata.firstWhere((element) => element['id'] == item['id']);
 //      } catch (e) {
 //        existingItem = null;
 //      }
 //
 //      if (existingItem == null) {
 //
 //     // if (existingItem == null || existingItem.isEmpty) {
 //        // If item does not exist, insert it
 //        var results = await db.insertProductsData([item]);
 //        if (results) {
 //          print("OrderDetailsdata Data inserted successfully.");
 //        } else {
 //          print("Error inserting data.");
 //        }
 //      } else {
 //        // If item exists, update it
 //        var results2 = await db.updateProductdata(item);
 //        if (results2 > 0) {
 //          print(" OrderDetailsdataData updated successfully.");
 //        } else {
 //          print("Error updating data.");
 //        }
 //      }
 //    }
 //    // Process ProductCategory data
 //    for (var item in responsePC) {
 //      // Check if item already exists in local data
 //     // var existingItem = PCdata?.firstWhere((element) => element['id'] == item['id'], orElse: () => {});
 //      Map<String, dynamic>? existingItem;
 //      try {
 //        existingItem = PCdata.firstWhere((element) => element['id'] == item['id']);
 //      } catch (e) {
 //        existingItem = null;
 //      }
 //
 //      if (existingItem == null) {
 //
 //     // if (existingItem == null || existingItem.isEmpty) {
 //        // If item does not exist, insert it
 //        var results = await db.insertProductCategory([item]);
 //        if (results) {
 //          print("ProductCategorydata inserted successfully.");
 //        } else {
 //          print("Error inserting data.");
 //        }
 //      } else {
 //        // If item exists, update it
 //        var results2 = await db.updateProductCategorydata(item);
 //        if (results2 > 0) {
 //          print(" ProductCategorydata updated successfully.");
 //        } else {
 //          print("Error updating data.");
 //        }
 //      }
 //    }
 //
 // //   Delete items from local database
 //    for (var item in orderbookingstatusItemsToDelete) {
 //      await db.deleteOrderBookingStutsData(item);
 //    }
    // // Delete items from local database
    // for (var item in recoveryItemsToDelete) {
    //   await db.deleteRecoveryFormGetData(item);
    // }
    // // Delete items from local database
    // for (var item in ordermasterItemsToDelete) {
    //   await db.deleteOrderMasterData(item);
    // }
    // // Delete items from local database
    // for (var item in orderdetailsToDelete) {
    //   await db.deleteOrderDetailsdata(item);
    // }
    // // Delete items from local database
    // for (var item in productsitemsToDelete) {
    //   await db.deleteProductdata(item);
    // }
    // // Delete items from local database
    // for (var item in pcitemsToDelete) {
    //   await db.deleteProductCategorydata(item);
    // }
    showAllTables();

  }

  Future<void>  initializeData() async {
    final api = ApiServices();
    final db = DBHelper();


    var Productdata = await db.getProductsDB();
    var OrderMasterdata = await db.getOrderMasterDB();
    var OrderDetailsdata = await db.getOrderDetailsDB();
    var NetBalancedata = await db.getNetBalanceDB();
    var Accountsdata = await db.getAccoutsDB();
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
        var response = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/login/get/");
        inserted = await db.insertLogin(response);  // returns True or False

        if (inserted) {
          print("Login Data inserted successfully using first API.");
        } else {
          print("Error inserting data using first API.");
        }
      } catch (e) {
        print("Error with first API. Trying second API.");

        try {
          var response = await api.getApi("http://103.149.32.30:8080/ords/metaxperts/login/get/");
          inserted = await db.insertLogin(response);  // returns True or False

          if (inserted) {
            print("Login Data inserted successfully using second API.");
          } else {
            print("Error inserting data using second API.");
          }
        } catch (e) {
          print("Error with second API as well. Unable to fetch or insert login data.");
        }
      }
    }


    if (Owerdata == null || Owerdata.isEmpty ) {
      try {
        var response = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/owner/get/");
        var results = await db.insertOwnerData(response);   //return True or False
        if (results) {
          print("Owner Data inserted successfully using first API..");
        } else {
          print("Error inserting data.");
        }
      } catch (e) {
        print("Error with first API. Trying second API.");
        var response = await api.getApi("http://103.149.32.30:8080/ords/metaxperts/owner/get/");
        var results = await db.insertOwnerData(response);   //return True or False
        if (results) {
          print("Owner Data inserted successfully using second API..");
        } else {
          print("Error inserting data.");
        }
      }
    } else {
      print("Data is available.");
    }


    // if (Accountsdata == null || Accountsdata.isEmpty ) {
    //   var response2 = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/account/get/");
    //   var results2 = await db.insertAccoutsData(response2);   //return True or False
    //   if (results2) {
    //     print("Accounts Data inserted successfully.");
    //   } else {
    //     print("Error inserting data.");
    //   }
    // } else {
    //   print("Data is available.");
    // }
    //
    //
    // if (NetBalancedata == null || NetBalancedata.isEmpty ) {
    //   var response2 = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/balance/get/");
    //   var results2 = await db.insertNetBalanceData(response2);   //return True or False
    //   if (results2) {
    //     print(" Net Balance Data inserted successfully.");
    //   } else {
    //     print("Error inserting data.");
    //   }
    // } else {
    //   print("Data is available.");
    // }

    if (OrderBookingStatusdata == null || OrderBookingStatusdata.isEmpty ) {
      try {
        var response = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/statusget/get/");
        var results = await db.insertOrderBookingStatusData1(response);   //return True or False
        if (results) {
          print("OrderBookingStatus Data inserted successfully using first API.");
        } else {
          print("Error inserting data.");
        }
      } catch (e) {
        print("Error with first API. Trying second API.");
        var response = await api.getApi("http://103.149.32.30:8080/ords/metaxperts/statusget/get/");
        var results = await db.insertOrderBookingStatusData1(response);   //return True or False
        if (results) {
          print("OrderBookingStatus Data inserted successfully using second API..");
        } else {
          print("Error inserting data.");
        }
      }
    } else {
      print("Data is available.");
    }


    if (RecoveryFormGetData == null || RecoveryFormGetData.isEmpty ) {
      try {
        var response1 = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/recovery/get/");
        var results1 = await db.insertRecoveryFormData1(response1);   //return True or False
        if (results1) {
          print("RecoveryFormGetData Data inserted successfully using first API.");
        } else {
          throw Exception('Insertion failed with first API');
        }
      } catch (e) {
        print("Error with first API. Trying second API.");
        var response2 = await api.getApi("http://103.149.32.30:8080/ords/metaxperts/recovery/get/");
        var results2 = await db.insertRecoveryFormData1(response2);   //return True or False
        if (results2) {
          print("RecoveryFormGetData Data inserted successfully using second API.");
        } else {
          print("Error inserting data with both APIs.");
        }
      }
    } else {
      print("Data is available.");
    }


    if (OrderMasterdata == null || OrderMasterdata.isEmpty ) {
      try {
        var response1 = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/masterget/get/");
        var results1 = await db.insertOrderMasterData1(response1);   //return True or False
        if (results1) {
          print("OrderMaster Data inserted successfully using first API.");
        } else {
          throw Exception('Insertion failed with first API');
        }
      } catch (e) {
        print("Error with first API. Trying second API.");
        var response2 = await api.getApi("http://103.149.32.30:8080/ords/metaxperts/masterget/get/");
        var results2 = await db.insertOrderMasterData1(response2);   //return True or False
        if (results2) {
          print("OrderMaster Data inserted successfully using second API.");
        } else {
          print("Error inserting data with both APIs.");
        }
      }
    } else {
      print("Data is available.");
    }


    if (OrderDetailsdata == null || OrderDetailsdata.isEmpty ) {
      try {
        var response1 = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/detailget/get/");
        var results1 = await db.insertOrderDetailsData1(response1);   //return True or False
        if (results1) {
          print("OrderDetails Data inserted successfully using first API.");
        } else {
          throw Exception('Insertion failed with first API');
        }
      } catch (e) {
        print("Error with first API. Trying second API.");
        var response2 = await api.getApi("http://103.149.32.30:8080/ords/metaxperts/detailget/get/");
        var results2 = await db.insertOrderDetailsData1(response2);   //return True or False
        if (results2) {
          print("OrderDetails Data inserted successfully using second API.");
        } else {
          print("Error inserting data with both APIs.");
        }
      }
    } else {
      print("Data is available.");
    }


    if (Productdata == null || Productdata.isEmpty ) {
      try {
        var response1 = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/product/get/");
        var results1 = await db.insertProductsData(response1);   //return True or False
        if (results1) {
          print("Products Data inserted successfully using first API.");
        } else {
          throw Exception('Insertion failed with first API');
        }
      } catch (e) {
        print("Error with first API. Trying second API.");
        var response2 = await api.getApi("http://103.149.32.30:8080/ords/metaxperts/product/get/");
        var results2 = await db.insertProductsData(response2);   //return True or False
        if (results2) {
          print("Products Data inserted successfully using second API.");
        } else {
          print("Error inserting data with both APIs.");
        }
      }
    } else {
      print("Data is available.");
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
        var response1 = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/brand/get/");
        var results1 = await db.insertProductCategory(response1);   //return True or False
        if (results1) {
          print("PC Data inserted successfully using first API.");
        } else {
          throw Exception('Insertion failed with first API');
        }
      } catch (e) {
        print("Error with first API. Trying second API.");
        var response2 = await api.getApi("http://103.149.32.30:8080/ords/metaxperts/brand/get/");
        var results2 = await db.insertProductCategory(response2);   //return True or False
        if (results2) {
          print("PC Data inserted successfully using second API.");
        } else {
          print("Error inserting data with both APIs.");
        }
      }
    } else {
      print("Data is available.");
    }

    showAllTables();
  }

  Future<void>  initializeData2() async {
    final api = ApiServices();
    final db= DBHelper();


    var NetBalancedata = await db.getNetBalanceDB();
    var Accountsdata = await db.getAccoutsDB();
    var OrderBookingStatusdata = Set<Map<String, dynamic>>.from((await db.getOrderBookingStatusDB()) ?? []);

    if (OrderBookingStatusdata == null || OrderBookingStatusdata.isEmpty ) {
      var response2 = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/statusget/get/");
      var response3 = await api.getApi("http://103.149.32.30:8080/ords/metaxperts/statusget/get/");
      var results2 = await db.insertOrderBookingStatusData(response2);   //return True or False
      var results3 = await db.insertOrderBookingStatusData(response3);   //return True or False
      if (results2 && results3) {
        print("OrderBookingStatus Data inserted successfully.");
      } else {
        print("Error inserting data.");
      }
    } else {
      print("Data is available.");
    }
    if (Accountsdata == null || Accountsdata.isEmpty ) {
      var response2 = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/account/get/");
      var response3 = await api.getApi("http://103.149.32.30:8080/ords/metaxperts/account/get/");
      var results2 = await db.insertAccoutsData(response2);   //return True or False
      var results3 = await db.insertAccoutsData(response3);   //return True or False
      if (results2 && results3) {
        print("Accounts Data inserted successfully.");
      } else {
        print("Error inserting data.");
      }
    } else {
      print("Data is available.");
    }


    if (NetBalancedata == null || NetBalancedata.isEmpty ) {
      var response2 = await api.getApi("https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/balance/get/");
      var response3 = await api.getApi("http://103.149.32.30:8080/ords/metaxperts/balance/get/");
      var results2 = await db.insertNetBalanceData(response2);   //return True or False
      var results3 = await db.insertNetBalanceData(response3);   //return True or False
      if (results2 && results3) {
        print(" Net Balance Data inserted successfully.");
      } else {
        print("Error inserting data.");
      }
    } else {
      print("Data is available.");
    }


    showAllTables2();
  }

  Future<void> update2() async {
    final db=DBHelper();

    print("DELETING.......................................");
    await isInternetAvailable();
    await db.deleteAllRecordsAccounts();
    //await db.deleteAllRecords();
  }

  Future<void> update() async {
    final db = DBHelper();
    print("DELETING.......................................");
    await isInternetAvailable();

    await db.deleteAllRecords();

  }
  Future<void> showOrderMaster() async {
    print("************Tables SHOWING**************");
    print("************Order Master**************");
    final db = DBHelper();

    var data = await db.getOrderMasterDB();
    int co = 0;
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of Order Master is $co");

  }
  Future<void> showOrderMasterData() async {
    print("************Tables SHOWING**************");
    print("************Order Master get data**************");
    final db = DBHelper();

    var data = await db.getOrderBookingStatusDB();
    int co = 0;
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of Order Master get data is $co");

  }

  Future<void> showOrderDetailsData() async {
    print("************Tables SHOWING**************");
    print("************Order Master get data**************");
    final db = DBHelper();

    var data = await db.getOrderDetailsDB();
    int co = 0;
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of Order Details get data is $co");

  }

  Future<void> showReturnForm() async {
    print("************Tables SHOWING**************");
    print("************Return Form**************");
    final db = DBHelper();

    var data = await db.getReturnFormDB();
    int co = 0;
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of Return Form is $co");

  }

  Future<void> showRecoveryForm() async {
    print("************Tables SHOWING**************");
    print("************Recovery Form**************");
    final db = DBHelper();

    var data = await db.getRecoveryFormDB();
    int co = 0;
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of Recovery Form is $co");

  }

  Future<void> showShop() async {
    print("************Tables SHOWING**************");
    print("************Shops**************");
    final db = DBHelper();

    var data = await db.getShopDB();
    int co = 0;
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of Add Shops is $co");
  }

  Future<void> showShopVisit() async {
    print("************Tables SHOWING**************");
    print("************SHOP VISIT**************");
    final db = DBHelper();

    var data = await db.getShopVisit();
    int co = 0;
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of SHOP VISIT is $co");

  }

  Future<void> showStockCheckItems() async {
    print("************Tables SHOWING**************");
    print("************Stock Check Items**************");
    final db = DBHelper();

    var data = await db.getStockCheckItems();
    int co = 0;
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of Order Details is $co");

  }

  // Future<void> showShopVisit_2nd() async {
  //   print("************Tables SHOWING**************");
  //   print("************SHOP VISIT 2nd**************");
  //   final db = DBHelperShopVisit_2nd();
  //
  //   var data = await db.getShopVisit_2nd();
  //   int co = 0;
  //   for(var i in data!){
  //     co++;
  //     print("$co | ${i.toString()} \n");
  //   }
  //   print("TOTAL of SHOP VISIT 2nd is $co");
  //
  // }


  Future<void> showOrderDetails() async {
    print("************Tables SHOWING**************");
    print("************Order Details**************");
    final db = DBHelper();

    var data = await db.getOrderDetails();
    int co = 0;
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of Order Details is $co");

  }

  Future<void> showAttendance() async {
    print("************Tables SHOWING**************");
    print("************Attendance In**************");
    final db = DBHelper();

    var data = await db.getAllAttendance();
    int co = 0;
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of Attendance In is $co");

  }
  Future<void> showAttendanceOut() async {
    print("************Tables SHOWING**************");
    print("************Attendance Out**************");
    final db = DBHelper();

    var data = await db.getAllAttendanceOut();
    int co = 0;
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of Attendance Out is $co");

  }

  Future<void> showReturnFormDetails() async {
    print("************Tables SHOWING**************");
    print("************Return Form Details**************");
    final db = DBHelper();

    var data = await db.getReturnFormDetailsDB();
    int co = 0;
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of Return Form Details is $co");

  }
  Future<void> showOrderDispacthed() async {
    print("************Tables SHOWING**************");
    print("************Dispatched Orders**************");
    final db = DBHelper();

    var data = await db.getOrderBookingStatusDB();
    int co = 0;
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of Orders Dispatched is $co");

  }

  Future<void> showAllTables2() async {
    print("************Tables SHOWING**************");
    print("************Tables Products**************");
    final db = DBHelper();

    var data = await db.getProductsDB();
    int co = 0;


    print("TOTAL of netBalance is $co");

    print("************Tables Net Balance**************");
    co=0;
    data = await db.getNetBalanceDB();
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of Net Balance is $co");

    print("************Tables Accounts**************");
    co=0;
    data = await db.getAccoutsDB();
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of Accounts is $co");

    print("************Tables Order Booking Status**************");
    co=0;
    data = await db.getOrderBookingStatusDB();
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of OrderBooking Status is $co");

  }

  Future<void> showAllTables() async {
    print("************Tables SHOWING**************");
    print("************Tables Products**************");
    final db = DBHelper();


    var data = await db.getProductsDB();
    int co = 0;
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of Products is $co");

    print("************Tables Owners**************");
    co=0;
    data = await db.getOwnersDB();
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of Owners is $co");

    print("************Logins Owners**************");
    co=0;
    data = await db.getAllLogins();
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of Logins is $co");

    print("************ProductsCategories Owners**************");
    co=0;
    data = await db.getAllPCs();
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of Products Categories is $co");

    print("************Tables OrderMaster**************");
    co=0;
    data = await db.getOrderMasterDB();
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of OrderMaster is $co");

    print("************Tables Order Details**************");
    co=0;
    data = await db.getOrderDetailsDB();
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of OrderDetails data is $co");

    print("************Tables Order Booking Status**************");
    co=0;
    data = await db.getOrderBookingStatusDB();
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of OrderBooking Status is $co");

    print("TOTAL of netBalance is $co");

    print("************Tables Net Balance**************");
    co=0;
    data = await db.getNetBalanceDB();
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of Net Balance is $co");

    print("************Tables Accounts**************");
    co=0;
    data = await db.getAccoutsDB();
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of Accounts is $co");


  print("************Tables Distributors**************");
  co=0;
  data = await db.getDistributorsDB();
  for(var i in data!){
  co++;
  print("$co | ${i.toString()} \n");
  }
  print("TOTAL of Distributors is $co");

    print("************Tables Recovery Form Get**************");
    co=0;
    data = await db.getRecoverydataDB();
    for(var i in data!){
      co++;
      print("$co | ${i.toString()} \n");
    }
    print("TOTAL of Recovery Form Get is $co");


  }

}