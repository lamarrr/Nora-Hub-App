import 'package:flutter/material.dart';
import 'package:nora/theme.dart';

class CustomAppBar extends AppBar {
  final Widget title;
  final List<Widget> actions;
  final bool isHome;
  final Widget leading;
  final Color backgroundColor;
  final double elevation = kAppBarElevation;
  final bool centerTitle;
  final Brightness brightness;

  CustomAppBar.Home(
      {@required this.title,
      this.actions,
      this.leading,
      this.isHome,
      this.backgroundColor = kAppBarBackgroundColor,
      this.centerTitle = true,
      this.brightness = Brightness.light});

  CustomAppBar.Page(
      {@required this.title,
      this.actions,
      this.leading,
      this.isHome,
      this.backgroundColor = kAppBarBackgroundColor,
      this.centerTitle = false,
      this.brightness = Brightness.light});
/*  @override
  Widget build(BuildContext) {
    return AppBar(
      title: Text(this.title),
      centerTitle: true,
      actions: <Widget>[],
    );
  }*/
}
