import 'package:flutter/material.dart';

class CollectionRoute extends StatefulWidget {
  @override
  State createState() {
    return new CollectionState();
  }
}

class CollectionState extends State<CollectionRoute> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new Builder(builder: (context) {
          return IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              });
        }),
        title: new Text("Collection"),
      ),
      body: new Text("collection"),
    );
  }
}
