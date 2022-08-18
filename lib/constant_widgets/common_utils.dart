import 'package:internet_connection_checker/internet_connection_checker.dart';

class CommonUtils {
  Future<bool> getInternetAction() async {
    return await InternetConnectionChecker().hasConnection;
  }
}
