import 'package:angular2/core.dart';

class Handler {

  String state; // текущее состояние скрипта

  List<dynamic> onDataCallbacks;
  List<dynamic> onErrorCallbacks;
  List<dynamic> onDoneCallbacks;

  Handler(){

    onDataCallbacks = new List<dynamic>();
    onErrorCallbacks = new List<dynamic>();
    onDoneCallbacks = new List<dynamic>();

  }
}
