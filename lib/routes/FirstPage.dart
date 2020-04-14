import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_test_01/datastructor/GoodsDetail.dart';
import 'package:flutter_test_01/datastructor/GoodsClassify.dart';
import 'package:flutter_test_01/commontool/NetworkTool.dart';
import 'package:flutter_test_01/datastructor/PeanutObject.dart';
import 'package:flutter_test_01/constant/ConstantAssemble.dart';
import 'package:flutter_test_01/database/DBOperator.dart';
import 'package:flutter_test_01/constant/NativeResource.dart';
import 'GoodsDetailRoute.dart';
import 'ImageDisplayRoute.dart';

/**
 *
 * @Classname HomeContainer
 * @Decription Main page,shows goods lists
 * @Author Alexander
 * @Createdate 2020/2/26
 */
class FirstPage extends StatelessWidget {
  SimpleViewPager simpleViewPager = new SimpleViewPager();
  Socket socket;
  Stream<List<int>> stream;
//
//  _BeginNetConnection() async {
//    try {
//      //192.168.3.46:8888
////      HttpClient client=new HttpClient();
////      var requset=await client.getUrl(Uri.parse("12322"));
////      var response=await requset.close();
////      response.transform(utf8.decoder).join();
//      socket = await Socket.connect("192.168.3.46", 8888);
//      stream = socket.asBroadcastStream();
//      await _ProcessNetRequest();
//    } catch (e) {}
//  }
//
//  _ProcessNetRequest() {
//    bool isTransportFinished = false;
//    String sendMessage = _CreateNetRequestMessage();
//    socket.write(sendMessage);
//    socket.flush();
//    stream.listen((event) {
//      String recievedMessage = "";
//      print(event.length);
//      for (int index = 0; index != 3; index++) {
//        recievedMessage += utf8.decode(event);
//      }
//      print(recievedMessage);
//      String requestType = _parseResult(recievedMessage);
//    });
//  }
//
//  String _CreateNetRequestMessage() {
//    String message = "";
//    message += "{requesttype:9:goodsinfo}";
//    return message;
//  }
//
//  String _parseResult(String recievedMessage) {
//    String requestType;
//    List<PeanutObject> objs = NetWorkTool.ParseNetResult(recievedMessage);
//    if (objs.isNotEmpty) {
//      PeanutObject headPeanut = objs[0];
//      requestType = headPeanut.GetValue("requesttype");
//      if (requestType.compareTo("goodsinfo") == 0) {
//        for (var index = 1; index != objs.length; index++) {
//          bool isClassifyExist = false;
//          PeanutObject currentPeanutObject = objs[index];
//          int classifyId =
//              int.parse(currentPeanutObject.GetValue("classifyid"));
//          if (classifies.length == 0) {
//            GoodsClassify currentClassify =
//                _CreateClassify(classifyId, currentPeanutObject);
//            classifies.add(currentClassify);
//          } else {
//            for (GoodsClassify singleClassify in classifies) {
//              if (singleClassify.classifyId == classifyId) {
//                isClassifyExist = true;
//                singleClassify.GoodsInfo.add(
//                    _CreateGoodsDetail(currentPeanutObject));
//                break;
//              }
//            }
//            if (!isClassifyExist) {
//              GoodsClassify currentClassify =
//                  _CreateClassify(classifyId, currentPeanutObject);
//              classifies.add(currentClassify);
//            }
//          }
//        }
//      } else if (requestType.compareTo("end") == 0) {
//        simpleViewPager.SetGoodsInfo(classifies);
//      } else {}
//    }
//    return requestType;
//  }
//
//  GoodsClassify _CreateClassify(
//      int classifyId, PeanutObject currentPeanutObject) {
//    GoodsClassify currentClassify = new GoodsClassify();
//    currentClassify.classifyId = classifyId;
//    currentClassify.classifyName = currentPeanutObject.GetValue("classifyname");
//    currentClassify.GoodsInfo.add(_CreateGoodsDetail(currentPeanutObject));
//    return currentClassify;
//  }
//
//  GoodsDetail _CreateGoodsDetail(PeanutObject currentPeanutObject) {
//    GoodsDetail detail = new GoodsDetail();
//    detail.goodsId = int.parse(currentPeanutObject.GetValue("goodsid"));
//    detail.name = currentPeanutObject.GetValue("goodsname");
//    detail.description = currentPeanutObject.GetValue("goodsdecription");
//    detail.originalPrice =
//        double.parse(currentPeanutObject.GetValue("originalprice"));
//    detail.currentPrice =
//        double.parse(currentPeanutObject.GetValue("currentprice"));
//    return detail;
//  }

  @override
  Widget build(BuildContext context) {
    return simpleViewPager;
  }
}

