import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:nora/components/custom_appbar.dart';
import 'package:nora/mqtt.dart';
import 'package:nora/theme.dart';
import 'package:nora/config.dart';

const int kLeftLight = 12;
const int kRightLight = 15;
const int kMiddleLight = 14;
const int kFan = 13;

class SwitchListTile extends StatefulWidget {
  final String text;
  final bool initialValue;
  final IntCallback onChanged;
  SwitchListTile({this.text, this.initialValue, this.onChanged});
  @override
  _SwitchListTileState createState() =>
      _SwitchListTileState(value: this.initialValue);
}

typedef void IntCallback(int param);

class _SwitchListTileState extends State<SwitchListTile> {
  bool value;
  _SwitchListTileState({@required this.value});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Column(children: [
      ListTile(
        title: Text(
          this.widget.text,
          style: TextStyle(fontFamily: kFontFamily),
        ),
        trailing: Switch(
          activeColor: kBlueColor,
          onChanged: (bool newValue) {
            setState(() {
              this.value = newValue;
              int state = this.value ? 1 : 0;
              this.widget.onChanged(state);
            });
          },
          value: this.value,
        ),
      ),
      Divider(
        height: 2,
      )
    ]);
  }
}

class LightsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.Page(
        title: Text(
          "Lights",
          style: TextStyle(
              color: kBlackDeep, fontSize: 25, fontFamily: kFontFamily),
        ),
        leading: BackButton(
          color: kBlack1,
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              SwitchListTile(
                initialValue: false,
                text: "Living Room Front Light",
                onChanged: (int state) {
                  final MqttClientPayloadBuilder builder =
                      MqttClientPayloadBuilder();
                  builder.addString('$kLeftLight:$state');
                  MQTT.client.publishMessage(
                      kLightsTopic, MqttQos.atLeastOnce, builder.payload);
                },
              ),
              SwitchListTile(
                initialValue: false,
                text: "Kitchen Front Light",
                onChanged: (int state) {
                  final MqttClientPayloadBuilder builder =
                      MqttClientPayloadBuilder();
                  builder.addString('$kRightLight:$state');
                  MQTT.client.publishMessage(
                      kLightsTopic, MqttQos.atLeastOnce, builder.payload);
                },
              ),
              SwitchListTile(
                initialValue: false,
                text: "Toilet Front Light",
                onChanged: (int state) {
                  final MqttClientPayloadBuilder builder =
                      MqttClientPayloadBuilder();
                  builder.addString('$kMiddleLight:$state');
                  MQTT.client.publishMessage(
                      kLightsTopic, MqttQos.atLeastOnce, builder.payload);
                },
              ),
              SwitchListTile(
                initialValue: false,
                text: "Living Room Fan",
                onChanged: (int state) {
                  final MqttClientPayloadBuilder builder =
                      MqttClientPayloadBuilder();
                  builder.addString('$kFan:$state');
                  MQTT.client.publishMessage(
                      kLightsTopic, MqttQos.atLeastOnce, builder.payload);
                },
              ),
            ]),
          )
        ],
      ),
    );
  }

  static LightsPage builder(BuildContext context) {
    return LightsPage();
  }
}
