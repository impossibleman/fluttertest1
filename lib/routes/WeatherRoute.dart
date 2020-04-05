import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter_test_01/datastructor/WeatherInfo.dart';

class WeatherRoute extends StatefulWidget {
  @override
  State createState() {
    return new WeatherState();
  }
}

class WeatherState extends State<WeatherRoute> {
  WeatherInfo weatherInfo;

  @override
  void initState() {
    // TODO: implement initState
    weatherInfo=new WeatherInfo();
    SendHttpRequest();
  }

  SendHttpRequest() async {
        Dio().get("https://tianqiapi.com/api?version=v6&appid=73749658&appsecret=rtMEF8Qt").then((response){
          Map<String,dynamic> result = response.data;
          print(result);
//          Map<String,dynamic> jsonResult=json.decode(result);
          setState(() {
            weatherInfo.FromJson(result);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("天气"),
        ),
        body: new Center(
          child: Column(
            children: <Widget>[
              new Container(
                child: new Text(weatherInfo.city,style: new TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),),
                margin: EdgeInsets.only(
                  top: 100.0,
                  bottom: 15.0
                ),
              ),
              new Container(
                child: new Text(weatherInfo.wea,style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.cyan,
                    decoration: TextDecoration.underline
                ),),
                margin: EdgeInsets.only(
                    top: 15.0,
                    bottom: 15.0
                ),
              ),
              new Container(
                child: new Text(weatherInfo.tem1+"~"+weatherInfo.tem2,style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.purple,
                    decoration: TextDecoration.underline
                ),),
                margin: EdgeInsets.only(
                    top: 15.0,
                    bottom: 15.0
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
