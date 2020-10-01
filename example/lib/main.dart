import 'package:drawer_3d/drawer_3d.dart';
import 'package:drawer_3d/scaffold_3d.dart';
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
      home: Scaffold3D(
        title: 'Flutter Demo Home Page',
        children: [
          DrawerItem('Home'),
          DrawerItem('Test'),
        ],
      ),
    );
  }
}
