import 'package:flutter/material.dart';
import 'package:flutter_test_01/datastructor/GoodsDetail.dart';

/**
*
* @Classname GoodsDetailRoute
* @Decription this route shows goods description and other infomation
* @Author
* @Createdate 2020/2/29
*/
class GoodsDetailRoute extends StatelessWidget {
  GoodsDetail goodsDetail;
  GoodsDetailRoute(this.goodsDetail);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("Detail"),
      ),
      body: new GestureDetector(
        child: new Column(
          children: <Widget>[
            new Container(
              child: new Image.asset("images/test02.png"),
            ),
            new Container(
                child: new Column(
                  children: <Widget>[
                    new Text(goodsDetail.name),
                    new Text(goodsDetail.description),
                    new Container(
                        alignment: AlignmentDirectional.centerEnd,
                        child: new Text(goodsDetail.currentPrice.toString())),
                  ],
                ))
          ],
        ),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}