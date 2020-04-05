import 'package:flutter/material.dart';
import 'VideoPlayerRoute.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: new Column(
        children: <Widget>[
          new GestureDetector(
            child: new Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                new Image.asset("images/fruits.jpg"),
                new Image.asset("images/play_small.jpg"),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => new VideoPlayerRoute()));
            },
          ),
          new Container(
            child: new Divider(
              height: 2.0,
              color: Colors.black87,
              indent: 20,
              endIndent: 20,
            ),
            margin: EdgeInsets.only(top: 10, bottom: 10),
          ),
          new GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1),
            itemBuilder: (context, index) {
              String imageUrl;
              if (index % 2 == 0) {
                imageUrl = "images/fruits02.jpg";
              } else {
                imageUrl = "images/fruits03.jpg";
              }
              return new Container(
                child: new GestureDetector(
                  child: new Column(
                    children: <Widget>[
                      new Image.asset(imageUrl),
                      new Text("This is the title")
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new VideoPlayerRoute()));
                  },
                ),
              );
            },
            physics: new NeverScrollableScrollPhysics(),
            itemCount: 10,
            shrinkWrap: true,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
