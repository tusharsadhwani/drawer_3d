import 'dart:math' show pi;

import 'package:drawer_3d/drawer_3d.dart';
import 'package:flutter/material.dart';

class Scaffold3D extends StatefulWidget {
  Scaffold3D({
    Key key,
    @required this.title,
    @required this.children,
  }) : super(key: key);

  final String title;
  final List<Widget> children;

  @override
  _Scaffold3DState createState() => _Scaffold3DState();
}

class _Scaffold3DState extends State<Scaffold3D>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
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
        Drawer3D(
          controller: _controller,
          animation: _animation,
          onDismissed: _closeDrawer,
          drawerWidth: width,
          children: widget.children,
        ),
      ],
    );
  }
}
