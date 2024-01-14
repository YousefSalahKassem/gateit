import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterProvider extends ChangeNotifier {
  static final provider = ChangeNotifierProvider((ref) => CounterProvider());

  int _counter = 0;

  int get counter => _counter;

  set counter(int value) {
    _counter = value;
    notifyListeners();
  }
}
