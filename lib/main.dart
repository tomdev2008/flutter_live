import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:live/common/config/LiveConfig.dart';
import 'package:live/home/HomePage.dart';
import 'package:live/widget/Toast.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:tencent_live_flutter/tencent_live_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '潮鞋直播',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const String chanel = "android/back/desktop";

  static const String eventBackDesktop = "backDesktop";

  static DateTime lastTime;

  Future<bool> backDesktop() async {
    final platform = MethodChannel(chanel);
    try {
      if (lastTime == null || DateTime.now().difference(lastTime) > Duration(milliseconds: 2500)) {
        lastTime = DateTime.now();
        ToastCustom.showToast(msg: "再按一次退出", gravity: ToastGravity.BOTTOM);
      } else {
        ToastCustom.cancel();
        await platform.invokeMethod(eventBackDesktop);
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return Future.value(false);
  }

  initImSdk() {
    TencentImPlugin.init(
        appid: LiveConfig.LIVE_APP_KEY.toString(),
    );
  }

  initLiveSdk() {
     TencentLive.instance.init(
      licenseUrl: LiveConfig.LICENSE_URL,
      licenseKey: LiveConfig.LICENSE_KEY
    );
  }

  @override
  void initState() {
    super.initState();
    initImSdk();
    initLiveSdk();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: HomePage(),
        onWillPop: backDesktop
    );
  }

}
