import 'package:flutter/material.dart';
import 'package:flutter_test_01/constant/NativeResource.dart';
import 'package:flutter_test_01/database/DBOperator.dart';

class HeadImageEditRoute extends StatefulWidget {
  int currentIndex;

  HeadImageEditRoute(this.currentIndex){

}
  @override
  State createState() {
    return new HeadImageEditState(currentIndex);
  }
}

class HeadImageEditState extends State<HeadImageEditRoute>{
  int currentIndex;

  HeadImageEditState(this.currentIndex){

  }

  StoreHeadImageIndex() async{
    DBOperator operator = new DBOperator();
    int resultCode = await operator.InitDbInstance();
    int secondResultCode=await operator.StoreHeadImageIndex(currentIndex);
    Navigator.pop(context,currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(child: new Scaffold(
      appBar: new AppBar(),
      body: new GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 15.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 1.0),
        itemBuilder: (context,index){
          return new GestureDetector(
            child: new Container(
              child: new Image.asset(NativeResource.headImages[index]),
            ),
            onTap: (){
              currentIndex=index;
              StoreHeadImageIndex();
            },
          );
        },
        itemCount: NativeResource.headImages.length,),
    ), onWillPop: (){
      Navigator.pop(context,currentIndex);
    });
  }
}
