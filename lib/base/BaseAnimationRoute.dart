import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class BaseAnimationRoute extends PageRouteBuilder {
  final Widget widget;

  BaseAnimationRoute(this.widget)
      : super(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (BuildContext context, Animation<double> animFirst,
                Animation<double> animSecond) {
              return widget;
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animFirst,
                Animation<double> animSecond,
                Widget child) {
              return SlideTransition(
                position: Tween<Offset>(
                        begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                    .animate(CurvedAnimation(
                        parent: animFirst, curve: Curves.decelerate)),
                child: child,
              );
            });
}
