import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:nora/components/custom_appbar.dart';
import 'package:nora/config.dart';
import 'package:nora/theme.dart';
import "package:provider/provider.dart";
import "package:nora/mqtt.dart" as mqtt;

class MarvinPage extends StatefulWidget {
  @override
  _MarvinPageState createState() => _MarvinPageState();

  static MarvinPage builder(BuildContext context) => MarvinPage();
}


class ActionButton extends StatefulWidget {
  final bool active;
  final IconData iconData;
  final Color iconColor;
  final VoidCallback onPressed;
  ActionButton({this.active, this.iconData, this.iconColor, this.onPressed});
  @override
  _ActionButtonState createState() => _ActionButtonState(active: this.active);
}

class _ActionButtonState extends State<ActionButton> {
  bool active;
  _ActionButtonState({this.active});
  @override
  Widget build(BuildContext context) {
    
    return MaterialButton(
elevation: 8.0,
        onPressed: this.widget.onPressed ?? () {},
        color: this.widget.iconColor ?? kBlueColor,
        shape:
           RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Icon(this.widget.iconData,
            color: kWhiteColor, size: kAppBarIconSize));
  }
}

class _MarvinPageState extends State<MarvinPage> {
  // Queue eventQueue;

  Color materialButtonColor;
  String buttonText;

  _MarvinPageState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.Page(
        title: Text(
          "Marvin",
          style: TextStyle(color: kBlackDeep, fontSize: 25, fontFamily: kFontFamily),
        ),
        leading: BackButton(
          color: kBlack1,
        ),
      ),
      body: CustomScrollView(slivers: [
        SliverGrid.count(
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: 50.0,
          mainAxisSpacing: 50.0,
          children: <Widget>[
            Container(),
            ActionButton(
              active: false,
              iconData: Icons.keyboard_arrow_up,
            ),
            Container(),
            ActionButton(active: false, iconData: Icons.keyboard_arrow_left),
            ActionButton(
              active: false,
              iconData: Icons.stop,
              iconColor: kRedColor,
            ),
            ActionButton(
              active: false,
              iconData: Icons.keyboard_arrow_right,
            ),
            Container(),
            ActionButton(
              active: false,
              iconData: Icons.keyboard_arrow_down,
            ),
            Container()
          ],
        ),
        SliverList(
          delegate: SliverChildListDelegate([]),
        ),
      ]),
    );
  }
}
