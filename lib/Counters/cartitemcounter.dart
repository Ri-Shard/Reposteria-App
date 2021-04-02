import 'package:flutter/foundation.dart';
import 'package:e_shop/Config/config.dart';

class CartItemCounter extends ChangeNotifier{

  int _counter = ReposteriaApp.sharedPreferences.getStringList(ReposteriaApp.userCartList).length-1;
  int get count => _counter;
}