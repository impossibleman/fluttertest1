import 'package:flutter/material.dart';
import 'routes/FirstPage.dart';
import 'package:flutter_test_01/routes/FirstPage.dart';
import 'package:flutter_test_01/routes/SecondPage.dart';
import 'package:flutter_test_01/routes/ThirdPage.dart';

void main() => runApp(new BasePage());

//class TestWidget extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new _AnimationTestState();
//  }
//}

class AnimationWidget extends StatefulWidget {
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

class _AnimationTestState extends State<AnimationWidget>
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

class BasePage extends StatefulWidget {

  @override
  State createState() {
    return new BaseState();
  }
}

class BaseState extends State<BasePage>{
  PageController pageController=new PageController();
  final List<BottomNavigationBarItem> navigationBarItems = [
    new BottomNavigationBarItem(
        title: new Text("firstpage"),
        icon: new Container(width: 30,height: 30,child: new Image.asset('images/20098_1-1.png'),)),
    new BottomNavigationBarItem(
        title: new Text("secondpage"),
        icon: new Container(width: 30,height: 30,child: new Image.asset('images/20540_1-1.png'),)),
    new BottomNavigationBarItem(
        title: new Text("thirdpage"),
        icon: new Container(width: 30,height: 30,child: new Image.asset('images/1019412_1-1.png'),)),
  ];
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "first flutter demo",
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("ViewPager"),
        ),
        body: new PageView.builder(
          itemBuilder: (context, index) {
            if (index == 0) {
              return new FirstPage();
            } else if (index == 1) {
              return new SecondPage();
            } else {
              return new ThirdPage();
            }
          },
          itemCount: 3,
          onPageChanged: _OnPageChanged,
          controller: pageController,
        ),
        bottomNavigationBar: new BottomNavigationBar(
          items: navigationBarItems,
          currentIndex: tabIndex,
          onTap: _OnTabChanged,
        ),
      ),
    );
  }

  void _OnPageChanged(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  void _OnTabChanged(int index) {
    pageController.jumpToPage(index);
    _OnPageChanged(index);
  }
}
