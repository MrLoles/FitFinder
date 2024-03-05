import 'package:flutter/cupertino.dart';

class NavigationAnimation{

  ///
  /// Smooth swipe between current screen and [newScreen]
  ///
  static Route changeScreenWithAnimationRTL(Widget newScreen){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => newScreen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}