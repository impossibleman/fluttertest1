import 'dart:io';
import 'package:flutter_test_01/datastructor/PeanutObject.dart';

class NetWorkTool {

  static Socket mSocket;

  static void CreateSocket(Socket socket){
    mSocket=socket;
  }

  static Socket GetSocket(){
    return mSocket;
  }

  static List<PeanutObject> ParseNetResult(String result){
    List<PeanutObject> peanutObjects=new List<PeanutObject>();
    while(result!=null&&result.length!=0){
//            int fieldNamePosition=result.indexOf(":");
//            String fieldName=result.substring(0,fieldNamePosition);
//            result=result.substring(fieldNamePosition+1);
//            int contentPosition=result.indexOf(":");
//            int contentLength=Integer.parseInt(result.substring(0,contentPosition));
//            String content=result.substring(contentPosition+1);
//            result=result.substring(contentPosition+1+contentLength);
//            obj.SetValue(fieldName,content);
      if(result.startsWith("{")){
        result=result.substring(1);
        PeanutObject obj=new PeanutObject();
        while(true){
          if(result.startsWith("}")){
            if(result.length>1){
              result=result.substring(1);
            }
            else{
              result="";
            }
            break;
          }
          int fieldNamePosition=result.indexOf(":");
          String fieldName=result.substring(0,fieldNamePosition);
          result=result.substring(fieldNamePosition+1);
          int contentPosition=result.indexOf(":");
          int contentLength=int.parse(result.substring(0,contentPosition));
          String content=result.substring(contentPosition+1,contentPosition+1+contentLength);
          result=result.substring(contentPosition+1+contentLength);
          obj.SetValue(fieldName,content);
        }
        peanutObjects.add(obj);
      }
      else{
      }
    }
    return peanutObjects;
  }
}