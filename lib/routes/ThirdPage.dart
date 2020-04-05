import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'HeadImageEditRoute.dart';
import 'CollectionRoute.dart';
import 'WeatherRoute.dart';
import 'package:flutter_test_01/base/BaseAnimationRoute.dart';
import 'package:flutter_test_01/database/DBOperator.dart';
import 'package:flutter_test_01/constant/NativeResource.dart';

class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new PersonalInfo();
  }
}

class PersonalInfo extends StatefulWidget {
  @override
  State createState() {
    return new PersonalInfoState();
  }
}

class PersonalInfoState extends State<PersonalInfo> {
  final MethodChannel methodChannel = const MethodChannel("firstcall");
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    GetHeadImageIndex();
  }

  GetHeadImageIndex() async {
    DBOperator operator = new DBOperator();
    int resultCode = await operator.InitDbInstance();
    int index = await operator.GetHeadImageIndex();
    setState(() {
      currentIndex = index;
    });
  }

//  @override
//  Widget build(BuildContext context) {
//    return new RaisedButton(onPressed: (){
//      print("pressed");
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
          child: new Row(
            children: <Widget>[
              new GestureDetector(
                  onTap: () {
                    print("change head image");
                    Navigator.of(context)
                        .push(new MaterialPageRoute(
                            builder: (context) => new HeadImageEditRoute(currentIndex)))
                        .then((index) {
                      setState(() {
                        currentIndex = index;
                      });
                    });
                  },
                  child: new Container(
                    child: new CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          AssetImage(NativeResource.headImages[currentIndex]),
                      backgroundColor: Colors.transparent,
                    ),
                    decoration: new BoxDecoration(shape: BoxShape.circle),
                    margin: EdgeInsets.only(left: 25.0),
                  )),
              new Container(
                child: new Text("User funny"),
                margin: EdgeInsets.only(left: 10.0),
              )
            ],
          ),
          padding: EdgeInsets.all(15),
        ),
        new Divider(
          height: 2.0,
          color: Colors.black87,
          indent: 20,
          endIndent: 20,
        ),
        new GestureDetector(
          child: new Container(
            child: new Center(
              child: new Text(
                "收藏",
                style: new TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            constraints: BoxConstraints(
              minWidth: 300,
            ),
            color: Colors.white,
          ),
          onTap: () {
            Navigator.of(context)
                .push(new BaseAnimationRoute(new CollectionRoute()));
          },
        ),
        new Divider(
          height: 2.0,
          color: Colors.black87,
          indent: 20,
          endIndent: 20,
        ),
        new GestureDetector(
          child: new Container(
            child: new Text(
              "看看天气",
              style: new TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            padding: EdgeInsets.all(15),
          ),
          onTap: () {
            print("check weather");
            Navigator.of(context)
                .push(new BaseAnimationRoute(new WeatherRoute()));
          },
        ),
        new Divider(
          height: 2.0,
          color: Colors.black87,
          indent: 20,
          endIndent: 20,
        ),
        new Container(
          child: new Text(
            "设置",
            style: new TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          padding: EdgeInsets.all(15),
        ),
        new Divider(
          height: 2.0,
          color: Colors.black87,
          indent: 20,
          endIndent: 20,
        ),
        new GestureDetector(
          child: new Container(
            child: new Text(
              "for test",
              style: new TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            padding: EdgeInsets.all(15),
          ),
          onTap: () {
            print("press this");
            _GetAndroidData();
          },
        ),
        new Divider(
          height: 2.0,
          color: Colors.black87,
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }

  _GetAndroidData() async {
    try {
      methodChannel.invokeMethod("test");
    } on PlatformException catch (e) {
      print(e.message);
    }
  }
}
