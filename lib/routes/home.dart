import 'dart:convert';
import 'dart:typed_data';
import "package:mqtt_client/mqtt_client.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:nora/components/custom_appbar.dart';
import 'package:nora/components/custom_scaffold.dart';
import 'package:nora/config.dart';
import 'package:nora/mqtt.dart' as mqtt;
import 'package:nora/theme.dart';

Uint8List kImage = Uint8List.fromList([]);

Uint8List Decode() {
  // im = cv.imread('/home/lamar/Pictures/D0heq0nX4AUgOBX.jpg'  )

  // In [39]: q = cv.imencode(".png",im)[1]

  // In [40]: print(",\n".join([str(x) for x in q.flatten().tolist()]))
  return kImage;
}

Image Imagify() {
  return Image.memory(Decode());
}

class HomeGrid extends StatefulWidget {
  static final int kElementCrossAxisSize = 50;
  final List<GridButton> buttons;

  HomeGrid({@required this.buttons});

  @override
  _HomeGridState createState() => _HomeGridState();
}

class _HomeGridState extends State<HomeGrid> {
  int temperature = 26;
  @override
  Widget build(BuildContext context) {
    int crossAxisCount =
        MediaQuery.of(context).orientation == Orientation.landscape ? 4 : 3;

    return CustomScrollView(slivers: <Widget>[
      SliverList(
        delegate: SliverChildListDelegate(<Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 100.0),
            child: Center(
                child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(1.0)),
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  gradient: LinearGradient(
                      colors: [kBlueColor, kBlueColor],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              child: Text(
                "${this.temperature}°C",
                style: TextStyle(
                    fontWeight: FontWeight.w100,
                    color: kWhiteColor,
                    fontSize: 50.0,
                    fontFamily: kFontFamily),
              ),
              padding: EdgeInsets.all(10.0),
            )),
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage("assets/pixels/bg.webp"),
                    fit: BoxFit.fitWidth)),
          ),
        ]),
      ),
      SliverPadding(
          padding: EdgeInsets.all(10.0),
          sliver: SliverGrid.count(
              childAspectRatio: 1,
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              children: this.widget.buttons)),
    ]);
  }
}

class GridButton extends StatefulWidget {
  final String title;
  final IconData iconData;
  final Color color;
  final int notificationsCount;
  final String routeName;

  GridButton(
      {@required this.title,
      @required this.iconData,
      @required this.color,
      @required this.notificationsCount,
      @required this.routeName});

  @override
  _GridButtonState createState() => _GridButtonState(this.notificationsCount);
}

// TODO: only the notification counter will change so make that stateful instead
class _GridButtonState extends State<GridButton> {
  int notificationsCount;
  ValueNotifier<int> notifier;
  _GridButtonState(this.notificationsCount);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: InkWell(
            onTap: () {
              // Scaffold.of(context).showSnackBar(snackbar)

              Navigator.of(context).pushNamed(this.widget.routeName);
              debugPrint("Tap: ${this.widget.title}");
            },
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: kBlack1, width: 0.3),
                    borderRadius: BorderRadius.all(Radius.circular(9.0))),
                padding: EdgeInsets.all(2.0),
                child: Flex(
                    direction: Axis.vertical,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: <Widget>[
                            Icon(this.widget.iconData,
                                size: 40.0, color: this.widget.color),
                            this.notificationsCount != 0
                                ? (DecoratedBox(
                                    decoration: BoxDecoration(
                                        color: kRedColor,
                                        shape: BoxShape.circle),
                                    child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text(
                                            "${this.notificationsCount}",
                                            style: TextStyle(
                                                fontSize: kBodyFontSize,
                                                color: kWhiteColor,
                                                fontFamily: kFontFamily)))))
                                : SizedBox()
                          ]),
                      SizedBox(height: 5.0),
                      Text(
                        this.widget.title,
                        style: TextStyle(
                            color: kBlackDeep, fontWeight: FontWeight.w700, fontFamily: kFontFamily),
                      )
                    ]))));
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

  HomePage();

  static HomePage builder(BuildContext context) {
    return HomePage();
  }
}

class ConnectivityButton extends StatefulWidget {
  @override
  _ConnectivityButtonState createState() => _ConnectivityButtonState();
}

class _ConnectivityButtonState extends State<ConnectivityButton> {
  void __connectedCallback() {
    debugPrint("Connected");
    this.setState(() {
      mqtt.MQTT.connectionState = mqtt.ConnectionState.Connected;
      mqtt.MQTT.client.subscribe(kLightsTopic, MqttQos.atLeastOnce);
      mqtt.MQTT.client.subscribe(kMarvinMotoryTopic, MqttQos.atLeastOnce);
      mqtt.MQTT.client.updates.listen(__messageCallback);
    });
  }

