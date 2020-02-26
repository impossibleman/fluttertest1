import 'dart:math';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'datastructor/GoodsDetail.dart';
import 'datastructor/GoodsClassify.dart';
import 'commontool/NetworkTool.dart';
import 'package:flutter_test_01/datastructor/PeanutObject.dart';
import 'package:dio/dio.dart';

void main() => runApp(new HomeContainer());

//class TestWidget extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new _AnimationTestState();
//  }
//}

class AniationWidget extends StatefulWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text("Animation test"),
//      ),
//      body: new Center(
//        child: new RaisedButton(
//          onPressed: () {
//            new EdgeInsetsTween().animate(CurvedAnimation(
//                parent: new AnimationController(
//                    duration: Duration(milliseconds: 1500), vsync: this),
//                curve: null));
//          },
//        ),
//      ),
//    );
//  }

  @override
  _AnimationTestState createState() {
    return new _AnimationTestState();
  }
}

class _AnimationTestState extends State<AniationWidget>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  CurvedAnimation curvedAnimation;
  AnimationController mController;
  bool isReverse = false;
//  var positioned=new Positioned(child: new Text("look"));

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
      appBar: new AppBar(
        title: new Text("Animation"),
      ),
      floatingActionButton: new FloatingActionButton(onPressed: () {
        isReverse ? mController.reverse() : mController.forward();
      }),
      body: new ScaleTransition(
        scale: curvedAnimation,
        child: new RaisedButton(
          onPressed: null,
        ),
      ),
//      body: new Positioned(
//        child: new Text("look"),
//        left: animation.value,
//        top: animation.value,
//      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    mController = new AnimationController(
      duration: new Duration(milliseconds: 1500),
      vsync: this,
    );
    var tween = new Tween(begin: 1.0, end: 10.0);
    animation = tween.animate(mController);
    animation.addListener(() {
      if (animation.isCompleted) {
        isReverse = !isReverse;
      }
    });

    curvedAnimation =
        new CurvedAnimation(parent: mController, curve: Curves.bounceIn);
  }
}

//class PageContainer extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("pagerview"),
//      ),
//      body: Container(
//        child: PageView(children: <Widget>[
//          Image.asset('images/test_image.png',fit: BoxFit.fitHeight,),
//          Image.asset("images/test02.png",fit: BoxFit.fitHeight),
//          Image.asset("images/test03.jpg",fit: BoxFit.fitHeight),
//          Image.asset("images/test04.png",fit: BoxFit.fitHeight)
//        ],),height: 150.0,
//      )
//    );
//  }
//}

class HomeContainer extends StatelessWidget {
  SimpleViewPager simpleViewPager=new SimpleViewPager();
  Socket socket;
  Stream<List<int>> stream;
  List<GoodsClassify> classifies=new List<GoodsClassify>();

  _BeginNetConnection() async {
    try {//192.168.3.46:8888
//      HttpClient client=new HttpClient();
//      var requset=await client.getUrl(Uri.parse("12322"));
//      var response=await requset.close();
//      response.transform(utf8.decoder).join();
      socket=await Socket.connect("192.168.3.46", 8888);
      stream=socket.asBroadcastStream();
      await _ProcessNetRequest();
    } catch (e) {}
  }

  _ProcessNetRequest(){
     bool isTransportFinished=false;
    String sendMessage=_CreateNetRequestMessage();
    socket.write(sendMessage);
    socket.flush();
    stream.listen((event){
      String recievedMessage="";
      print(event.length);
      for(int index=0;index!=3;index++){
        recievedMessage+=utf8.decode(event);
      }
      print(recievedMessage);
      String requestType=_parseResult(recievedMessage);

    });
  }

  String _CreateNetRequestMessage(){
    String message="";
    message+="{requesttype:9:goodsinfo}";
    return message;
  }

