import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Databases/DBHelper.dart';
import 'ApiServices.dart';


class newDatabaseOutputs {
  Future<void> checkFirstRun() async {
    SharedPreferences SP = await SharedPreferences.getInstance();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstrun = SP.getBool('firstrun') ?? true;
    if (firstrun == true) {
      await SP.setBool('firstrun', false);
      await initializeData();
      await showorderdetails();
      await showordermaster();
      DateTime now = DateTime.now();
      String formattedDateTime = DateFormat('dd-MMM-yyyy-HH:mm:ss').format(now);
      await prefs.setString('lastInitializationDateTime', formattedDateTime);
      if (kDebugMode) {
        print(formattedDateTime);
      }
    } else {
      if (kDebugMode) {
        print("UPDATING.......................................");
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? formattedDateTime = prefs.getString('lastInitializationDateTime');
      await updateAllDatabase();
      DateTime now = DateTime.now();
      formattedDateTime = DateFormat('dd-MMM-yyyy-HH:mm:ss').format(now);
      await prefs.setString('lastInitializationDateTime', formattedDateTime);
      // print(formattedDateTime);
    }
  }
  Future<void> initializeLoginData() async {
    final api = ApiServices();
    final db = DBHelper();
    var Logindata = await db.getAllLogins();

    if (Logindata == null || Logindata.isEmpty) {
      bool inserted = false;

      try {
        var response = await api.getApi(
            "http://103.149.32.30:8080/ords/metaxperts/login/get/");
        inserted = await db.insertLogin(response); // returns True or False

        if (inserted == true) {
          if (kDebugMode) {
            print("Login Data inserted successfully using first API.");
          }
        } else {
          throw Exception("Error inserting data using first API.");
        }
      } catch (e) {
        // if (kDebugMode) {
        //   print("Error with first API. Trying second API.");
        // }

        try {
          var response = await api.getApi(
              "https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/login/get/");
          inserted = await db.insertLogin(response); // returns True or False

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
            print(
                "Error with second API as well. Unable to fetch or insert login data.");
          }
        }
      }
    }
  }
  Future<void> initializeData() async {
    final api = ApiServices();
    final db = DBHelper();
    var Productdata = await db.getProductsDB();
    var OrderMasterdata = await db.getOrderMasterDB();
    var OrderDetailsdata = await db.getOrderDetailsDB();
    // var NetBalancedata = await db.getNetBalanceDB();
    // var Accountsdata = await db.getAccoutsDB();
    var OrderBookingStatusdata = await db.getOrderBookingStatusDB();
    var Owerdata = await db.getOwnersDB();
   // var Logindata = await db.getAllLogins();
    var PCdata = await db.getAllPCs();
    var RecoveryFormGetData = await db.getRecoverydataDB();
    var PakCities= await db.getPakCitiesDB();


    //https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/muhammad_usman/login/get/
    // https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/login/get/
    // var username = 'yxeRFdCC0wjh1BYjXu1HFw..';
    // var password = 'KG-oKSMmf4DhqtFNmVtpMw..';

    // if (Logindata == null || Logindata.isEmpty) {
    //   bool inserted = false;
    //
    //   try {
    //     var response = await api.getApi(
    //         "http://103.149.32.30:8080/ords/metaxperts/login/get/");
    //     inserted = await db.insertLogin(response); // returns True or False
    //
    //     if (inserted == true) {
    //       if (kDebugMode) {
    //         print("Login Data inserted successfully using first API.");
    //       }
    //     } else {
    //       throw Exception("Error inserting data using first API.");
    //     }
    //   } catch (e) {
    //     if (kDebugMode) {
    //       print("Error with first API. Trying second API.");
    //     }
    //
    //     try {
    //       var response = await api.getApi(
    //           "https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/login/get/");
    //       inserted = await db.insertLogin(response); // returns True or False
    //
    //       if (inserted) {
    //         if (kDebugMode) {
    //           print("Login Data inserted successfully using second API.");
    //         }
    //       } else {
    //         if (kDebugMode) {
    //           print("Error inserting data using second API.");
    //         }
    //       }
    //     } catch (e) {
    //       if (kDebugMode) {
    //         print(
    //             "Error with second API as well. Unable to fetch or insert login data.");
    //       }
    //     }
    //   }
    // }

    if (PakCities == null || PakCities.isEmpty) {
      try {
        // https://apex.oracle.com/pls/apex/metaa/owner/get/
        //http://103.149.32.30:8080/ords/metaxperts/owner/get/
        var response = await api.getApi(
            "http://103.149.32.30:8080/ords/metaxperts/city/get/");
        http://103.149.32.30:8080/ords/metaxperts/cities/get/:time

        var results = await db.insertPakCitiesData(response); //return True or False
        if (results) {
          if (kDebugMode) {
            print("PAK Cities Data inserted successfully using first API..");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting data.");
          }
        }
      } catch (e) {
        // if (kDebugMode) {
        //   print("Error with first API. Trying second API.");
        // }
        var response = await api.getApi(
            "https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/city/get/");
        var results = await db.insertPakCitiesData(response); //return True or False
        if (results) {
          if (kDebugMode) {
            print("PAK Cities Data inserted successfully using second API..");
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

    if (Owerdata == null || Owerdata.isEmpty) {
      try {
        // https://apex.oracle.com/pls/apex/metaa/owner/get/
        //http://103.149.32.30:8080/ords/metaxperts/owner/get/
        var response = await api.getApi(
            "https://apex.oracle.com/pls/apex/metaa/owner/get/");

        var results = await db.insertOwnerData(response); //return True or False
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
        // if (kDebugMode) {
        //   print("Error with first API. Trying second API.");
        // }
        var response = await api.getApi(
            "https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/owner/get/");
        var results = await db.insertOwnerData(response); //return True or False
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

    if (OrderBookingStatusdata == null || OrderBookingStatusdata.isEmpty) {
      try {
        var response = await api.getApi(
            "http://103.149.32.30:8080/ords/metaxperts/statusget/get/");
        var results = await db.insertOrderBookingStatusData1(
            response); //return True or False
        if (results) {
          if (kDebugMode) {
            print(
                "OrderBookingStatus Data inserted successfully using first API.");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting data.");
          }
        }
      } catch (e) {
        // if (kDebugMode) {
        //   print("Error with first API. Trying second API.");
        // }
        var response = await api.getApi(
            "https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/statusget/get/");
        var results = await db.insertOrderBookingStatusData1(
            response); //return True or False
        if (results) {
          if (kDebugMode) {
            print(
                "OrderBookingStatus Data inserted successfully using second API..");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting data.");
          }
        }
      }
    }

    if (RecoveryFormGetData == null || RecoveryFormGetData.isEmpty) {
      try {
        var response = await api.getApi(
            "http://103.149.32.30:8080/ords/metaxperts/recovery/get/");

        var results1 = await db.insertRecoveryFormData1(
            response); //return True or False
        if (results1) {
          if (kDebugMode) {
            print(
                "RecoveryFormGetData Data inserted successfully using first API.");
          }
        } else {
          throw Exception('Insertion failed with first API');
        }
      } catch (e) {
        // if (kDebugMode) {
        //   print("Error with first API. Trying second API.");
        // }
        var response = await api.getApi(
            "https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/recovery/get/");

        var results2 = await db.insertRecoveryFormData1(
            response); //return True or False
        if (results2) {
          if (kDebugMode) {
            print(
                "RecoveryFormGetData Data inserted successfully using second API.");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting data with both APIs.");
          }
        }
      }
    }

    if (OrderMasterdata == null || OrderMasterdata.isEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      String? id = userId;
      try {
        var response1 = await api.getApi(
            "http://103.149.32.30:8080/ords/metaxperts/masterget1/get/$id");
        var results1 = await db.insertOrderMasterData1(
            response1); //return True or False
        if (results1) {
          if (kDebugMode) {
            print("OrderMaster Data inserted successfully.");
          }
        } else {
          throw Exception('Insertion failed ');
        }
      }
      catch (e) {
        // if (kDebugMode) {
        //   print("Error with API.");
        // }

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

    if (OrderDetailsdata == null || OrderDetailsdata.isEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      String? id = userId;
      try {
        var response1 = await api.getApi(
            "http://103.149.32.30:8080/ords/metaxperts/detailsget/get/$id");
        var results1 = await db.insertOrderDetailsData1(
            response1); //return True or False
        if (results1) {
          if (kDebugMode) {
            print("OrderDetails Data inserted successfully .");
          }
        } else {
          throw Exception('Insertion failed');
        }
      } catch (e) {
        // if (kDebugMode) {
        //   print("Error with API.");
        // }
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
       else {
        if (kDebugMode) {
          print("Data is available.");
        }

    }


    if (Productdata == null || Productdata.isEmpty) {
      try {
        var response1 = await api.getApi(
            "http://103.149.32.30:8080/ords/metaxperts/product/get/");

        var results1 = await db.insertProductsData(
            response1); //return True or False
        if (results1) {
          if (kDebugMode) {
            print("Products Data inserted successfully using first API.");
          }
        } else {
          throw Exception('Insertion failed with first API');
        }
      } catch (e) {
        // if (kDebugMode) {
        //   print("Error with first API. Trying second API.");
        // }
        var response2 = await api.getApi(
            "https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/product/get/");
        var results2 = await db.insertProductsData(
            response2); //return True or False
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

    if (PCdata == null || PCdata.isEmpty) {
      try {
        var response1 = await api.getApi(
            "http://103.149.32.30:8080/ords/metaxperts/brand/get/");
        var results1 = await db.insertProductCategory(
            response1); //return True or False
        if (results1) {
          if (kDebugMode) {
            print("PC Data inserted successfully using first API.");
          }
        } else {
          throw Exception('Insertion failed with first API');
        }
      } catch (e) {
        // if (kDebugMode) {
        //   print("Error with first API. Trying second API.");
        // }
        var response2 = await api.getApi(
            "https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/brand/get/");

        var results2 = await db.insertProductCategory(
            response2); //return True or False
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
  }

  Future<void> showordermaster() async {
    if (kDebugMode) {
      print("*Tables SHOWING*");
    }
    if (kDebugMode) {
      print("*Order Master*");
    }
    final db = DBHelper();
    var data = await db.getOrderMasterDB();
    int co = 0;
    for (var i in data!) {
      co++;
      if (kDebugMode) {
        print("$co | ${i.toString()} \n");
      }
    }
    if (kDebugMode) {
      print("TOTAL of order master table is $co");
    }
  }

  Future<void> showorderdetails() async {
    if (kDebugMode) {
      print("*Tables SHOWING*");
    }
    if (kDebugMode) {
      print("*Order Details*");
    }
    final db = DBHelper();
    var data = await db.getOrderDetailsDB();
    int co = 0;
    for (var i in data!) {
      co++;
      if (kDebugMode) {
        print("$co | ${i.toString()} \n");
      }
    }
    if (kDebugMode) {
      print("TOTAL of order details table is $co");
    }
  }

  Future<void> updateAllDatabase() async {
     updateloginData();
     updateOwnerData();
     updatePakCitiesData();
     updateorderBookingStatusData();
     updateproductCategoryData();
     updateProductsData();
     updateorderMasterData();
     updateorderDetailsData();
     updateaccountsData();
     updatenetBalanceData();
     updaterecoveryFormGetData();
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
      var loginData = await api.getupdateData(
          "http://103.149.32.30:8080/ords/metaxperts/logindata/get/$timedate");
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
  }

  Future<void> updateOwnerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? formattedDateTime = prefs.getString('lastInitializationDateTime');

    if (formattedDateTime != null) {
      String timedate = formattedDateTime;
      if (kDebugMode) {
        print(timedate);
      }
      final api = ApiServices();
      final db = DBHelper();

      var ownerData = await api.getupdateData(
          "http://103.149.32.30:8080/ords/metaxperts/shop1/get/$timedate");

      if (ownerData != null && ownerData.isNotEmpty) {
        bool inserted = await db.insertOwnerData(ownerData);
        if (inserted) {
          if (kDebugMode) {
            print(
                "ownerData updated inserted successfully into local database.");
            print("Inserted data: $ownerData");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting ownerData updated into local database.");
          }
        }
      } else {
        if (kDebugMode) {
          print(
              "No ownerData updated ownerData available for the timedate: $timedate");
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
  Future<void> updatePakCitiesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? formattedDateTime = prefs.getString('lastInitializationDateTime');

    if (formattedDateTime != null) {
      String timedate = formattedDateTime;
      if (kDebugMode) {
        print(timedate);
      }
      final api = ApiServices();
      final db = DBHelper();

      var pakCitiesData = await api.getupdateData(
          "http://103.149.32.30:8080/ords/metaxperts/cities/get/$timedate");

      if (pakCitiesData != null && pakCitiesData.isNotEmpty) {
        bool inserted = await db.insertPakCitiesData(pakCitiesData);
        if (inserted) {
          if (kDebugMode) {
            print(
                "ownerData updated inserted successfully into local database.");
            print("Inserted data: $pakCitiesData");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting ownerData updated into local database.");
          }
        }
      } else {
        if (kDebugMode) {
          print(
              "No ownerData updated ownerData available for the timedate: $timedate");
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

  Future<void> updateProductsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? formattedDateTime = prefs.getString('lastInitializationDateTime');

    if (formattedDateTime != null) {
      String timedate = formattedDateTime;
      if (kDebugMode) {
        print(timedate);
      }
      final api = ApiServices();
      final db = DBHelper();

      var productsData = await api.getupdateData(
          "http://103.149.32.30:8080/ords/metaxperts/products/get/$timedate");

      if (productsData != null && productsData.isNotEmpty) {
        bool inserted = await db.insertProductsData(productsData);
        if (inserted) {
          if (kDebugMode) {
            print(
                "productsData updated inserted successfully into local database.");
            print("Inserted data: $productsData");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting productsData updated into local database.");
          }
        }
      } else {
        if (kDebugMode) {
          print(
              "No productsData updated data available for the timedate: $timedate");
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

  Future<void> updateorderMasterData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? formattedDateTime = prefs.getString('lastInitializationDateTime');
    String? id = prefs.getString('userId');

    if (formattedDateTime != null) {
      String timedate = formattedDateTime;
      String? idd = id;
      if (kDebugMode) {
        print(timedate);
      }
      final api = ApiServices();
      final db = DBHelper();

      var orderMasterData = await api.getupdateData(
          "http://103.149.32.30:8080/ords/metaxperts/mastergettime/get/$idd/$timedate");

      if (orderMasterData != null && orderMasterData.isNotEmpty) {
        bool inserted = await db.insertOrderMasterData1(orderMasterData);
        if (inserted) {
          if (kDebugMode) {
            print(
                "orderMasterData updated inserted successfully into local database.");
            print("Inserted data: $orderMasterData");
          }
        } else {
          if (kDebugMode) {
            print(
                "Error inserting orderMasterData updated into local database.");
          }
        }
      } else {
        if (kDebugMode) {
          print(
              "No orderMasterData updated data available for the timedate: $timedate");
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

  Future<void> updateorderDetailsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? formattedDateTime = prefs.getString('lastInitializationDateTime');
    String? id = prefs.getString('userId');
    if (formattedDateTime != null) {
      String? idd = id;
      String timedate = formattedDateTime;
      if (kDebugMode) {
        print(timedate);
      }
      final api = ApiServices();
      final db = DBHelper();

      var orderDetailsData = await api.getupdateData(
          "http://103.149.32.30:8080/ords/metaxperts/detailsgettime/get/$idd/$timedate");

      if (orderDetailsData != null && orderDetailsData.isNotEmpty) {
        bool inserted = await db.insertOrderDetailsData1(orderDetailsData);
        if (inserted) {
          if (kDebugMode) {
            print(
                "orderDetailsData updated inserted successfully into local database.");
            print("Inserted data: $orderDetailsData");
          }
        } else {
          if (kDebugMode) {
            print(
                "Error inserting orderDetailsData updated into local database.");
          }
        }
      } else {
        if (kDebugMode) {
          print(
              "No orderDetailsData updated data available for the timedate: $timedate");
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

  Future<void> updateorderBookingStatusData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? formattedDateTime = prefs.getString('lastInitializationDateTime');
    String? id = prefs.getString('userId');
    if (formattedDateTime != null) {
      String timedate = formattedDateTime;
      String? idd = id;
      if (kDebugMode) {
        print(timedate);
      }
      final db = DBHelper();
      final api = ApiServices();
      // Fetch data from the API
      var orderBookingStatusData = await api.getupdateData(
          "http://103.149.32.30:8080/ords/metaxperts/statusgettime/get/$idd/$timedate");
      if ( orderBookingStatusData!= null && orderBookingStatusData.isNotEmpty) {
        // Get data from local database
        final localData = await db.getallOrderBookingStatusDB();
        // Compare API response with local data and update local database
        for (var newData in orderBookingStatusData) {
          bool dataExistsLocally = false;
          for (var localDatum in localData!) {
            if (localDatum['order_no'] == newData['order_no']) {
              dataExistsLocally = true;
              break;
            }
          }
          if (!dataExistsLocally) {
            try {
              await db.insertOrderBookingStatusData1([newData]);
              if (kDebugMode) {
                print("New data inserted into ordere status local database: $newData");
              }
            } catch (e) {
              print("Error inserting new data into local database: $e");
            }
          }
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


      // Future<void> updateorderBookingStatusData() async {
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   String? formattedDateTime = prefs.getString(
      //       'lastInitializationDateTime');
      //
      //   if (formattedDateTime != null) {
      //     String timedate = formattedDateTime;
      //     if (kDebugMode) {
      //       print(timedate);
      //     }
      //     final api = ApiServices();
      //     final db = DBHelper();
      //
      //     var orderBookingStatusData = await api.getupdateData(
      //         "http://103.149.32.30:8080/ords/metaxperts/statusget1/get/$timedate");
      //
      //     if (orderBookingStatusData != null &&
      //         orderBookingStatusData.isNotEmpty) {
      //       bool inserted = await db.insertOrderBookingStatusData1(
      //           orderBookingStatusData);
      //       if (inserted) {
      //         if (kDebugMode) {
      //           print(
      //               "login updated inserted successfully into local database.");
      //           print("Inserted data: $orderBookingStatusData");
      //         }
      //       } else {
      //         if (kDebugMode) {
      //           print("Error inserting login updated into local database.");
      //         }
      //       }
      //     } else {
      //       if (kDebugMode) {
      //         print(
      //             "No login updated data available for the timedate: $timedate");
      //       }
      //     }
      //   }
      //   else {
      //     // Handle the case where the value is not found in SharedPreferences
      //     if (kDebugMode) {
      //       print('No formatted date and time found in SharedPreferences');
      //     }
      //   }
      // }

      Future<void> updatenetBalanceData() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? formattedDateTime = prefs.getString(
            'lastInitializationDateTime');

        if (formattedDateTime != null) {
          String timedate = formattedDateTime;
          if (kDebugMode) {
            print(timedate);
          }
          final api = ApiServices();
          final db = DBHelper();

          var netBalance = await api.getupdateData(
              "http://103.149.32.30:8080/ords/metaxperts/balance1/get/$timedate");

          if (netBalance != null && netBalance.isNotEmpty) {
            bool inserted = await db.insertNetBalanceData(netBalance);
            if (inserted) {
              if (kDebugMode) {
                print(
                    "netBalance updated inserted successfully into local database.");
                print("Inserted data: $netBalance");
              }
            } else {
              if (kDebugMode) {
                print(
                    "Error inserting netBalance updated into local database.");
              }
            }
          } else {
            if (kDebugMode) {
              print(
                  "No netBalance updated data available for the timedate: $timedate");
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

  Future<void> updateaccountsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? formattedDateTime = prefs.getString('lastInitializationDateTime');

    if (formattedDateTime != null) {
      String timedate = formattedDateTime;
      if (kDebugMode) {
        print(timedate);
      }
      final api = ApiServices();
      final db = DBHelper();

      var accounts = await api.getupdateData(
          "http://103.149.32.30:8080/ords/metaxperts/accounts/get/$timedate");

      if (accounts != null && accounts.isNotEmpty) {
        bool inserted = await db.insertAccoutsData(accounts);
        if (inserted) {
          if (kDebugMode) {
            print(
                "accounts updated inserted successfully into local database.");
            print("Inserted data: $accounts");
          }
        } else {
          if (kDebugMode) {
            print("Error inserting accounts updated into local database.");
          }
        }
      } else {
        if (kDebugMode) {
          print(
              "No accounts updated data available for the timedate: $timedate");
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

  Future<void> updateproductCategoryData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? formattedDateTime = prefs.getString('lastInitializationDateTime');

    if (formattedDateTime != null) {
      String timedate = formattedDateTime;
      if (kDebugMode) {
        print(timedate);
      }
      final api = ApiServices();
      final db = DBHelper();
      var productCategory = await api.getupdateData(
          "http://103.149.32.30:8080/ords/metaxperts/brands/get/$timedate");
      if (productCategory != null && productCategory.isNotEmpty) {
        bool inserted = await db.insertProductCategory(productCategory);
        if (inserted) {
          if (kDebugMode) {
            print(
                "productCategory updated inserted successfully into local database.");
            print("Inserted data: $productCategory");
          }
        } else {
          if (kDebugMode) {
            print(
                "Error inserting productCategory updated into local database.");
          }
        }
      } else {
        if (kDebugMode) {
          print(
              "No productCategory updated data available for the timedate: $timedate");
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
  Future<void> updaterecoveryFormGetData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? formattedDateTime = prefs.getString('lastInitializationDateTime');

    if (formattedDateTime != null) {
      String timedate = formattedDateTime;
      if (kDebugMode) {
        print(timedate);
      }
      final api = ApiServices();
      final db = DBHelper();
      var recoveryFormGet = await api.getupdateData(
          "http://103.149.32.30:8080/ords/metaxperts/recovery1/get/$timedate");
      if (recoveryFormGet != null && recoveryFormGet.isNotEmpty) {
        bool inserted = await db.insertRecoveryFormData1(recoveryFormGet);
        if (inserted) {
          if (kDebugMode) {
            print(
                "recoveryFormGet updated inserted successfully into local database.");
            print("Inserted data: $recoveryFormGet");
          }
        } else {
          if (kDebugMode) {
            print(
                "Error inserting recoveryFormGet updated into local database.");
          }
        }
      } else {
        if (kDebugMode) {
          print(
              "No recoveryFormGet updated data available for the timedate: $timedate");
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

}
