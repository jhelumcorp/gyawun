import 'package:flutter/cupertino.dart';

class HomeScreenProvider extends ChangeNotifier {
  List _homeData = [];
  bool _loading = true;
  get getData => _homeData;
  get isLoading => _loading;
  addData(data) {
    _homeData = data;
    _loading = false;
    notifyListeners();
  }
}