/**
*
* @Classname DotIndicator
* @Decription the dot and animation at bottom of viewpager
* @Author
* @Createdate 2020/2/29
*/
class DotIndicator extends AnimatedWidget {
  DotIndicator(
      {this.pageController,
      this.itemCount,
      this.onPageSelected,
      this.color: Colors.white})
      : super(listenable: pageController);

  final PageController pageController;
  final int itemCount;
  final ValueChanged<int> onPageSelected;
  final Color color;
  static const double _kDotSize = 8.0;
  static const double _kMaxZoom = 2.0;
  static const double _kDotSpacing = 15.0;

  Widget _DotBuild(int index) {
    double selectedValue = Curves.easeOut.transform(max(
        0.0,
        1.0 -
            ((pageController.page ?? pageController.initialPage.toDouble()) -
                    index.toDouble())
                .abs()));
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedValue;
    return new Container(
      width: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: color,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () => onPageSelected,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _DotBuild),
    );
  }
}

/**
*
* @Classname SimpleViewPager
* @Decription a viewpager to display some images
* @Author
* @Createdate 2020/2/29
*/
class SimpleViewPager extends StatefulWidget {
  @override
  State createState() {
    return new ViewPagerState();
  }
}

class ViewPagerState extends State<SimpleViewPager> {
  List<GoodsClassify> _classifies;
  Socket socket;
  DBOperator operator;
  Stream<List<int>> stream;
  var currentClassifyIndex = 0;
  var isFirstRequest = true;
  final MethodChannel methodChannel = const MethodChannel("firstcall");
  final _pageController = new PageController();
  static const _duration = const Duration(milliseconds: 500);
  static const _curve = Curves.ease;
  final _arrowColor = Colors.black.withOpacity(0.8);
  final List<String> imgUrl = <String>[
    'images/fruits.jpg',
    'images/meat01.jpg',
    'images/vegetables04.jpg'
  ];
  final List<Widget> _pages = <Widget>[
    new ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: new Image.asset(
          'images/fruits.jpg',
          fit: BoxFit.fill,
        )),
    new ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: new Image.asset(
          'images/meat01.jpg',
          fit: BoxFit.fill,
        )),
    new ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: new Image.asset(
          'images/vegetables04.jpg',
          fit: BoxFit.fill,
        )),
  ];

  @override
  void initState() {
    print("beging to init");
    _classifies = new List();
//    _CreateLocalData();
    SendHttpRequest(ConstantAssemble.NET_REQUEST_TYPE_GOODSCLASSIFY);
  }

  void SendHttpRequest(String requestType) async {
//    int resultCode = await methodChannel.invokeMethod("checknet");
    Connectivity connectivity = new Connectivity();
    ConnectivityResult result=await connectivity.checkConnectivity();
    if (result!=ConnectivityResult.none) {
      print("begin to request");
      try {
        if (socket == null) {
          socket = await Socket.connect("192.168.3.46", 8888,
              timeout: new Duration(milliseconds: 1500));
          stream = socket.asBroadcastStream();
          stream.listen((event) {
            String recievedMessage = "";
            recievedMessage = utf8.decode(event);
            print(
                recievedMessage.length.toString() + "-----" + recievedMessage);
            _parseResult(recievedMessage);
            if (isFirstRequest) {
              SendHttpRequest(ConstantAssemble.NET_REQUEST_TYPE_GOODSINFO);
              isFirstRequest = !isFirstRequest;
            }
          });
        }
        //this passage is about http request
//          HttpClient client=new HttpClient();
//      var requset=await client.getUrl(Uri.parse("12322"));
//      var response=await requset.close();
//      response.transform(utf8.decoder).join();
        String sendMessage = _CreateNetRequestMessage(requestType);
        socket.write(sendMessage);
        socket.flush();
      } catch (e) {
        print("Net request exception: ----- " + e.toString());
        GetLocalData();
      }
    } else {
      GetLocalData();
    }
  }

  GetLocalData() async {
    operator = new DBOperator();
    int resultCode = await operator.InitDbInstance();
    print("sql init result" + resultCode.toString());
    if (isFirstRequest) {
      List<GoodsClassify> tempClassify = await operator.GetClassify();
      if (tempClassify.length != 0) {
        setState(() {
          _classifies.addAll(tempClassify);
        });
      }
      isFirstRequest = !isFirstRequest;
    }
    if (_classifies.length != 0) {
      List<GoodsDetail> tempDetails = await operator.GetGoodsinfos(
          _classifies[currentClassifyIndex].classifyId);
      if (tempDetails.length != 0) {
        setState(() {
          if (_classifies[currentClassifyIndex].GoodsInfo.length == 0) {
            _classifies[currentClassifyIndex].GoodsInfo.addAll(tempDetails);
          }
        });
      }
    }
  }

  String _parseResult(String recievedMessage) {
    print("begin to parse");
    String requestType;
    List<PeanutObject> objs = NetWorkTool.ParseNetResult(recievedMessage);
    print("PeanutObject ----- length: " + objs.length.toString());
    List<GoodsClassify> tempClassifies = new List();
    List<GoodsDetail> tempDetails = new List();
    if (objs.isNotEmpty) {
      PeanutObject headPeanut = objs[0];
      requestType = headPeanut.GetValue("requesttype");
      print("PeanutObject ----- requesttype: " + requestType);
      if (requestType.compareTo(ConstantAssemble.NET_REQUEST_TYPE_GOODSINFO) ==
          0) {
        for (var index = 1; index != objs.length; index++) {
          PeanutObject currentPeanutObject = objs[index];
          var classifyId = _classifies[currentClassifyIndex].classifyId;
          GoodsDetail detail = new GoodsDetail();
          detail.goodsId = int.parse(currentPeanutObject.GetValue("goodsid"));
          detail.name = currentPeanutObject.GetValue("goodsname");
          detail.description = currentPeanutObject.GetValue("goodsdecription");
          if (classifyId == 1) {
            detail.imageUrl = NativeResource.vegetableImage[index - 1];
          } else if (classifyId == 2) {
            detail.imageUrl = NativeResource.meatImage[index - 1];
          } else {
            detail.imageUrl = "images/test04.png";
          }
          detail.originalPrice =
              double.parse(currentPeanutObject.GetValue("originalprice"));
          detail.currentPrice =
              double.parse(currentPeanutObject.GetValue("currentprice"));
          detail.classifyid =
              int.parse(currentPeanutObject.GetValue("classifyid"));
          detail.classifyname = currentPeanutObject.GetValue("classifyname");
          tempDetails.add(detail);
        }
        print("goodsdetail ----- parse finished, result: " +
            tempDetails.length.toString());
        setState(() {
          _classifies[currentClassifyIndex].GoodsInfo.addAll(tempDetails);
        });
        StoreIntoDatabase(ConstantAssemble.DATABASE_STORE_TYPE_DETAIL);
      } else if (requestType
              .compareTo(ConstantAssemble.NET_REQUEST_TYPE_GOODSCLASSIFY) ==
          0) {
        for (var index = 1; index != objs.length; index++) {
          PeanutObject currentPeanutObject = objs[index];
          GoodsClassify currentClassify = new GoodsClassify();
          currentClassify.classifyId =
              int.parse(currentPeanutObject.GetValue("classifyid"));
          currentClassify.classifyName =
              currentPeanutObject.GetValue("classifyname");
          tempClassifies.add(currentClassify);
        }
        print("goodsclassify ----- parse finished, result: " +
            tempClassifies.length.toString());
        setState(() {
          _classifies.addAll(tempClassifies);
        });
        StoreIntoDatabase(ConstantAssemble.DATABASE_STORE_TYPE_CLASSIFY);
      } else if (requestType
              .compareTo(ConstantAssemble.NET_REQUEST_TYPE_IMAGE) ==
          0) {
        getApplicationDocumentsDirectory();
      } else {}
    }
    return requestType;
  }

  void StoreIntoDatabase(int storeType) async {
    operator = new DBOperator();
    int resultCode = await operator.InitDbInstance();
    if (storeType == ConstantAssemble.DATABASE_STORE_TYPE_CLASSIFY) {
      operator.StoreClassify(_classifies);
    } else {
      operator.StoreGoodsInfos(_classifies[currentClassifyIndex].classifyId,
          _classifies[currentClassifyIndex].GoodsInfo);
    }
  }

  String _CreateNetRequestMessage(String type) {
    String message = "";
    if (type.compareTo(ConstantAssemble.NET_REQUEST_TYPE_GOODSINFO) == 0) {
      var id = _classifies[currentClassifyIndex].classifyId.toString();
      message += "{requesttype:9:" +
          ConstantAssemble.NET_REQUEST_TYPE_GOODSINFO +
          "}{classifyid:" +
          id.length.toString() +
          ":" +
          id +
          "}";
    } else if (type
            .compareTo(ConstantAssemble.NET_REQUEST_TYPE_GOODSCLASSIFY) ==
        0) {
      message += "{requesttype:13:" +
          ConstantAssemble.NET_REQUEST_TYPE_GOODSCLASSIFY +
          "}";
    } else if (type.compareTo(ConstantAssemble.NET_REQUEST_TYPE_IMAGE) == 0) {
      message +=
          "{requesttype:5:" + ConstantAssemble.NET_REQUEST_TYPE_IMAGE + "}";
    } else {}
    return message;
  }

