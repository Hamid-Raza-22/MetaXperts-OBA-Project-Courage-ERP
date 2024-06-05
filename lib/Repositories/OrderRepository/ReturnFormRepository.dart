
import 'package:flutter/foundation.dart';

import '../../API/ApiServices.dart';
import '../../Databases/DBHelper.dart';
import '../../Models/ReturnFormModel.dart';


class ReturnFormRepository{

  DBHelper dbHelperReturnForm = DBHelper();

  Future<List<ReturnFormModel>> getReturnForm() async{
    var dbClient = await dbHelperReturnForm.db;
    List<Map> maps = await dbClient!.query('returnForm',columns: ['returnId','date','shopName', 'returnAmount','bookerId', 'bookerName', 'city', 'brand' ]);
    List<ReturnFormModel> returnform = [];
    for(int i = 0; i<maps.length; i++)
    {
      returnform.add(ReturnFormModel.fromMap(maps[i]));
    }
    return returnform;
  }
  Future<void> postReturnFormTable() async {
    var db = await dbHelperReturnForm.db;
    final ApiServices api = ApiServices();

    try {
      final products = await db!.rawQuery('SELECT * FROM returnForm');
      if (products.isNotEmpty) {
        for (var i in products) {
          if (kDebugMode) {
            print("Posting return form for ${i['returnId']}");
          }

          ReturnFormModel v = ReturnFormModel(
            returnId: i['returnId'].toString(),
            shopName: i['shopName'].toString(),
            date: i['date'].toString(),
            returnAmount: i['returnAmount'].toString(),
            bookerId: i['bookerId'].toString(),
            bookerName: i['bookerName'].toString(),
            city: i['city'].toString(),
            brand: i['brand'].toString(),
          );

          try {
            final results = await Future.wait([
              api.masterPost(v.toMap(), 'http://103.149.32.30:8080/ords/metaxperts/returnform/post/'),
             // api.masterPost(v.toMap(), 'https://apex.oracle.com/pls/apex/metaxpertss/returnform/post/'),
            ]);

            if (results[0] == true) {
              if (kDebugMode) {
                print('Successfully posted return form for ID: ${i['returnId']}');
              }
              await db.rawDelete("DELETE FROM returnForm WHERE returnId = ?", [i['returnId']]);
            } else {
              if (kDebugMode) {
                print('Failed to post return form for ID: ${i['returnId']}');
              }
            }
          } catch (e) {
            if (kDebugMode) {
              print("Error posting return form for ID: ${i['returnId']} - $e");
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error processing return form data: $e");
      }
    }
  }

  Future<String> getLastId() async {
    var dbClient = await dbHelperReturnForm.db;
    List<Map> maps = await dbClient!.query(
      'returnForm',
      columns: ['returnId'],
      orderBy: 'returnId DESC',
      limit: 1,
    );

    if (maps.isEmpty) {
      // Handle the case when no records are found
      return "";
    }

    // Convert the orderId to a string and return
    return maps[0]['returnId'].toString();
  }


  Future<int> add(ReturnFormModel returnform) async{
    var dbClient = await dbHelperReturnForm.db;
    return await dbClient!.insert('returnForm', returnform.toMap());
  }

  Future<int> update(ReturnFormModel returnform) async{
    var dbClient = await dbHelperReturnForm.db;
    return await dbClient!.update('returnForm',returnform.toMap(),
        where: 'returnId = ?', whereArgs: [returnform.returnId]);
  }


  Future<int> delete(int returnId) async{
    var dbClient = await dbHelperReturnForm.db;
    return await dbClient!.delete('returnForm',
        where: 'returnId = ?', whereArgs: [returnId]);
  }




}

