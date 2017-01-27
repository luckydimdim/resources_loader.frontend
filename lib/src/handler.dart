import 'dart:async';
import 'package:angular2/core.dart';

class Handler {

  String state; // текущее состояние скрипта

  List<dynamic> onDataCallbacks;
  List<dynamic> onErrorCallbacks;
  List<dynamic> onDoneCallbacks;
  List<Completer> onCompleterCallbacks;

  Handler(){

    onDataCallbacks = new List<dynamic>();
    onErrorCallbacks = new List<dynamic>();
    onDoneCallbacks = new List<dynamic>();
    onCompleterCallbacks = new List<Completer>();

  }
}
