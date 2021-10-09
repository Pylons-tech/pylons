import 'package:shared_preferences/shared_preferences.dart';


abstract class LocalDataSource {

}



class LocalDataSourceImp implements LocalDataSource{
  SharedPreferences sharedPreferences;

  LocalDataSourceImp(this.sharedPreferences);
}