  String _parseResult(String recievedMessage){
    String requestType;
    List<PeanutObject> objs=NetWorkTool.ParseNetResult(recievedMessage);
    if(objs.isNotEmpty){
      PeanutObject headPeanut=objs[0];
      requestType=headPeanut.GetValue("requesttype");
      if(requestType.compareTo("goodsinfo")==0){
        for(var index=1;index!=objs.length;index++){
          bool isClassifyExist=false;
          PeanutObject currentPeanutObject=objs[index];
          int classifyId=int.parse(currentPeanutObject.GetValue("classifyid"));
          if(classifies.length==0){
            GoodsClassify currentClassify=_CreateClassify(classifyId,currentPeanutObject);
            classifies.add(currentClassify);
          }
          else{
            for(GoodsClassify singleClassify in classifies){
              if(singleClassify.classifyId==classifyId){
                isClassifyExist=true;
                singleClassify.GoodsInfo.add(_CreateGoodsDetail(currentPeanutObject));
                break;
              }
            }
            if(!isClassifyExist){
              GoodsClassify currentClassify=_CreateClassify(classifyId,currentPeanutObject);
              classifies.add(currentClassify);
            }
          }
        }
      }
      else if(requestType.compareTo("end")==0){
        simpleViewPager.SetGoodsInfo(classifies);
      }
      else{

      }
    }
    return requestType;
  }

  GoodsClassify _CreateClassify(int classifyId,PeanutObject currentPeanutObject){
    GoodsClassify currentClassify=new GoodsClassify();
    currentClassify.classifyId=classifyId;
    currentClassify.classifyName=currentPeanutObject.GetValue("classifyname");
    currentClassify.GoodsInfo.add(_CreateGoodsDetail(currentPeanutObject));
    return currentClassify;
  }

  GoodsDetail _CreateGoodsDetail(PeanutObject currentPeanutObject){
    GoodsDetail detail=new GoodsDetail();
    detail.goodsId=int.parse(currentPeanutObject.GetValue("goodsid"));
    detail.name=currentPeanutObject.GetValue("goodsname");
    detail.description=currentPeanutObject.GetValue("goodsdecription");
    detail.originalPrice=double.parse(currentPeanutObject.GetValue("originalprice"));
    detail.currentPrice=double.parse(currentPeanutObject.GetValue("currentprice"));
    return detail;
  }

  @override
  Widget build(BuildContext context) {
    _BeginNetConnection();
    return new MaterialApp(
      title: "viewpager test",
      home: simpleViewPager,
    );
  }
}

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

class SimpleViewPager extends StatefulWidget {

  ViewPagerState viewPagerState=new ViewPagerState();

  void SetGoodsInfo(List<GoodsClassify> classifies){
    viewPagerState.SetGoodsClassifies(classifies);
  }
  @override
  State createState() {
    return viewPagerState;
  }
}

class ViewPagerState extends State<SimpleViewPager> {

