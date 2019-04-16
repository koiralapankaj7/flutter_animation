import 'package:flutter/material.dart';
import '../widgets/cat.dart';
import 'dart:math';

/*
 * Home will be created multiple time 
 */
class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

/*
 * Home state will create only once and we hold on that
 */
class HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catController;

  @override
  void initState() {
    super.initState();

    catController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    /*
     * catController and catAnimation does not know that its been used to change the spacing of the widget.
     * All catAnimation knows is its goona start of at 0 and its goona go upto a 100 and that change is going
     * to occure over the span of 2 seconds. That is all catAnimation understand.
     */
    catAnimation = Tween(begin: -35.0, end: -80.0).animate(
      // Curved animation will describe how quickly animation value should be changed from 0 to 100.
      // Rate at which we are changing the value
      CurvedAnimation(
        parent: catController,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation'),
      ),
      body: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              buildCatAnimation(),
              buildBox(),
            ],
          ),
        ),
      ),
    );
  }

  void onTap() {
    if (catController.status == AnimationStatus.completed) {
      catController.reverse();
    } else if (catController.status == AnimationStatus.dismissed) {
      catController.forward();
    }
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (BuildContext context, Widget child) {
        /*
       * This builder will run 60 times per second i.e, 60fps.
       * So if we build any widget inside builder function, widget ended up with recreating 
       * itself 60 times per second. That is very bad from performance point of view.
       * That is why we are creating child inside AnimatedBuilder widget (child property below thi fun)
       * insted of inside builder function.
       * Child parameter inside builder function will just reference child widget of Animated Builder
       * and only changes values of that widget. In this way we will create widget only once and only values
       * will be changed through builder function.
       */
        return Positioned(
          child: child,
          top: catAnimation.value,
          right: 0.0,
          left: 0.0,
        );
      },
      child: Cat(),
    );
  }

  Widget buildBox() {
    return Container(
      width: 200.0,
      height: 200.0,
      color: Colors.brown,
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 3.0,
      child: Transform.rotate(
        child: Container(
          width: 10.0,
          height: 125.0,
          color: Colors.brown,
        ),
        angle: pi / 0.6, //90 degree ..radians
        alignment: Alignment.topLeft,
      ),
    );
  }
}
