import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
    controller=VideoPlayerController.asset("videos/Nobulletbyhenan.mp4")..initialize().then((_){
      setState(() {

      });
    });
    controller.setVolume(0.3);
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
            new Offstage(
              offstage: isPlaying,
              child: new Icon(Icons.pause_circle_outline),
            ),
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

  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }
}
