import 'package:flutter/material.dart';

class TransparentRoute extends PageRouteBuilder {
  final Widget widget;

  TransparentRoute({this.widget})
      : super(
            opaque: true,
            transitionDuration: Duration(days: 1),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return widget;
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return new SlideTransition(
                position: new Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
}


