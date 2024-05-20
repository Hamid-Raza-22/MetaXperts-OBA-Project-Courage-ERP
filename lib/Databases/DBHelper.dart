import 'dart:convert' show base64Decode;
import 'dart:io' show  File;
import 'dart:math' show max;
import 'package:flutter/foundation.dart' show Uint8List, kDebugMode;
import 'package:intl/intl.dart' show DateFormat;
import 'package:order_booking_shop/API/Globals.dart';
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory, getDownloadsDirectory;
import 'package:sqflite/sqflite.dart' show Database, openDatabase;
import 'package:path/path.dart' show join;
import 'dart:io' as io;
import 'dart:async' show Future;
import '../API/ApiServices.dart';
import '../Models/AttendanceModel.dart';
import '../Models/LocationModel.dart';
import '../Models/OrderModels/OrderDetailsModel.dart';
import '../Models/OrderModels/OrderMasterModel.dart';
import '../Models/RecoveryFormModel.dart';
import '../Models/ReturnFormDetails.dart';
import '../Models/ReturnFormModel.dart';
import '../Models/ShopModel.dart';
import '../Models/ShopVisitModels.dart';
import '../Models/StockCheckItems.dart';
import '../Models/loginModel.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }
  Future<Database> initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'shop.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate ,);
    return db;
  }
