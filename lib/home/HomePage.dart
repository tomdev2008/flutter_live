import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:live/live/LivePushPage.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: _HomeWidget(),
      backgroundColor: Color(0xFFFAFAFA),
    );
  }
}

class _HomeWidget extends StatefulWidget {
  @override
  State createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<_HomeWidget> {

  void onTap() async {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([
      PermissionGroup.camera,
      PermissionGroup.microphone
    ]);
    if (permissions[PermissionGroup.camera] != PermissionStatus.granted) {
      Navigator.of(context).pop();
    } else if (permissions[PermissionGroup.microphone] != PermissionStatus.granted){
      Navigator.of(context).pop();
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return LivePushPage();
      }));
    }
  }

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        headerWidget(),
        Container(
          height: 1,
          color: Color(0X1A000000),
        ),
        Expanded(
            child: Align(
              alignment: Alignment.center,
              child: buttonWidget(),
            )
        )
      ],
    );
  }

  Widget headerWidget() {
    return Container(
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        gradient: LinearGradient(
            colors: [Color(0xFF15e4da), Color(0xfffb3dde)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
        ),
      ),
      padding: EdgeInsets.only(left: 30, top: 40, bottom: 10),
      child: Text(
          'Hi，欢迎进入潮鞋直播',
          style: TextStyle(
            color: Color(0xFFffffff),
            fontSize: 20,
          )
      ),
    );
  }

  Widget buttonWidget() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150 * 0.5),
          gradient: LinearGradient(
              colors: [Color(0xFF15e4da), Color(0xfffb3dde)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
          ),
          boxShadow: [
            BoxShadow(
                color: Color(0xFF4169E1).withAlpha(77),
                offset: Offset(0, 5),
                blurRadius: 8.0,
                spreadRadius: 5
            )
          ],
        ),
        alignment: Alignment.center,
        child: Text(
            '开启直播',
            style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 20)),
      ),
    );
  }

}



