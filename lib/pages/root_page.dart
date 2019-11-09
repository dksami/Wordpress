import 'package:flutter/material.dart';
import 'package:wordpress/pages/home.dart';


class RootPage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  String _userId = "";

  @override
  void initState() {
    super.initState();

  }

  

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
 
          return new Home();
  }
}