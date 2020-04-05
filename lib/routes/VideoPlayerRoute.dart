import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new RunVideoPlayer();
  }
}

class RunVideoPlayer extends StatefulWidget {
  @override
  State createState() {
    return new RunVideoPlayerState();
  }
}

class RunVideoPlayerState extends State<RunVideoPlayer> {
  VideoPlayerController controller;
bool isPlaying=false;

  @override
  void initState() {
    controller=new VideoPlayerController.network("http://baobab.kaiyanapp.com/api/v4/video/related?id=188045");
    controller.play();
    isPlaying=true;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Video player"),
      ),
      body: new GestureDetector(
        child: new Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            new VideoPlayer(controller),
            new Icon(Icons.pause_circle_outline),
          ],
        ),
        onTap: (){
          if(isPlaying){
            controller.pause();
            isPlaying=false;
          }
          else{
            controller.play();
            isPlaying=true;
          }
        },
      )
    );
  }
}