_onCreate(Database db, int version) async {
  await db.execute("CREATE TABLE ownerData(id NUMBER,shop_name TEXT, owner_name TEXT, phone_no TEXT, city TEXT, shop_address TEXT,created_date TEXT, user_id TEXT, images BLOB)");
  await db.execute("CREATE TABLE orderBookingStatusData(order_no TEXT, status TEXT, order_date TEXT, shop_name TEXT, amount TEXT, user_id TEXT, city TEXT, brand TEXT)");
    await db.execute("CREATE TABLE distributors(id INTEGER PRIMARY KEY AUTOINCREMENT, bussiness_name TEXT, owner_name TEXT,brand TEXT, zone TEXT, area_name TEXT, mobile_no INTEGER)");
    await db.execute("CREATE TABLE shop(id INTEGER PRIMARY KEY AUTOINCREMENT, shopName TEXT, city TEXT,date TEXT, shopAddress TEXT, ownerName TEXT, ownerCNIC TEXT, phoneNo TEXT, alternativePhoneNo INTEGER, latitude TEXT, longitude TEXT, userId TEXT,posted INTEGER DEFAULT 0,body BLOB)");
    await db.execute("CREATE TABLE orderMaster (orderId TEXT PRIMARY KEY, date TEXT, shopName TEXT, ownerName TEXT, phoneNo TEXT, brand TEXT, userName TEXT, userId TEXT, total INTEGER, creditLimit TEXT, requiredDelivery TEXT,shopCity TEXT,posted INTEGER DEFAULT 0)");
    await db.execute("CREATE TABLE order_details(id INTEGER PRIMARY KEY AUTOINCREMENT,order_master_id TEXT,productName TEXT,quantity INTEGER,price INTEGER,amount INTEGER,userId TEXT,posted INTEGER DEFAULT 0,FOREIGN KEY (order_master_id) REFERENCES orderMaster(orderId))");
    await db.execute("CREATE TABLE products(id NUMBER, product_code TEXT, product_name TEXT, uom TEXT ,price TEXT, brand TEXT, quantity TEXT)");
    await db.execute("CREATE TABLE orderMasterData(order_no TEXT, shop_name TEXT, user_id TEXT)");
    await db.execute("CREATE TABLE orderDetailsData(id INTEGER,order_no TEXT, product_name TEXT, quantity_booked INTEGER, user_id TEXT, price INTEGER)");
    await db.execute("CREATE TABLE netBalance(shop_name TEXT, debit TEXT,credit TEXT)");
    await db.execute("CREATE TABLE accounts(account_id INTEGER, shop_name TEXT, order_date TEXT, credit TEXT, booker_name TEXT)");
    await db.execute("CREATE TABLE productCategory(id INTEGER,brand TEXT)");
    await db.execute("CREATE TABLE pakCities(id INTEGER,city TEXT)");
    await db.execute("CREATE TABLE attendance(id INTEGER PRIMARY KEY , date TEXT, timeIn TEXT, userId TEXT, latIn TEXT, lngIn TEXT, bookerName TEXT,city TEXT, designation TEXT)");
    await db.execute("CREATE TABLE attendanceOut(id INTEGER PRIMARY KEY , date TEXT, timeOut TEXT, totalTime TEXT, userId TEXT,latOut TEXT, lngOut TEXT,totalDistance TEXT, posted INTEGER DEFAULT 0)");
    await db.execute("CREATE TABLE recoveryForm (recoveryId TEXT, date TEXT, shopName TEXT, cashRecovery REAL, netBalance REAL, userId TEXT ,bookerName TEXT,city TEXT, brand TEXT)");
    await db.execute("CREATE TABLE returnForm (returnId INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, shopName TEXT, returnAmount INTEGER, bookerId TEXT, bookerName TEXT, city TEXT, brand TEXT)");
    await db.execute("CREATE TABLE return_form_details(id INTEGER PRIMARY KEY AUTOINCREMENT,returnFormId TEXT,productName TEXT,quantity TEXT,reason TEXT,bookerId TEXT,FOREIGN KEY (returnFormId) REFERENCES returnForm(returnId))");
    await db.execute("CREATE TABLE shopVisit (id TEXT PRIMARY KEY,date TEXT,shopName TEXT,userId TEXT,bookerName TEXT,brand TEXT,walkthrough TEXT,planogram TEXT,signage TEXT,productReviewed TEXT,feedback TEXT,latitude TEXT,longitude TEXT,address TEXT,body BLOB)");
    await db.execute("CREATE TABLE Stock_Check_Items(id INTEGER PRIMARY KEY AUTOINCREMENT,shopvisitId TEXT,itemDesc TEXT,qty TEXT,FOREIGN KEY (shopvisitId) REFERENCES shopVisit(id))");
    await db.execute("CREATE TABLE login(user_id TEXT, password TEXT ,user_name TEXT, city TEXT, designation TEXT,images BLOB)");
    await db.execute("CREATE TABLE recoveryFormGet (recovery_id TEXT, user_id TEXT)");
    await db.execute("CREATE TABLE location(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, fileName TEXT,userId TEXT,totalDistance TEXT,userName TEXT, posted INTEGER DEFAULT 0,body BLOB)");
}

  Future<int> updateLogin(Map<String, dynamic> row) async {
    Database? db = await this.db;
    return await db!.update('login', row, where: 'user_id = ?', whereArgs: [row['user_id']]);
  }
  Future<int> updateOwner(Map<String, dynamic> row) async {
    Database? db = await this.db;
    return await db!.update('ownerData', row, where: 'id = ?', whereArgs: [row['id']]);
  }
  Future<int> updateOrderBookingStutsData(Map<String, dynamic> row) async {
    Database? db = await this.db;
    return await db!.update('orderBookingStatusData', row, where: 'order_no = ?', whereArgs: [row['order_no']]);
  }
  Future<int> updateRecoveryFormGetData(Map<String, dynamic> row) async {
    Database? db = await this.db;
    return await db!.update('recoveryFormGet', row, where: 'recovery_id = ?', whereArgs: [row['recovery_id']]);
  }
  Future<int> updateOrderMasterData(Map<String, dynamic> row) async {
    Database? db = await this.db;
    return await db!.update('orderMasterData', row, where: 'order_no = ?', whereArgs: [row['order_no']]);
  }
  Future<int> updateOrderDetailsdata(Map<String, dynamic> row) async {
    Database? db = await this.db;
    return await db!.update('orderDetailsData', row, where: 'id = ?', whereArgs: [row['id']]);
  }
  Future<int> updateProductCategorydata(Map<String, dynamic> row) async {
    Database? db = await this.db;
    return await db!.update('productCategory', row, where: 'id = ?', whereArgs: [row['id']]);
  }
  Future<int> updateProductdata(Map<String, dynamic> row) async {
    Database? db = await this.db;
    return await db!.update('products', row, where: 'id = ?', whereArgs: [row['id']]);
  }

  // Delete funtions
  Future<int> deleteLogin(Map<String, dynamic> row) async {
    Database? db = await this.db;
    return await db!.delete('login', where: 'user_id = ?', whereArgs: [row['user_id']]);
  }
  Future<int> deleteOwner(Map<String, dynamic> row) async {
    Database? db = await this.db;
    return await db!.delete('ownerData',  where: 'id = ?', whereArgs: [row['id']]);
  }
  Future<int> deleteOrderBookingStutsData(Map<String, dynamic> row) async {
    Database? db = await this.db;
    return await db!.delete('orderBookingStatusData', where: 'order_no = ?', whereArgs: [row['order_no']]);
  }
  Future<int> deleteRecoveryFormGetData(Map<String, dynamic> row) async {
    Database? db = await this.db;
    return await db!.delete('recoveryFormGet',  where: 'recovery_id = ?', whereArgs: [row['recovery_id']]);
  }
  Future<int>deleteOrderMasterData(Map<String, dynamic> row) async {
    Database? db = await this.db;
    return await db!.delete('orderMasterData', where: 'order_no = ?', whereArgs: [row['order_no']]);
  }
  Future<int> deleteOrderDetailsdata(Map<String, dynamic> row) async {
    Database? db = await this.db;
    return await db!.delete('orderDetailsData',where: 'id = ?', whereArgs: [row['id']]);
  }
  Future<int> deleteProductCategorydata(Map<String, dynamic> row) async {
    Database? db = await this.db;
    return await db!.delete('productCategory',  where: 'id = ?', whereArgs: [row['id']]);
  }
  Future<int> deleteProductdata(Map<String, dynamic> row) async {
    Database? db = await this.db;
    return await db!.delete('products', where: 'id = ?', whereArgs: [row['id']]);
  }


  Future<void> getHighestSerialNo() async {
    int serial;

    final db = await this.db;
    final result = await db!.rawQuery('''
    SELECT order_no 
    FROM orderBookingStatusData 
    WHERE user_id = ? AND order_no IS NOT NULL
  ''', [userId]);

    if (result.isNotEmpty) {
      // Extract the serial numbers from the order_no strings
      final serialNos = result.map((row) {
        final orderNo = row['order_no'] as String?;
        if (orderNo != null) {
          final parts = orderNo.split('-');
          if (parts.length > 0) {
            final serialNoPart = parts.last;
            if (serialNoPart.isNotEmpty) {
              return int.tryParse(serialNoPart);
            }
          }
        }
        return null;
      }).where((serialNo) => serialNo != null).cast<int>().toList();

      // Find and set the maximum serial number
      if (serialNos.isNotEmpty) {
        serial = serialNos.reduce(max);
        serial++;
        // Increment the highest serial number
        highestSerial = serial;
      } else {
        if (kDebugMode) {
          print('No valid order numbers found for this user');
        }
      }
    } else {
      if (kDebugMode) {
        print('No orders found for this user');
      }
    }
  }

  Future<void> getRecoveryHighestSerialNo() async {
    int serial;
    final db = await this.db;
    final result = await db!.rawQuery('''
    SELECT recovery_id 
    FROM recoveryFormGet 
    WHERE user_id = ? AND recovery_id IS NOT NULL
  ''', [userId]);

    if (result.isNotEmpty) {
      // Extract the serial numbers from the order_no strings
      final serialNos = result.map((row) {
        final orderNo = row['recovery_id'] as String?;
        if (orderNo != null) {
          final parts = orderNo.split('-');
          if (parts.length > 0) {
            final serialNoPart = parts.last;
            if (serialNoPart.isNotEmpty) {
              return int.tryParse(serialNoPart);
            }
          }
        }
        return null;
      }).where((serialNo) => serialNo != null).cast<int>().toList();

      // Find and set the maximum serial number
      if (serialNos.isNotEmpty) {
        serial = serialNos.reduce(max);
        serial++;
        // Increment the highest serial number
        RecoveryhighestSerial = serial;
      } else {
        if (kDebugMode) {
          print('No valid recovery_id numbers found for this user');
        }
      }
    } else {
      if (kDebugMode) {
        print('No orders found for this user');
      }
    }
  }

  // Future<void> insertShop(ShopModel shop) async {
  //   final Database db = await initDatabase();
  //
  //   // Insert the shop into the 'shop' table
  //   await db.insert(
  //     'shop',
  //     shop.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  //
  //   // Insert the relevant data into the 'ownerData' table
  //   await db.rawInsert(
  //     'INSERT INTO ownerData(id, shop_name, owner_name, phone_no, city) VALUES(?, ?, ?, ?, ?)',
  //     [shop.id, shop.shopName, shop.ownerName, shop.phoneNo, shop.city],
  //   );
  // }

  Future<List<Map<String, dynamic>>?> getOrderMasterdataDB() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> ordermaster = await db.query('orderBookingStatusData',where: 'user_id = ?', whereArgs: [userId]);
      return ordermaster;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving products: $e");
      }
      return null;
    }
  }
  Future<List<Map<String, dynamic>>?> getRecoverydataDB() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> recoveryFormGet = await db.query('recoveryFormGet', where: 'user_id = ?', whereArgs: [userId]);
      return recoveryFormGet;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving products: $e");
      }
      return null;
    }
  } Future<bool> insertOrderDetailsData(List<dynamic> dataList) async {
    final Database db = await initDatabase();
    try {
      for (var data in dataList) {
        if (data['user_id'] == userId) {
          await db.insert('orderDetailsData', data);
        }}
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error inserting orderDetailsGet data: ${e.toString()}");
      }
      return false;
    }
  }
  Future<bool> insertOrderDetailsData1(List<dynamic> dataList) async {
    final Database db = await initDatabase();
    try {
      for (var data in dataList) {

          await db.insert('orderDetailsData', data);
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error inserting orderDetailsGet data: ${e.toString()}");
      }
      return false;
    }
  }

  Future<ShopModel?> getShopData(int id) async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient!.query(
      'shop',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ShopModel.fromMap(maps.first);
    } else {
      return null;
    }
  }
  Future<List<String>> getOrderDetailsProductNames() async {
    final Database db = await initDatabase();
    try {
      // Retrieve product names where order_no matches the global variable
      final List<Map<String, dynamic>> productNames = await db.query(
        'orderDetailsData',
        where: 'order_no = ?',
        whereArgs: [selectedorderno],
      );
      return productNames.map((map) => map['product_name'] as String).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving Products names: $e");
      }
      return [];
    }
  }

  Future<String?> fetchQuantityForProduct(String productName) async {
    try {
      final Database db = await initDatabase();
      final List<Map<String, dynamic>> result = await db.query(
        'orderDetailsData',
        columns: ['quantity_booked'],
        where: 'product_name = ?',
        whereArgs: [productName],
      );

      if (result.isNotEmpty) {
        return result[0]['quantity_booked'].toString();
      } else {
        return null; // Handle the case where quantity is not found
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching quantity for product: $e");
      }
      return null;
    }
  }


  Future<String?> fetchPriceForProduct(String productName) async {
    try {
      final Database db = await initDatabase();
      final List<Map<String, dynamic>> result = await db.query(
        'orderDetailsData',
        columns: ['price'],
        where: 'product_name = ?',
        whereArgs: [productName],
      );

      if (result.isNotEmpty) {
        return result[0]['price'].toString();
      } else {
        return null; // Handle the case where quantity is not found
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching price for product: $e");
      }
      return null;
    }
  }


  Future<List<String>> getOrderMasterOrderNo() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> orderNo = await db.query('orderBookingStatusData', where: 'user_id = ?', whereArgs: [userId]);
      return orderNo.map((map) => map['order_no'] as String).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving order no: $e");
      }
      return [];
    }
  }
  Future<List<String>> getOrderMasterShopNames() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> shopNames = await db.query('orderBookingStatusData', where: 'user_id = ? AND status = ?',
        whereArgs: [userId, "DISPATCHED"],
      );
      return shopNames.map((map) => map['shop_name'] as String).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving shop names: $e");
      }
      return [];
    }
  }
  Future<List<String>> getOrderMasterShopNames2() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> shopNames = await db.query('orderBookingStatusData', where: 'user_id = ?',
        whereArgs: [userId],
      );
      return shopNames.map((map) => map['shop_name'] as String).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving shop names: $e");
      }
      return [];
    }
  }

  Future<List<Map<String, dynamic>>?> getShopDB() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> products = await db.query('shop');
      return products;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving products: $e");
      }
      return null;
    }
  }
  Future<void> postShopTable() async {
    final Database db = await initDatabase();
    final ApiServices api = ApiServices();

    try {
      final List<Map<String, dynamic>> records = await db.query('shop');

      // Print each record
      for (var record in records) {
        if (kDebugMode) {
          print(record.toString());
        }
      }
      // Select only the records that have not been posted yet
      final products = await db.rawQuery('SELECT * FROM shop WHERE posted = 0');
      if (products.isNotEmpty) {  // Check if the table is not empty
        for (var i in products) {
          if (kDebugMode) {
            print("FIRST ${i.toString()}");
          }


        ShopModel v = ShopModel(
            id: "${i['id']}",
            shopName: i['shopName'].toString(),
            city: i['city'].toString(),
            date: i['date'].toString(),
            shopAddress: i['shopAddress'].toString(),
            ownerName: i['ownerName'].toString(),
            ownerCNIC: i['ownerCNIC'].toString(),
            phoneNo: i['phoneNo'].toString(),
            alternativePhoneNo: i['alternativePhoneNo'].toString(),
            latitude: i['latitude'].toString(),
             longitude: i['longitude'].toString(),
             userId: i['userId'].toString(),
          body: i['body'] != null && i['body'].toString().isNotEmpty
              ? Uint8List.fromList(base64Decode(i['body'].toString()))
              : Uint8List(0),

        );

          // Print image path before trying to create the file
          if (kDebugMode) {
            print("Image Path from Database: ${i['body']}");
          }
          if (kDebugMode) {
            print("lat:${i['latitude']}");
          }
          // Declare imageBytes outside the if block
          Uint8List imageBytes;
          final directory = await getApplicationDocumentsDirectory();
          final filePath = File('${directory.path}/captured_image.jpg');
          if (filePath.existsSync()) {
            // File exists, proceed with reading the file
            List<int> imageBytesList = await filePath.readAsBytes();
            imageBytes = Uint8List.fromList(imageBytesList);
          } else {
            if (kDebugMode) {
              print("File does not exist at the specified path: ${filePath.path}");
            }
            continue; // Skip to the next iteration if the file doesn't exist
          }
          // Print information before making the API request
          if (kDebugMode) {
            print("Making API request for shop visit ID: ${v.id}");
          }
          https://apex.oracle.com/pls/apex/metaa/addshop/post/
          http://103.149.32.30:8080/ords/metaxperts/addshop/post/
          var result1 = await api.masterPostWithImage(v.toMap(), 'https://apex.oracle.com/pls/apex/metaa/addshop/post/', imageBytes,);
          var result = await api.masterPostWithImage(v.toMap(), 'https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/addshop/post/', imageBytes,);
          if (result == true && result1 == true) {
            await db.rawQuery('DELETE FROM shop WHERE id = ${i['id']}');
            if (kDebugMode) {
              print("Successfully posted data for shop visit ID: ${v.id}");
            }
          }
          else {
            if (kDebugMode) {
              print("Failed to post data for shop visit ID: ${v.id}");
            }
          }
        }

      }
    } catch (e) {
      if (kDebugMode) {
        print("Error processing shop visit data: $e");
      }
      return;
    }
  }

  Future<bool> entershopdata(String shopName) async {
    final Database db = await initDatabase();
    try {
      await db.rawInsert("INSERT INTO shops (shopName) VALUES ('$shopName')");
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error inserting product: $e");
      }
      return false;
    }
  }
  Future<Object> getrow() async {
    final Database db = await initDatabase();
    try {
      var results = await db.rawQuery("SELECT * FROM shops");
      if (results.isNotEmpty) {
        return results;
      } else {
        if (kDebugMode) {
          print("No rows found in the 'shops' table.");
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving product: $e");
      }
      return false;
    }
  }
  Future<bool> enterownerdata(ShopModel shopModel) async {
    final Database db = await initDatabase();
    try {
      await db.rawQuery("INSERT INTO  owner(owner_name,phone_no  VALUES ('${shopModel.ownerName.toString()}','${shopModel.phoneNo.toString()}'}') ");
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error inserting product: $e");
      }
      return false;
    }
    }