  void __disconnectedCallback() {
    debugPrint("Disconnected");
    this.setState(() {
      mqtt.MQTT.connectionState = mqtt.ConnectionState.Disconnected;
    });
  }

  void __subscribedCallback(String) {
    debugPrint("Subscribed");
    this.setState(() {
      mqtt.MQTT.connectionState =
          mqtt.ConnectionState.Subscribed | mqtt.ConnectionState.Connected;
    });
  }

  void __unsubscribedCallback(String) {
    debugPrint("Unsubscribed");
    this.setState(() {
      mqtt.MQTT.connectionState = mqtt.ConnectionState.Unsubscribed;
    });
  }

  void __messageCallback(List<MqttReceivedMessage<MqttMessage>> messages) {
    final MqttPublishMessage message = messages[0].payload;
    final String messageStr =
        MqttPublishPayload.bytesToStringAsString(message.payload.message);

    /// The above may seem a little convoluted for users only interested in the
    /// payload, some users however may be interested in the received publish message,
    /// lets not constrain ourselves yet until the package has been in the wild
    /// for a while.
    /// The payload is a byte buffer, this will be specific to the topic
    debugPrint(
        'EXAMPLE::Change notification:: topic is <${messages[0].topic}>, payload is <-- $messageStr -->');
  }

  _ConnectivityButtonState() {
    mqtt.MQTT.client.onConnected = __connectedCallback;
    mqtt.MQTT.client.onDisconnected = __disconnectedCallback;
    mqtt.MQTT.client.onSubscribed = __subscribedCallback;
    mqtt.MQTT.client.onUnsubscribed = __unsubscribedCallback;
  }

  static bool _mqConnected() {
    return mqtt.MQTT.client.connectionStatus.state ==
        MqttConnectionState.connected;
    ;
  }

  void _disconnectCallback() {
    mqtt.MQTT.client.disconnect();
    setState(() {});
  }

  void _connectCallback() {
    mqtt.MQTT.client.connect();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    bool connected = _mqConnected();
    return IconButton(
      icon: Icon(Icons.settings_remote,
          color: connected ? kGreenColor : kAppBarFontColor,
          size: kAppBarIconSize),
      onPressed: connected ? this._disconnectCallback : this._connectCallback,
    );
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: HomeGrid(
        buttons: <GridButton>[
          GridButton(
            title: "Add Devices",
            iconData: Icons.add,
            color: kRedColor,
            notificationsCount: 0,
            routeName: "/add_devices",
          ),
          GridButton(
            title: "Lights",
            iconData: Icons.lightbulb_outline,
            color: kGreenColor,
            notificationsCount: 0,
            routeName: "/lights",
          ),
          GridButton(
            title: "Notifications",
            iconData: Icons.notifications_none,
            color: kRedColor,
            notificationsCount: 0,
            routeName: "/notifications",
          ),
          GridButton(
            title: "Devices",
            iconData: Icons.devices,
            color: kBlueColor,
            notificationsCount: 0,
            routeName: "/devices",
          ),
          GridButton(
            title: "Schedule",
            iconData: Icons.schedule,
            color: Colors.orange,
            notificationsCount: 0,
            routeName: "/schedule",
          ),
          GridButton(
            title: "Alarms",
            iconData: Icons.alarm,
            color: Colors.lightBlue,
            notificationsCount: 0,
            routeName: "/alarms",
          ),
          GridButton(
            title: "Camera Feed",
            iconData: Icons.videocam,
            color: Colors.pink,
            notificationsCount: 0,
            routeName: "/camera_feeds",
          ),
          GridButton(
            title: "Settings",
            iconData: Icons.settings,
            color: Colors.grey,
            notificationsCount: 0,
            routeName: "/settings",
          ),
          GridButton(
            title: "Marvin",
            iconData: Icons.verified_user,
            color: Colors.green,
            notificationsCount: 0,
            routeName: "/marvin",
          ),
        ],
      ),
      backgroundColor: kBackgroundColor,
      appBar: CustomAppBar.Home(
          actions: <Widget>[ConnectivityButton()],
          leading: Padding(
              padding: kAppBarIconPadding,
              child: Icon(
                Icons.menu,
                size: kAppBarIconSize,
                color: kAppBarFontColor,
              )),
          title: Text(
            "nora",
            style: TextStyle(
                color: kAppBarFontColor,
                fontSize: kAppBarFontSize,
                fontWeight: kAppBarFontWeight,
                fontFamily: KAppBarFontFamily),
          ),
          isHome: true),
    );
  }
}
