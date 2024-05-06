

import '../Databases/DBHelper.dart';
import '../Models/LocationModel.dart';


class LocationRepository {

  DBHelper dbHelper = DBHelper();

  Future<List<LocationModel>> getLocation() async {
    var dbClient = await dbHelper.db;
    List<Map> maps = await dbClient!.query('location', columns: ['id', 'date' , 'fileName' , 'userId' ,'userName','totalDistance','body', 'posted' ]);
    List<LocationModel> location = [];

    for (int i = 0; i < maps.length; i++) {
      location.add(LocationModel.fromMap(maps[i]));
    }
    return location;
  }
  Future<int> add(LocationModel locationModel) async{
    var dbClient = await dbHelper.db;
    return await dbClient!.insert('location' , locationModel.toMap());
  }

  Future<int> update(LocationModel locationModel) async{
    var dbClient = await dbHelper.db;
    return await dbClient!.update('location', locationModel.toMap(),
        where: 'id= ?', whereArgs: [locationModel.id] );
  }

  Future<int> delete(int id) async{
    var dbClient = await dbHelper.db;
    return await dbClient!.delete('location',
        where: 'id=?', whereArgs: [id] );
  }


}