// Define a function to perform a migration if necessary.

  // Create a shop
  Future<int> createShop(ShopModel shop) async {
    final dbClient = await db;
    return dbClient!.insert('shop', shop.toMap());
  }

  // Read all shops
  Future<List<ShopModel>> getShop() async {
    final dbClient = await db;
    final List<Map<dynamic, dynamic>> maps = await dbClient!.query('shop');
    return List.generate(maps.length, (index) {
      return ShopModel.fromMap(maps[index]);
    });
  }

  //
  // // Update a shop
  // Future<int> updateShop(ShopModel shop) async {
  //   final dbClient = await db;
  //   return dbClient!.update('shop', shop.toMap(),
  //       where: 'id = ?', whereArgs: [shop.id]);
  // }

  // Delete a shop
  Future<int> deleteShop(int id) async {
    final dbClient = await db;
    return dbClient!.delete('shop', where: 'id = ?', whereArgs: [id]);
  }
  Future<void> addOrderDetails(List<OrderDetailsModel> orderDetailsList) async {
    final db = _db;
    for (var orderDetails in orderDetailsList) {
      await db?.insert('order_details', orderDetails.toMap());
    }
  }

  Future<List<Map<String, dynamic>>> getOrderDetails() async {
    final db = _db;
    try {
      if (db != null) {
        final List<Map<String, dynamic>> products = await db.rawQuery('SELECT * FROM order_details');
        return products;
      } else {
        // Handle the case where the database is null
        return [];
      }
    } catch (e) {
      // Let the calling code handle the error
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>?> getOrderMasterDB() async {
    final Database db = await initDatabase();
    try {
      // orderBookingStatusData
      final List<Map<String, dynamic>> products = await db.query('orderMasterData');
      return products;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving products: $e");
      }
      return null;
    }
  }

  Future<void> postMasterTable() async {
    final Database db = await initDatabase();
    final ApiServices api = ApiServices();

    try {
      final List<Map<String, dynamic>> records = await db.query('orderMaster');

      // Print each record
      for (var record in records) {
        if (kDebugMode) {
          print(record.toString());
        }
      }
      // Select only the records that have not been posted yet
      final products = await db.rawQuery('SELECT * FROM orderMaster WHERE posted = 0');
      if (products.isNotEmpty) {  // Check if the table is not empty
        for (var i in products) {
          if (kDebugMode) {
            print("FIRST ${i.toString()}");
          }

        OrderMasterModel v = OrderMasterModel(
            orderId: i['orderId'].toString(),
            shopName: i['shopName'].toString(),
            ownerName: i['ownerName'].toString(),
            phoneNo: i['phoneNo'].toString(),
            brand: i['brand'].toString(),
            date: i['date'].toString(),
            userId: i['userId'].toString(),
            userName: i['userName'].toString(),
            shopCity: i['shopCity'].toString(),
            total: i['total'].toString(),
            // subTotal: i['subTotal'].toString(),
            // discount: i['discount'].toString(),
            creditLimit: i['creditLimit'].toString(),
            requiredDelivery: i['requiredDelivery'].toString()
        );

          var result1 = await api.masterPost(v.toMap(), 'http://103.149.32.30:8080/ords/metaxperts/ordermaster/post/',);
          var result = await api.masterPost(v.toMap(), 'https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/ordermaster/post/',);

        if (result == true&& result1 == true) {
          await db.rawQuery("UPDATE orderMaster SET posted = 1 WHERE orderId = '${i['orderId']}'");

        }
      }
    } }catch (e) {
      if (kDebugMode) {
        print("ErrorRRRRRRRRR: $e");
      }
      return;
    }
  }

  Future<void> postOrderDetails() async {
    final Database db = await initDatabase();
    final ApiServices api = ApiServices();
    try {

      final List<Map<String, dynamic>> records = await db.query('order_details');

      // Print each record
      for (var record in records) {
        if (kDebugMode) {
          print(record.toString());
        }
      }
      // Select only the records that have not been posted yet
      final products = await db.rawQuery('SELECT * FROM order_details WHERE posted = 0');
      if (products.isNotEmpty) {  // Check if the table is not empty
        for (var i in products) {
          if (kDebugMode) {
            print("FIRST ${i.toString()}");
          }

        OrderDetailsModel v = OrderDetailsModel(
            id: i['id'].toString(),
            orderMasterId: i['order_master_id'].toString(),
            productName: i['productName'].toString(),
            price: i['price'].toString(),
            quantity: i['quantity'].toString(),
            amount: i['amount'].toString(),
            userId: i['userId'].toString(),
        );
          var result1 = await api.masterPost(v.toMap(), 'http://103.149.32.30:8080/ords/metaxperts/orderdetail/post/');
          var result = await api.masterPost(v.toMap(), 'https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/orderdetail/post/');
        if(result == true&& result1 == true){
          await db.rawQuery("UPDATE order_details SET posted = 1 WHERE id = '${i['id']}'");
        }
      }}

    } catch (e) {
      if (kDebugMode) {
        print("ErrorRRRRRRRRR: $e");
      }
      return;
    }
  }

  Future<List<String>> getShopNames() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> shopNames = await db.query('ownerData');
      return shopNames.map((map) => map['shop_name'] as String).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving shop names: $e");
      }
      return [];
    }
  }
  Future<List<String>> getCitiesNames() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> citiesNames = await db.query('pakCities');
      return citiesNames.map((map) => map['city'] as String).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving cities names: $e");
      }
      return [];
    }
  }

  Future<List<String>> getDistributorsNames() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> bussinessName = await db.query('distributors');
      return bussinessName.map((map) => map['bussiness_name'] as String).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving bussiness_name: $e");
      }
      return [];
    }
  }

  Future<List<Map<String, dynamic>>?> getOwnersDB() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> owner = await db.query('ownerData');
      return owner;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving products: $e");
      }
      return null;
    }
  }


  Future<List<Map<String, dynamic>>?> getDistributorsDB() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> distributor = await db.query('distributors');
      return distributor;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving products: $e");
      }
      return null;
    }
  }
  Future<List<String>> getShopNamesForCity() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> shopNames = await db.query(
        'ownerData',
        where: 'city = ?',
        whereArgs: [userCitys],
      );
      return shopNames.map((map) => map['shop_name'] as String).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving shop names for city: $e");
      }
      return [];
    }
  }
  Future<List<String>> getDistributorNamesForCity(String userCity) async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> bussinessName = await db.query(
        'distributors',
        where: 'area_name = ?',
        whereArgs: [userCitys],
      );
      return bussinessName.map((map) => map['bussiness_name'] as String).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving sbussiness_name for city: $e");
      }
      return [];
    }
  }



  Future<bool> insertOwnerData(List<dynamic> dataList) async {
    final Database db = await initDatabase();
    try {
      for (var data in dataList) {
        await db.insert('ownerData', data);
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error inserting owner  data: ${e.toString()}");
      }
      return false;
    }
  } Future<bool> insertPakCitiesData(List<dynamic> dataList) async {
    final Database db = await initDatabase();
    try {
      for (var data in dataList) {
        await db.insert('pakCities', data);
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error inserting PakCities  data: ${e.toString()}");
      }
      return false;
    }
  }
  Future<bool> insertDistributorData(List<dynamic> dataList) async {
    final Database db = await initDatabase();
    try {
      for (var data in dataList) {
        await db.insert('distributors', data);
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error inserting distributor  data: ${e.toString()}");
      }
      return false;
    }
  }
  Future<void> deleteAllRecords() async{
    final db = await initDatabase();
   // await db.delete('ownerData');
   // await db.delete('products');
   //  await db.delete('orderMasterData');
    // await db.delete('orderDetailsData');
    await db.delete('orderBookingStatusData');
    await db.delete('netBalance');
    await db.delete('accounts');
    await db.delete('productCategory');
    await db.delete('login');
    await db.delete('distributors');
    await db.delete('recoveryFormGet');
  }
  Future<void>deleteAllRecordsAccounts()async{
    final db = await initDatabase();
    await db.delete('netBalance');
    await db.delete('accounts');
    await db.delete('orderBookingStatusData');
  }

  Future<bool> insertProductsData(List<dynamic> dataList) async {
    final Database db = await initDatabase();
    try {
      for (var data in dataList) {
        await db.insert('products', data);
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error inserting product data: ${e.toString()}");
      }
      return false;
    }
  }
  Future<List<String>> getBrandItems() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> result = await db.query('products');
      return result.map((data) => data['brand'] as String).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching brand items: $e");
      }
      return [];
    }
  }

  Future<Iterable> getProductsNames() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> productNames= await db.query('products');
      return productNames.map((map) => map['product_name'].toList());
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving products: $e");
      }
      return [];
    }
  }

  Future<List<Map<String, dynamic>>?> getProductsDB() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> products = await db.query('products');
      return products;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving products: $e");
      }
      return null;
    }
  }
  Future<List<Map<String, dynamic>>?> getPakCitiesDB() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> products = await db.query('pakCities');
      return products;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving Pak Cities : $e");
      }
      return null;
    }
  }

  Future<List<String>> getProductsNamesByBrand(String selectedBrand) async {
    final Database db = await initDatabase();

    try {
      final List<Map<String, dynamic>> productNames = await db.query(
        'products',
        where: 'brand = ?',
        whereArgs: [globalselectedbrand],
      );

      return productNames.map((map) => map['product_name'] as String).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching product names for brand: $e");
      }
      return [];
    }
  }




  Future<bool> insertAccoutsData(List<dynamic> dataList) async {
    final Database db = await initDatabase();
    try {
      for (var data in dataList) {

        await db.insert('accounts', data);
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error inserting Accounts: ${e.toString()}");
      }
      return false;
    }
  }


  Future<bool> insertNetBalanceData(List<dynamic> dataList) async {
    final Database db = await initDatabase();
    try {
      for (var data in dataList) {
        await db.insert('netBalance', data);
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error inserting netBalanceData: ${e.toString()}");
      }
      return false;
    }
  }



  Future<bool> insertOrderBookingStatusData(List<dynamic> dataList) async {
    final Database db = await initDatabase();
    try {
      for (var data in dataList) {
        if (data['user_id'] == userId) {
        await db.insert('orderBookingStatusData', data);
      }}
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error inserting orderBookingStatusData: ${e.toString()}");
      }
      return false;
    }
  }
  Future<bool> insertOrderBookingStatusData1(List<dynamic> dataList) async {
    final Database db = await initDatabase();
    try {
      for (var data in dataList) {
          await db.insert('orderBookingStatusData', data);
        }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error inserting orderBookingStatusData: ${e.toString()}");
      }
      return false;
    }
  }

  Future<bool> insertRecoveryFormData(List<dynamic> dataList) async {
    final Database db = await initDatabase();
    try {
      for (var data in dataList) {
        if (data['user_id'] == userId) {
        await db.insert('recoveryFormGet', data);
      }}
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error inserting recoveryFormGet: ${e.toString()}");
      }
      return false;
    }
  }
  Future<bool> insertRecoveryFormData1(List<dynamic> dataList) async {
    final Database db = await initDatabase();
    try {
      for (var data in dataList) {

          await db.insert('recoveryFormGet', data);
        }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error inserting recoveryFormGet: ${e.toString()}");
      }
      return false;
    }
  }

  Future<List<String>?> getShopNamesFromNetBalance() async {
    try {
      final List<Map<String, dynamic>>? netBalanceData = await getNetBalanceDB();
      return netBalanceData?.map((map) => map['shop_name'] as String).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving shop names from netBalance: $e");
      }
      return [];
    }
  }
  Future<Map<String, dynamic>> getDebitsAndCreditsTotal() async {
    try {
      final List<Map<String, dynamic>>? netBalanceData = await getNetBalanceDB();
      Map<String, double> shopDebits = {};
      Map<String, double> shopCredits = {};

      for (var row in netBalanceData!) {
        String shopName = row['shop_name'];
        double debit = double.parse(row['debit'] ?? '0');
        double credit = double.parse(row['credit'] ?? '0');

        shopDebits[shopName] = (shopDebits[shopName] ?? 0) + debit;
        shopCredits[shopName] = (shopCredits[shopName] ?? 0) + credit;
      }

      return {'debits': shopDebits, 'credits': shopCredits};
    } catch (e) {
      if (kDebugMode) {
        print("Error calculating debits and credits total: $e");
      }
      return {'debits': {}, 'credits': {}};
    }
  }

  Future<Map<String, double>> getDebitsMinusCreditsPerShop() async {
    try {
      final List<Map<String, dynamic>>? netBalanceData = await getNetBalanceDB();
      Map<String, double> shopDebitsMinusCredits = {};

      for (var row in netBalanceData!) {
        String shopName = row['shop_name'];
        double debit = double.parse(row['debit'] ?? '0');
        double credit = double.parse(row['credit'] ?? '0');

        double debitsMinusCredits = debit - credit;

        shopDebitsMinusCredits[shopName] = (shopDebitsMinusCredits[shopName] ?? 0) + debitsMinusCredits;
      }

      return shopDebitsMinusCredits;
    } catch (e) {
      if (kDebugMode) {
        print("Error calculating debits minus credits per shop: $e");
      }
      return {};
    }
  }

  Future<bool> insertOrderMasterData(List<dynamic> dataList) async {
    final Database db = await initDatabase();
    try {
      for (var data in dataList) {
        if (data['user_id'] == userId) {
          await db.insert('orderMasterData', data);
        }
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error inserting orderMaster data: ${e.toString()}");
      }
      return false;
    }
  }

  Future<bool> insertOrderMasterData1(List<dynamic> dataList) async {
    final Database db = await initDatabase();
    try {
      for (var data in dataList) {

          await db.insert('orderMasterData', data);

      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error inserting orderMaster data: ${e.toString()}");
      }
      return false;
    }
  }

  Future<List<Map<String, dynamic>>?> getNetBalanceDB() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> netbalance = await db.query('netBalance');
      return  netbalance;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving products: $e");
      }
      return null;
    }
  }


  Future<List<Map<String, dynamic>>?> getAccoutsDB() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> account = await db.query('accounts');
      return  account;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving accounts: $e");
      }
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getOrderBookingStatusDB() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> orderbookingstatus = await db.query('orderBookingStatusData', where: 'user_id = ?', whereArgs: [userId]);
      return  orderbookingstatus;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving products: $e");
      }
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getallOrderBookingStatusDB() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> orderbookingstatus = await db.query('orderBookingStatusData');
      return  orderbookingstatus;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving products: $e");
      }
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getOrderMasterDataDB() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> ordermaster = await db.query('orderMasterData');
      return ordermaster;

    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving products: $e");
      }
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getOrderDetailsDB() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> orderdetails = await db.query('orderDetailsData');
      return orderdetails;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving orderDetailsGet: $e");
      }
      return null;
    }
  }


  Future<void> postAttendanceTable() async {
    final Database db = await initDatabase();
    final ApiServices api = ApiServices();

    try {
      final products = await db.rawQuery('select * from attendance');

      if (products.isNotEmpty) {
        for (var i in products) {
          if (kDebugMode) {
            print("Posting attendance for ${i['id']}");
          }

          AttendanceModel v = AttendanceModel(
            id: i['id'].toString(),
            date: i['date'].toString(),
            userId: i['userId'].toString(),
            timeIn: i['timeIn'].toString(),
            latIn: i['latIn'].toString(),
            lngIn: i['lngIn'].toString(),
            bookerName: i['bookerName'].toString(),
            city: i['city'].toString(),
            designation: i['designation'].toString(),
          );

          var result = await api.masterPost(
            v.toMap(),
            'http://103.149.32.30:8080/ords/metaxperts/attendance/post/',

          );

          var result1 = await api.masterPost(
            v.toMap(),
            'https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/attendance/post/',
          );

          if (result == true && result1 == true) {
            await db.rawDelete("DELETE FROM attendance WHERE id = ?", [i['id']]);
          } else if (result != true) {
           final results = await api.masterPost(
              v.toMap(),
              'http://103.149.32.30:8080/ords/metaxperts/attendance/post/',
            );
            if (results == true) {
              await db.rawDelete("DELETE FROM attendance WHERE id = ?", [i['id']]);
            }
          } else if (result1 != true) {
            final results = await api.masterPost(
              v.toMap(),
              'https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/attendance/post/',
            );
            if (results == true) {
              await db.rawDelete("DELETE FROM attendance WHERE id = ?", [i['id']]);
            }
          }
        }
      } else {
        if (kDebugMode) {
          print("Attendance table is empty.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error posting attendance: $e");
      }
    }
  }

  Future<void> postAttendanceOutTable() async {
    final Database db = await initDatabase();
    final ApiServices api = ApiServices();
    try {
      final products = await db.rawQuery('select * from attendanceOut');

      if (products.isNotEmpty || products != null) {  // Check if the table is not empty
        for (var i in products) {
          if (kDebugMode) {
            print("FIRST ${i.toString()}");
          }

          AttendanceOutModel v = AttendanceOutModel(
            id: i['id'].toString(),
            date: i['date'].toString(),
            userId: i['userId'].toString(),
            timeOut: i['timeOut'].toString(),
            totalTime: i['totalTime'].toString(),
            latOut: i['latOut'].toString(),
            lngOut: i['lngOut'].toString(),
            totalDistance: i['totalDistance'].toString()
          );
          var result1 = await api.masterPost(v.toMap(), 'http://103.149.32.30:8080/ords/metaxperts/attendanceout/post/');
          var result = await api.masterPost(v.toMap(), 'https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/attendanceout/post/',);

          if (result == true && result1 == true) {
            if (kDebugMode) {
              print('successfully post');
            }
            await db.rawDelete("DELETE FROM attendanceOut WHERE id = '${i['id']}'");
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("ErrorRRRRRRRRR: $e");
      }
      return;
    }
  }


  Future<bool> insertProductCategory(List<dynamic> dataList) async {
    final Database db = await initDatabase();
    try {
      for (var data in dataList) {
        await db.insert('productCategory', data);
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error inserting product category data: ${e.toString()}");
      }
      return false;
    }
  }


  // Future<List<String>> getBrandItems() async {
  //   final Database db = await initDatabase();
  //   try {
  //     final List<Map<String, dynamic>> result = await db.query('productCategory');
  //     return result.map((data) => data['product_brand'] as String).toList();
  //   } catch (e) {
  //     print("Error fetching brand items: $e");
  //     return [];
  //   }
  // }



  Future<List<Map<String, dynamic>>?> getAllPCs() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> PCs = await db.query('productCategory');
      return PCs;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving products: $e");
      }
      return null;
    }
  }
  Future<List<Map<String, dynamic>>?> getAllAttendance() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> PCs = await db.query('attendance');
      return PCs;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving products: $e");
      }
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getAllAttendanceOut() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> PCs = await db.query('attendanceOut');
      return PCs;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving products: $e");
      }
      return null;
    }
  }
  Future<List<Map<String, dynamic>>?> getRecoveryFormDB() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> products = await db.query('recoveryForm');
      return products;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving products: $e");
      }
      return null;
    }
  }

  Future<void> postRecoveryFormTable() async {
    final Database db = await initDatabase();
    final ApiServices api = ApiServices();

    try {
      final products = await db.rawQuery('select * from recoveryForm');
      if (products.isNotEmpty || products != null)  { // Check if the table is not empty

        for (var i in products) {
          if (kDebugMode) {
            print("FIRST ${i.toString()}");
          }

          RecoveryFormModel v = RecoveryFormModel(
              recoveryId: i['recoveryId'].toString(),
              shopName: i['shopName'].toString(),
              date: i['date'].toString(),
              cashRecovery: i['cashRecovery'].toString(),
              netBalance: i['netBalance'].toString(),
              userId: i['userId'].toString(),
              bookerName: i['bookerName'].toString(),
            city: i['city'].toString(),
            brand: i['brand'].toString(),
          );

          var result1 = await api.masterPost(v.toMap(), 'http://103.149.32.30:8080/ords/metaxperts/recoveryform/post/',);
          var result = await api.masterPost(v.toMap(), 'https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/recoveryform/post/',);

          if (result == true&& result1 == true){
            db.rawQuery(
                "DELETE FROM recoveryForm WHERE recoveryId = '${i['recoveryId']}'");
          }
        }
      }
    }catch (e) {
      if (kDebugMode) {
        print("ErrorRRRRRRRRR: $e");
      }
      return;
    }
  }
  Future<List<Map<String, dynamic>>> getReturnFormDetailsDB() async {
    final db = _db;
    try {
      if (db != null) {
        final List<Map<String, dynamic>> products = await db.rawQuery('SELECT * FROM return_form_details');
        return products;
      } else {
        // Handle the case where the database is null
        return [];
      }
    } catch (e) {
      // Let the calling code handle the error
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>?> getReturnFormDB() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> products = await db.query('returnForm');
      return products;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving products: $e");
      }
      return null;
    }
  }

  Future<void> postReturnFormTable() async {
    final Database db = await initDatabase();
    final ApiServices api = ApiServices();

    try {
      final products = await db.rawQuery('select * from returnForm');
      if (products.isNotEmpty || products != null)  {  // Check if the table is not empty

      for (var i in products) {
        if (kDebugMode) {
          print("FIRST ${i.toString()}");
        }

        ReturnFormModel v =  ReturnFormModel(
          returnId: i['returnId'].toString(),
          shopName: i['shopName'].toString(),
          date: i['date'].toString(),
          returnAmount: i['returnAmount'].toString(),
          bookerId: i['bookerId'].toString(),
          bookerName: i['bookerName'].toString(),
          city: i['city'].toString(),
          brand: i['brand'].toString(),
        );

        bool result1 = await api.masterPost(v.toMap(), 'http://103.149.32.30:8080/ords/metaxperts/returnform/post/',);
        bool result = await api.masterPost(v.toMap(), 'https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/returnform/post/',);

        if (result == true && result1 == true) {
          db.rawQuery("DELETE FROM returnForm WHERE returnId = '${i['returnId']}'");

        }
      }
    }} catch (e) {
      if (kDebugMode) {
        print("ErrorRRRRRRRRR: $e");
      }
      return;
    }
  }

  Future<void> postReturnFormDetails() async {
    final Database db = await initDatabase();
    final ApiServices api = ApiServices();
    try {
      final products = await db.rawQuery('select * from return_form_details');
      var count = 0;
      if (products.isNotEmpty || products != null)  {  // Check if the table is not empty

        for(var i in products){
        if (kDebugMode) {
          print(i.toString());
        }
        count++;
        ReturnFormDetailsModel v = ReturnFormDetailsModel(
          id: "${i['id']}".toString(),
          returnformId: i['returnFormId'].toString(),
          productName: i['productName'].toString(),
          reason: i['reason'].toString(),
          quantity: i['quantity'].toString(),
          bookerId: i['bookerId'].toString(),
        );
        final result1 = await api.masterPost(v.toMap(), 'http://103.149.32.30:8080/ords/metaxperts/returnformdetail/post');
        final result = await api.masterPost(v.toMap(), 'https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/returnformdetail/post');
        if(result == true && result1 == true){
          db.rawQuery('DELETE FROM return_form_details WHERE id = ${i['id']}');
        }
      }
    }} catch (e) {
      if (kDebugMode) {
        print("ErrorRRRRRRRRR: $e");
      }
      return;
    }
  }

  Future<void> addStockCheckItems(List<StockCheckItemsModel> stockCheckItemsList) async {
    final db = _db;
    for (var stockCheckItems in stockCheckItemsList) {
      await db?.insert('Stock_Check_Items',stockCheckItems.toMap());
    }
  }

  Future<List<Map<String, dynamic>>?> getShopVisitDB() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> shopVisit = await db.query('shopVisit');
      return shopVisit;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving shopVisit: $e");
      }
      return null;
    }
  }
  Future<List<Map<String, dynamic>>> getShopVisit({int limit = 0, int offset = 0}) async {
    final db = _db;
    try {
      if (db != null) {
        String query = 'SELECT id, date, shopName, userId, bookerName, brand, walkthrough, planogram, signage, productReviewed, feedback, latitude, longitude, address, body FROM shopVisit';

        // Add LIMIT and OFFSET only if specified
        if (limit > 0) {
          query += ' LIMIT $limit';
        }
        if (offset > 0) {
          query += ' OFFSET $offset';
        }

        final List<Map<String, dynamic>> products = await db.rawQuery(query);

        return products;
      } else {
        // Handle the case where the database is null
        return [];
      }
    } catch (e) {
      // Let the calling code handle the error
      rethrow;
    }
  }


  Future<List<Map<String, dynamic>>> getStockCheckItems() async {
    final db = _db;
    try {
      if (db != null) {
        final List<Map<String, dynamic>> products = await db.rawQuery('SELECT * FROM Stock_Check_Items');
        return products;
      } else {
        // Handle the case where the database is null
        return [];
      }
    } catch (e) {
      // Let the calling code handle the error
      rethrow;
    }
  }

  Future<void> postShopVisitData() async {
    final Database db = await initDatabase();
    final ApiServices api = ApiServices();



    try {
      final products = await db.rawQuery('''SELECT *, 
      CASE WHEN walkthrough = 1 THEN 'True' ELSE 'False' END AS walkthrough,
      CASE WHEN planogram = 1 THEN 'True' ELSE 'False' END AS planogram,
      CASE WHEN signage = 1 THEN 'True' ELSE 'False' END AS signage,
      CASE WHEN productReviewed = 1 THEN 'True' ELSE 'False' END AS productReviewed
      FROM shopVisit
      ''');
      await db.rawQuery('VACUUM');
      if (products.isNotEmpty || products != null)  {  // Check if the table is not empty
      for (Map<dynamic, dynamic> i in products) {
        if (kDebugMode) {
          print("FIRST $i");
        }

        ShopVisitModel v = ShopVisitModel(
          id: i['id'].toString(),
          date: i['date'].toString(),
          userId: i['userId'].toString(),
          shopName: i['shopName'].toString(),
          bookerName: i['bookerName'].toString(),
          brand: i['brand'].toString(),
          walkthrough: i['walkthrough'].toString(),
          planogram: i['planogram'].toString(),
          signage: i['signage'].toString(),
          productReviewed: i['productReviewed'].toString(),
          feedback: i['feedback'].toString(),
          latitude: i['latitude'].toString(),
          longitude: i['longitude'].toString(),
          address: i['address'].toString(),
          body: i['body'] != null && i['body'].toString().isNotEmpty
              ? Uint8List.fromList(base64Decode(i['body'].toString()))
              : Uint8List(0),

        );

        // Print image path before trying to create the file
        if (kDebugMode) {
          print("Image Path from Database: ${i['body']}");
        }
        if (kDebugMode) {
          print("lat:${i['latitude']}");
        }

        // Declare imageBytes outside the if block
        Uint8List imageBytes;
        final directory = await getApplicationDocumentsDirectory();
        final filePath = File('${directory.path}/captured_image.jpg');
        if (filePath.existsSync()) {
          // File exists, proceed with reading the file
          List<int> imageBytesList = await filePath.readAsBytes();
          imageBytes = Uint8List.fromList(imageBytesList);
        } else {
          if (kDebugMode) {
            print("File does not exist at the specified path: ${filePath.path}");
          }
          continue; // Skip to the next iteration if the file doesn't exist
        }
        // Print information before making the API request
        if (kDebugMode) {
          print("Making API request for shop visit ID: ${v.id}");
        }
        var result1 = await api.masterPostWithImage(v.toMap(), 'http://103.149.32.30:8080/ords/metaxperts/report/post/', imageBytes,);
        var result = await api.masterPostWithImage(v.toMap(), 'https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/report/post/', imageBytes,);
        if (result == true && result1 == true) {
          await db.rawQuery('DELETE FROM shopVisit WHERE id = ${i['id']}');
          if (kDebugMode) {
            print("Successfully posted data for shop visit ID: ${v.id}");
          }
         }
        else {
          if (kDebugMode) {
            print("Failed to post data for shop visit ID: ${v.id}");
          }
      }
      }

    }
      } catch (e) {
      if (kDebugMode) {
        print("Error processing shop visit data: $e");
      }
      return;
    }
  }
  Future<void> postlocationdata() async {
    final Database db = await initDatabase();
    final ApiServices api = ApiServices();

    try {
      final products = await db.rawQuery('SELECT * FROM location WHERE posted = 0');
      await db.rawQuery('VACUUM');
      if (products.isNotEmpty || products != null)  {  // Check if the table is not empty
        for (Map<dynamic, dynamic> i in products) {
          if (kDebugMode) {
            print("FIRST $i");
          }

          LocationModel v = LocationModel(
            id: i['id'].toString(),
            date: i['date'].toString(),
            userId: i['userId'].toString(),
            userName: i['userName'].toString(),
            fileName: i['fileName'].toString(),
            totalDistance: i['totalDistance'].toString(),
            body: i['body'] != null && i['body'].toString().isNotEmpty
                ? Uint8List.fromList(base64Decode(i['body'].toString()))
                : Uint8List(0),
          );

          // Print image path before trying to create the file
          if (kDebugMode) {
            print("Image Path from Database: ${i['body']}");
          }
          final date = DateFormat('dd-MM-yyyy').format(DateTime.now());

          // Declare imageBytes outside the if block

          Uint8List gpxBytes;
          final downloadDirectory = await getDownloadsDirectory();
           final filePath = File('${downloadDirectory?.path}/track$date.gpx');
          if (filePath.existsSync()) {
            // File exists, proceed with reading the file
            List<int> imageBytesList = await filePath.readAsBytes();
            gpxBytes = Uint8List.fromList(imageBytesList);
          } else {
            if (kDebugMode) {
              print("File does not exist at the specified path: ${filePath.path}");
            }
            continue; // Skip to the next iteration if the file doesn't exist
          }
          // Print information before making the API request
          if (kDebugMode) {
            print("Making API request for shop visit ID: ${v.id}");
          }
          var result1 = await api.masterPostWithGPX(v.toMap(), 'http://103.149.32.30:8080/ords/metaxperts/location/post/', gpxBytes,);
          var result = await api.masterPostWithGPX(v.toMap(), 'https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/location/post/', gpxBytes,);
          if (result == true && result1 == true) {
            await db.rawUpdate("UPDATE location SET posted = 1 WHERE id = ?", [i['id']]);
            if (kDebugMode) {
              print("Successfully posted data for shop visit ID: ${v.id}");
            }
          }
          else {
            if (kDebugMode) {
              print("Failed to post data for shop visit ID: ${v.id}");
            }
          }
        }

      }
    } catch (e) {
      if (kDebugMode) {
        print("Error processing shop visit data: $e");
      }
      return;
    }
  }
  Future<void> postStockCheckItems() async {
    final Database db = await initDatabase();
    final ApiServices api = ApiServices();
    try {
      final products = await db.rawQuery('select * from Stock_Check_Items');
      var count = 0;
      if (products.isNotEmpty || products != null)  {  // Check if the table is not empty

        for(var i in products){
        if (kDebugMode) {
          print(i.toString());
        }
        count++;
        StockCheckItemsModel v =StockCheckItemsModel(
          id: "${i['id']}${i['shopvisitId']}".toString(),
          shopvisitId: i['shopvisitId'].toString(),
          itemDesc: i['itemDesc'].toString(),
          qty: i['qty'].toString(),
        );
        var result1 = await api.masterPost(v.toMap(), 'http://103.149.32.30:8080/ords/metaxperts/shopvisit/post/');
        var result = await api.masterPost(v.toMap(), 'https://g77e7c85ff59092-db17lrv.adb.ap-singapore-1.oraclecloudapps.com/ords/metaxperts/shopvisit/post/');
        if(result == true && result1 == true){
          db.rawQuery('DELETE FROM Stock_Check_Items WHERE id = ${i['id']}');
        }
      }
    } }catch (e) {
      if (kDebugMode) {
        print("ErrorRRRRRRRRR: $e");
      }
      return;
    }
  }

  Future<bool> insertLogin(List<dynamic> dataList) async {
    final Database db = await initDatabase();
    try {
      for (var data in dataList) {
        await db.insert('login', data);
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error inserting login data: ${e.toString()}");
      }
      return false;
    }
  }
  Future<bool>login(Users user) async{
    final Database db = await initDatabase();
    var results=await db.rawQuery("select * from login where user_id = '${user.user_id}' AND password = '${user.password}'");
    if(results.isNotEmpty){
      return true;
    }
    else{
      return false;
    }
  }

  Future<List<Map<String, dynamic>>?> getAllLogins() async {
    final Database db = await initDatabase();
    try {
      final List<Map<String, dynamic>> logins = await db.query('login');
      return logins;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving products: $e");
      }
      return null;
    }
  }
  Future<String?> getUserName(String userId) async {
    final Database db = await initDatabase();
    try {
      var results = await db.rawQuery("select user_name from login where user_id = '$userId'");
      if (results.isNotEmpty) {
        // Explicitly cast to String
        return results.first['user_name'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user name: $e");
      }
      return null;
    }
  }
  Future<String?> getUserCity(String userId) async {
    final Database db = await initDatabase();
    try {
      var results = await db.rawQuery("select city from login where user_id = '$userId'");
      if (results.isNotEmpty) {
        // Explicitly cast to String
        return results.first['city'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user city: $e");
      }
      return null;
    }
  }
  Future<String?> getUserDesignation(String userId) async {
    final Database db = await initDatabase();
    try {
      var results = await db.rawQuery("select designation from login where user_id = '$userId'");
      if (results.isNotEmpty) {
        // Explicitly cast to String
        return results.first['designation'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user designation: $e");
      }
      return null;
    }
  }


}
