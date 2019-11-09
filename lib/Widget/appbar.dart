import 'package:flutter/material.dart';
class AppiBar extends StatelessWidget  with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return buildAppBar();
  }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  
   AppBar buildAppBar() {
    return AppBar(
       iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
      brightness: Brightness.light,
      title: new Text(
        'YOLO',
        style: TextStyle(
            color: Colors.black,
            fontFamily: "Libre Baskerville",
            fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.menu),
          color: Colors.black,
          onPressed: () {},
        ),
      ],
    );
  }
}