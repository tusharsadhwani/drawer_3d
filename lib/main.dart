import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutQuad,
    );
  }

  void _openDrawer() {
    _controller.forward();
  }

  void _closeDrawer() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.7;

    return Stack(
      children: [
        Container(
          color: Colors.blueGrey.shade700,
        ),
        AnimatedBuilder(
          animation: _animation,
          builder: (_, __) => Transform.translate(
            offset: Offset(width * _animation.value, 0),
            child: Transform(
              alignment: Alignment.centerLeft,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(-pi / 2 * _animation.value),
              child: Scaffold(
                appBar: AppBar(
                  title: Text(widget.title),
                  leading: IconButton(
                      icon: Icon(Icons.menu), onPressed: _openDrawer),
                ),
                body: Center(
                  child: Text(
                    'Hello World!',
                    style: TextStyle(fontSize: 36, color: Colors.grey.shade600),
                  ),
                ),
              ),
            ),
          ),
        ),
        MyDrawer(
          controller: _controller,
          animation: _animation,
          onDismissed: _closeDrawer,
          drawerWidth: width,
        ),
      ],
    );
  }
}

class MyDrawer extends StatefulWidget {
  final double drawerWidth;
  final Function onDismissed;
  final AnimationController controller;
  final Animation animation;

  const MyDrawer({
    Key key,
    @required this.controller,
    @required this.drawerWidth,
    @required this.onDismissed,
    @required this.animation,
  }) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
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
                          children: [
                            DrawerItem('Home'),
                            DrawerItem('Test'),
                          ],
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
