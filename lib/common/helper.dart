import 'package:fluttertoast/fluttertoast.dart';

class Helper{
  static showToast(String txt){
    Fluttertoast.showToast(msg: txt,  gravity: ToastGravity.CENTER,);
  }
}