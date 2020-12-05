
import 'package:flutter/material.dart';
class SlideBottomRoute extends PageRouteBuilder {
  final Widget widget;
  final String mName;
 
  SlideBottomRoute({this.widget, this.mName})
      : super(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {

        return widget;
      },
      settings: RouteSettings(name: mName),

      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {

        return new SlideTransition(

          position: new Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,

        );
      }
  );
}


