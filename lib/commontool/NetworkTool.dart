import 'dart:io';
import 'package:flutter_test_01/datastructor/PeanutObject.dart';

class NetWorkTool {
  static Socket mSocket;

  static void CreateSocket(Socket socket) {
    mSocket = socket;
  }

  static Socket GetSocket() {
    return mSocket;
  }

  static List<PeanutObject> ParseNetResult(String result) {
    List<PeanutObject> peanutObjects = new List<PeanutObject>();
    try {
      while (result != null && result.length != 0) {
        if (result.startsWith("{")) {
          result = result.substring(1);
          PeanutObject obj = new PeanutObject();
          if (result.startsWith("}")) {
            if (result.length > 1) {
              result = result.substring(1);
            } else {
              result = "";
            }
            break;
          }
          int endPosition=result.indexOf("}");
          String oneObject=result.substring(0,endPosition);
          List<String> values=new List();
          if(oneObject.contains(",")){
            values=oneObject.split(",");
          }
          else{
            values.add(oneObject);
          }
          for(String eachValue in values){
            int fieldNamePosition = eachValue.indexOf(":");
            String fieldName = eachValue.substring(0, fieldNamePosition);
            String restValue = eachValue.substring(fieldNamePosition + 1);
            if(restValue.contains("@comma")){
              restValue=restValue.replaceAll("@comma", ",");
            }
            obj.SetValue(fieldName, restValue);
          }
          result=result.substring(endPosition+1);
          peanutObjects.add(obj);
        } else {
          print("parse result error----- " + result);
          break;
        }
      }
    } catch (e) {
      print("parse result error----- " + e.toString());
    }
    return peanutObjects;
  }
}
