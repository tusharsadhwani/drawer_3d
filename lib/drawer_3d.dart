library drawer_3d;

import 'dart:math' show pi;

import 'package:flutter/material.dart';

class Drawer3D extends StatefulWidget {
  final double drawerWidth;
  final Function onDismissed;
  final AnimationController controller;
  final Animation animation;
  final List<Widget> children;

  const Drawer3D({
    Key key,
    @required this.controller,
    @required this.drawerWidth,
    @required this.onDismissed,
    @required this.animation,
    @required this.children,
  }) : super(key: key);

  @override
  _Drawer3DState createState() => _Drawer3DState();
}

class _Drawer3DState extends State<Drawer3D> {
  bool canBeDragged;

  @override
  void initState() {
    canBeDragged = false;
    super.initState();
  }

  void onDragStart(DragStartDetails details) {
    bool isClosed = widget.controller.isDismissed;

    bool isOpen = widget.controller.isCompleted;

    canBeDragged = (isClosed && details.globalPosition.dx < 60) || isOpen;
  }

  void onDragUpdate(DragUpdateDetails details) {
    if (canBeDragged) {
      double delta = details.primaryDelta / widget.drawerWidth;
      widget.controller.value += delta;
    }
  }

  void onDragEnd(DragEndDetails details) {
    //I have no idea what it means, copied from Drawer
    double _kMinFlingVelocity = 365.0;

    if (widget.controller.isDismissed || widget.controller.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity =
          details.velocity.pixelsPerSecond.dx / widget.drawerWidth;

      widget.controller.fling(velocity: visualVelocity);
    } else if (widget.controller.value < 0.5) {
      widget.controller.reverse();
    } else {
      widget.controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (_, __) => Stack(
        children: <Widget>[
          GestureDetector(
            onTap: widget.animation.value == 1 ? widget.onDismissed : null,
            onHorizontalDragStart: onDragStart,
            onHorizontalDragUpdate: onDragUpdate,
            onHorizontalDragEnd: onDragEnd,
          ),
          Transform.translate(
            offset:
                Offset(-widget.drawerWidth * (1 - widget.animation.value), 0),
            child: Transform(
              alignment: Alignment.centerRight,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(pi / 2 * (1 - widget.animation.value)),
              child: Material(
                child: Container(
                  width: widget.drawerWidth,
                  height: double.infinity,
                  color: Colors.blue,
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 180,
                          child: FittedBox(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                'Drawer',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: widget.children,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String text;

  DrawerItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