//  void _CreateLocalData() {
//    for (int index = 0; index != 5; index++) {
//      String GoodsName = GoodsNames[index];
//      GoodsClassify singleClassify = new GoodsClassify();
//      singleClassify.classifyId = index;
//      int currentIndex = index;
//      singleClassify.classifyName = "Number " + currentIndex.toString();
//      for (int itemIndex = 0; itemIndex != 10 + index; itemIndex++) {
//        GoodsDetail detail = new GoodsDetail();
//        detail.goodsId = itemIndex + index * 10;
//        detail.description =
//            "This is the " + detail.goodsId.toString() + " item";
//        detail.name = GoodsName + itemIndex.toString();
//        detail.originalPrice = 5;
//        detail.currentPrice = 5 +
//            (itemIndex % 10).toDouble() / 10.toDouble();
//        singleClassify.GoodsInfo.add(detail);
//      }
//      _classifies.add(singleClassify);
//    }
//    _goodsInfo = _classifies[0].GoodsInfo;
//  }

  @override
  Widget build(BuildContext context) {
    List<GoodsDetail> _goodsInfo;
    if (_classifies.length != 0) {
      _goodsInfo = _classifies[currentClassifyIndex].GoodsInfo;
    } else {
      _goodsInfo = new List();
    }
    return new Column(
      children: <Widget>[
        new Center(//image viewpager
          child: new IconTheme(
              data: new IconThemeData(color: _arrowColor),
              child: new Container(
                height: 220.0,
                child: new Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: <Widget>[
                    new GestureDetector(
                      child: new PageView.builder(
                        physics: new AlwaysScrollableScrollPhysics(),
                        controller: _pageController,
                        itemBuilder: (BuildContext context, int index) {
                          return _pages[index % _pages.length];
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    new ImageDisplayRoute(imgUrl)));
                      },
                    ),
                    new Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: new Container(
                          color: Colors.grey.withOpacity(0.7),
                          padding: const EdgeInsets.all(5.0),
                          child: new Center(
                            child: new DotIndicator(
                              pageController: _pageController,
                              itemCount: _pages.length,
                              onPageSelected: (int index) {
                                _pageController.animateToPage(index,
                                    duration: _duration, curve: _curve);
                              },
                            ),
                          ),
                        ))
                  ],
                ),
              )),
        ),
        new Expanded(child: new Row(
          children: <Widget>[
            new Container(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  GoodsClassify currentClassify = _classifies[index];
                  return new GestureDetector(
                    child: new Container(
                      child: new Center(
                        child: new Text(currentClassify.classifyName +
                            "(" +
                            currentClassify.GoodsInfo.length.toString() +
                            ")"),
                      ),
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                    ),
                    onTap: () {
                      setState(() {
                        _goodsInfo = currentClassify.GoodsInfo;
                        currentClassifyIndex = index;
                        if (_goodsInfo.length == 0) {
                          SendHttpRequest(
                              ConstantAssemble.NET_REQUEST_TYPE_GOODSINFO);
                        }
                        print("press classify: item number ----- " +
                            _goodsInfo.length.toString());
                      });
                    },
                  );
                },
                itemCount: _classifies.length,
                shrinkWrap: true,
              ),
              width: 130,
            ),
            new Container(
              child: new ListView.builder(
                itemBuilder: (context, index) {
                  GoodsDetail currentInfo = _goodsInfo[index];
                  return new GestureDetector(
                    child: new Row(
                      children: <Widget>[
                        new Container(
                          child: Image.asset(currentInfo.imageUrl),
                          margin: EdgeInsets.only(right: 10),
                          width: 50,
                          height: 50,
                        ),
                        new Column(
                          children: <Widget>[
                            new Container(
                              child: new Text(
                                currentInfo.name,
                                style: new TextStyle(fontSize: 16),
                              ),
                              width: 150,
                            ),
                            new Container(
                              child: new Text(currentInfo.description),
                              width: 150,
                            ),
                            new Row(
                              children: <Widget>[
                                new Container(
                                  child: new Text(
                                    currentInfo.currentPrice.toString(),
                                    style: new TextStyle(
                                        fontSize: 12, color: Colors.red),
                                  ),
                                  width: 110,
                                  alignment: AlignmentDirectional.bottomEnd,
                                ),
                                new Text(
                                  " 元/斤",
                                  style: new TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) =>
                          new GoodsDetailRoute(_goodsInfo[index])));
                    },
                  );
                },
                itemCount: _goodsInfo.length,
                shrinkWrap: true,
              ),
              width: 230,
            )
          ],
        ))
      ],
    );
  }
}
