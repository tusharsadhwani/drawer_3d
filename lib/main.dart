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
          animation: _animation,
          onDismissed: _closeDrawer,
          drawerWidth: width,
        ),
      ],
    );
  }
}

class MyDrawer extends StatelessWidget {
  final double drawerWidth;
  final Function onDismissed;
  final Animation animation;

  const MyDrawer({Key key, this.drawerWidth, this.onDismissed, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => Stack(
        children: <Widget>[
          GestureDetector(
            onTap: animation.value == 1 ? onDismissed : null,
          ),
          Transform.translate(
            offset: Offset(-drawerWidth * (1 - animation.value), 0),
            child: Transform(
              alignment: Alignment.centerRight,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(pi / 2 * (1 - animation.value)),
              child: Material(
                child: Container(
                  width: drawerWidth,
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