  ItemClassifyBuilder classifyBuilder;
  GoodsItemDisplay goodsItemDisplay=new GoodsItemDisplay();
  final _pageController = new PageController();
  static const _duration = const Duration(milliseconds: 500);
  static const _curve = Curves.ease;
  final _arrowColor = Colors.black.withOpacity(0.8);
  final List<String> imgUrl = <String>[
    'images/test_image.png',
    'images/test02.png',
    'images/test03.jpg'
  ];
  final List<Widget> _pages = <Widget>[
    new ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: new Image.asset(
          'images/test_image.png',
          fit: BoxFit.fill,
        )),
    new ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: new Image.asset(
          'images/test02.png',
          fit: BoxFit.fill,
        )),
    new ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: new Image.asset(
          'images/test03.jpg',
          fit: BoxFit.fill,
        )),
  ];

  void SetGoodsClassifies(List<GoodsClassify> classifies){
    classifyBuilder.SetGoodsClassifies(classifies);
    goodsItemDisplay.SetGoodsInfo(classifies[0].GoodsInfo);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("ViewPager"),
      ),
      body: new Column(
        children: <Widget>[
          new Center(
            child: new IconTheme(
                data: new IconThemeData(color: _arrowColor),
                child: new Container(
                  height: 150.0,
                  child: new Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: <Widget>[
                      new GestureDetector(
                        child: new PageView.builder(
                            physics: new AlwaysScrollableScrollPhysics(),
                            controller: _pageController,
                            itemBuilder: (BuildContext context, int index) {
                              return _pages[index % _pages.length];
                            }),
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
          new Row(
            children: <Widget>[
              new Container(
                child: classifyBuilder=new ItemClassifyBuilder(goodsItemDisplay),
                width: 130,
                height: 330,
              ),
              new Container(
                child: goodsItemDisplay,
                width: 230,
                height: 330,
              )
            ],
          )
        ],
      ),
    );
  }
}

class ItemClassifyBuilder extends StatefulWidget {
  GoodsItemDisplay goodsItemDisplay;
  ItemClassifyState itemClassifyState;

  ItemClassifyBuilder(this.goodsItemDisplay);

  void SetGoodsClassifies(List<GoodsClassify> classifies){
    itemClassifyState.SetGoodsClassifies(classifies);
  }

  @override
  ItemClassifyState createState() {
    return itemClassifyState=new ItemClassifyState(goodsItemDisplay);
  }
}

class ItemClassifyState extends State<ItemClassifyBuilder> {
  GoodsItemDisplay goodsItemDisplay;
  List<GoodsClassify> _classifies=new List();

  ItemClassifyState(this.goodsItemDisplay);

  void SetGoodsClassifies(List<GoodsClassify> classifies){
    print("Goods classify data update!");
    _classifies=classifies;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        GoodsClassify currentClassify=_classifies[index];
        return new GestureDetector(
          child: new Center(
            child: new Text(currentClassify.classifyName+"("+currentClassify.GoodsInfo.length+")"),
          ),
          onTap: (){
            goodsItemDisplay.SetGoodsInfo(currentClassify.GoodsInfo);
          },
        );
      },
      itemCount: _classifies.length,
      shrinkWrap: true,
    );
  }
}

class GoodsItemDisplay extends StatefulWidget {
  GoodsItemState goodsItemState=new GoodsItemState();

  SetGoodsInfo(List<GoodsDetail> goodsInfo){
    goodsItemState.SetGoodsInfo(goodsInfo);
  }

  @override
  State createState() {
    return goodsItemState;
  }
}

class GoodsItemState extends State<GoodsItemDisplay> {
  List<GoodsDetail> _goodsInfo = new List();

  SetGoodsInfo(List<GoodsDetail> goodsInfo){
    print("Goods item data update!");
    _goodsInfo=goodsInfo;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        GoodsDetail currentInfo=_goodsInfo[index];
        return new GestureDetector(
          child: new Row(
            children: <Widget>[
              new Container(
                child: Image.asset("images/test04.png"),
                padding: EdgeInsets.all(10.0),
              ),
              new Column(
                children: <Widget>[
                  new Center(child: new Text(currentInfo.name)),
                  new Center(child: new Text(currentInfo.description),),
                  new Positioned(
                    child: new Text(currentInfo.currentPrice),
                    right: 0.0,
                    bottom: 0.0,
                  )
                ],
              )
            ],
          ),
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new GoodsDetailRoute(_goodsInfo[index])));
          },
        );
      },
      itemCount: _goodsInfo.length,
    );
  }
}

class ImageDisplayRoute extends StatelessWidget {
  List<String> imgUrl;

  ImageDisplayRoute(this.imgUrl);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "ImageDiplay",
      home: new Scaffold(
        body: new Center(
          child: new GestureDetector(
            child: new PageView.builder(
              itemBuilder: (context, index) {
                return new Image.asset(imgUrl[index]);
              },
              itemCount: imgUrl.length,
            ),
            onTap: () {
              Navigator.of(context).pop(0);
            },
          ),
        ),
      ),
    );
  }
}

class GoodsDetailRoute extends StatelessWidget {
  GoodsDetail goodsDetail;
  GoodsDetailRoute(this.goodsDetail);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new GestureDetector(
        child: new Column(
          children: <Widget>[
            new Container(
              height: 500,
              child: new Image.asset("images/test02.png"),
            ),
            new Column(
              children: <Widget>[
                new Text(goodsDetail.name),
                new Text(goodsDetail.description),
                new Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    child: new Text(goodsDetail.currentPrice.toString()))
              ],
            )
          ],
        ),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
