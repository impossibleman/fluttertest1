import 'package:flutter/material.dart';

/**
*
* @Classname ImageDisplayRoute
* @Decription shows the high resolution ratio image
* @Author
* @Createdate 2020/2/29
*/
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