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
  Animation<double> boxAnimation;
  AnimationController boxController;

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

    boxController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    // Radians value
    boxAnimation = Tween(
      begin: pi * 0.1,
      end: pi * 0.15,
    ).animate(
      CurvedAnimation(
        parent: boxController,
        curve: Curves.linear,
      ),
    );

    boxAnimation.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        boxController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxController.forward();
      }
    });

    boxController.forward();
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
              buildLeftFlap(),
              buildRightFlap(),
            ],
          ),
        ),
      ),
    );
  }

  void onTap() {
    if (catController.status == AnimationStatus.completed) {
      catController.reverse();
      // If cat is going inside box then start box animation
      boxController.forward();
    } else if (catController.status == AnimationStatus.dismissed) {
      catController.forward();
      // If cat is comint out of the box then stop box animation
      boxController.stop();
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
      left: 0.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          width: 10.0,
          height: 125.0,
          color: Colors.brown,
        ),
        builder: (BuildContext context, Widget child) {
          return Transform.rotate(
            child: child,
            angle: boxAnimation.value,
            alignment: Alignment.topLeft,
          );
        },
      ),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 0.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          width: 10.0,
          height: 125.0,
          color: Colors.brown,
        ),
        builder: (BuildContext context, Widget child) {
          return Transform.rotate(
            child: child,
            angle: -boxAnimation.value,
            alignment: Alignment.topRight,
          );
        },
      ),
    );
  }
}
