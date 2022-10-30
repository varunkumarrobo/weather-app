import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:weatherapp/data_model.dart';

class DatabaseManager {
  late Database _database;

  Future<Database> initDb() async {
    _database = await openDatabase(
        join(await getDatabasesPath(), "weather.db"),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE favourites(cityName TEXT NOT NULL, country TEXT NOT NULL, PRIMARY KEY(cityName, country))",
      );
      await db.execute(
        "CREATE TABLE recent(cityName TEXT NOT NULL, country TEXT NOT NULL, PRIMARY KEY(cityName, country))",
      );
    });
    return _database;
  }

  Future<void> insertFav(DataModel model) async {
    await initDb();
    await _database.insert('favourites', model.toJson());
  }

  Future<void> insertRecent(DataModel model) async {
    await initDb();
    await _database.insert('recent', model.toJson());
  }

  Future<void> deleteAllFav() async {
    await initDb();
    await _database.rawQuery("DELETE FROM favourites");
  }

  Future<void> deleteAllRecent() async {
    await initDb();
    await _database.rawQuery("DELETE FROM recent");
  }

  Future<void> deleteFav(DataModel model) async {
    await initDb();
    await _database.delete('favourites', where: "cityName = ? AND country = ?", whereArgs: [model.cityName,model.country]);
  }

  Future<List<DataModel>> getFav() async {
    final db = await initDb();
    final List<Map<String, dynamic>> queryResult = await db.query('favourites');
    return List.generate(queryResult.length, (i) {
      return DataModel(
          cityName: queryResult[i]['cityName'],
          country: queryResult[i]['country']);
    });
  }

  Future<List<DataModel>> getRecent() async {
    final db = await initDb();
    final List<Map<String, dynamic>> queryResult = await db.query('recent');
    return List.generate(queryResult.length, (i) {
      return DataModel(
          cityName: queryResult[i]['cityName'],
          country: queryResult[i]['country']);
    });
  }

}

class DataModel {
  String cityName;
  String country;

  DataModel({required this.cityName, required this.country});

  DataModel fromJson(json) {
    return DataModel(cityName: json['cityName'], country: json['country']);
  }
  Map<String, dynamic> toJson() {
    return {'cityName': cityName, 'country':country};
  }

}