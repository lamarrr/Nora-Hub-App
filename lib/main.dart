import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nora/theme.dart';
import 'routes/routes.dart' as routes;

Map<String, WidgetBuilder> kRoutes = {
  "/": routes.HomePage.builder,
  "/devices": routes.DevicesPage.builder,
  "/notifications": routes.NotificationsPage.builder,
  "/add_device": routes.AddDevicePage.builder,
  "/camera_feeds": routes.CameraFeedsPage.builder,
  "/doors": routes.DoorsPage.builder,
  "/marvin": routes.MarvinPage.builder,
  "/lights": routes.LightsPage.builder
};


class NoraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(

      theme: ThemeData.light().copyWith(primaryColor: kAppBarBackgroundColor),
      debugShowCheckedModeBanner: false,
      title: "Nora",
      routes: kRoutes,
      initialRoute: "/",
    );
  }
}

// async due to prolongation warning & frame skipping
void setStatusBar() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white, statusBarBrightness: Brightness.light));
}

void main() {
  setStatusBar();
  runApp(NoraApp());
}
