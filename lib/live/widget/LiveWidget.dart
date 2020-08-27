import 'dart:ui';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:live/common/style/CustomImage.dart';
import 'package:live/live/model/BarrageEntity.dart';
import 'package:live/widget/Toast.dart';

liveRoomGoodsModel(BuildContext context, { @required Widget modelWidget}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
          height: MediaQuery.of(context).size.height / 1.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          child: modelWidget
      );
    },
  );
}

Widget enterRoomButtonWidget({
  String text = '开 始 直 播',
  int bgColor = 0xffE3E3E3,
  int textColor = 0xff808080,
  Function onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.translucent,
    child: Container(
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: 70),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100 * 0.1),
        color: Color(bgColor),
      ),
      alignment: Alignment.center,
      child: Text(
          text,
          style: TextStyle(
              color: Color(textColor),
              fontSize: 13
          )
      ),
    ),
  );
}

Widget cameraWidget(double left, {Function onTap}) {
  return GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.translucent,
    child: Container(
      child: Padding(
        padding: EdgeInsets.only(left: left),
        child: Icon(Icons.camera_alt, size: 30, color: Colors.white,),
      ),
    ),
  );
}

Widget closeWidget({Function onTap}) {
  return GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.translucent,
    child: Container(
      child: Icon(Icons.highlight_off, size: 30, color: Colors.white,),
    ),
  );
}

Widget beautyWidget(double right, {Function onTap}) {
  return GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.translucent,
    child: Container(
      child: Padding(
          padding: EdgeInsets.only(right: right),
          child: assetImage(CustomImage.LIVE_BEAUTY, width: 25, height: 25)
      ),
    ),
  );
}

Widget avatarWidget(String url) {
  return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000)
      ),
      child: ClipOval(
        child: Image.network(
            url,
            fit: BoxFit.cover
        ),
      )
  );
}

///直播头上的横排头像
class LiveTopAvatarWidget extends StatelessWidget {

  List<String> dataList = ['one', 'two', 'there', 'four'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: dataList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: itemBuilder
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    String item = dataList[index];
    switch(item) {
      case 'one':
        return
          headerWidget('http://www.cmbenny.cn:9000/file/header1.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minio%2F20200827%2F%2Fs3%2Faws4_request&X-Amz-Date=20200827T133125Z&X-Amz-Expires=432000&X-Amz-SignedHeaders=host&X-Amz-Signature=eaaaa94973944608a11574dbefd4685c3d98b7d3df30f948f5494348ff340e1a');
      case 'two':
        return headerWidget('http://www.cmbenny.cn:9000/file/header2.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minio%2F20200827%2F%2Fs3%2Faws4_request&X-Amz-Date=20200827T133143Z&X-Amz-Expires=432000&X-Amz-SignedHeaders=host&X-Amz-Signature=8e38bf33f4f51cfc182334f5b4b4666f28be4eff33a7a0a3b05650a7ceae0969');
      case 'there':
        return headerWidget('http://www.cmbenny.cn:9000/file/header3.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minio%2F20200827%2F%2Fs3%2Faws4_request&X-Amz-Date=20200827T133151Z&X-Amz-Expires=432000&X-Amz-SignedHeaders=host&X-Amz-Signature=bacf15cd9f0987dda46a26f1d5a0a5c2ad83f85cbf463e4163fb5d7a3a5aa13c');
      case 'four':
        return headerWidget('http://www.cmbenny.cn:9000/file/header4.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minio%2F20200827%2F%2Fs3%2Faws4_request&X-Amz-Date=20200827T133157Z&X-Amz-Expires=432000&X-Amz-SignedHeaders=host&X-Amz-Signature=02c56c98ec71744e8b0895dcd6f1c9d3498ccc023bc3ce605142f9a03f1d80c0');
      default:
        return null;
    }
  }

  Widget headerWidget(String url) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: avatarWidget(url),
    );
  }

}


///直播记时控件
class LiveTimerWidget extends StatefulWidget {

  LiveTimerWidget({
    key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LiveTimerWidgetState();
}

class LiveTimerWidgetState extends State<LiveTimerWidget> {

  static const duration = const Duration(seconds: 1);

  int secondsPassed = 0;

  bool isActive = false;

  bool flashing = false;

  Timer timer;

  @override
  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  void handleTick() {
    setState(() {
      isActive = true;
      flashing = !flashing;
      secondsPassed = secondsPassed + 1;
      if(timer == null) {
        timer = Timer.periodic(duration, (Timer timer){
          handleTick();
        });
      }
    });
  }

  //时间格式化，根据总秒数转换为对应的 hh:mm:ss 格式
  String constructTime(int seconds) {
    int hour = seconds ~/ 3600;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    return formatTime(hour) + ":" + formatTime(minute) + ":" + formatTime(second);
  }

  //数字格式化，将 0~9 的时间转换为 00~09
  String formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }

  @override
  Widget build(BuildContext context) {
    return isActive
        ? Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100 * 0.3),
            color: Color.fromRGBO(0, 0, 0, 0.3),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10 * 0.5),
                  color: flashing ? Colors.red : Colors.white,
                ),
              ),
              SizedBox(width: 8,),
              Text(constructTime(secondsPassed), style: TextStyle(color: Colors.white),)
            ],
          ),
        )
        : Container();
  }

}

///直播中的公用控件
class LiveAnchorUtilButtonWidget extends StatelessWidget {
  final Widget inputWidget;
  final Widget beautyWidget;
  final Widget closeWidget;

  LiveAnchorUtilButtonWidget({
    this.beautyWidget,
    this.inputWidget,
    this.closeWidget
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          Expanded(child: inputWidget),
          SizedBox(width: 20,),
          beautyWidget,
          SizedBox(width: 20,),
          closeWidget
        ],
      ),
    );
  }

}

///直播中聊天文字控件
class LiveBarrageWidget extends StatefulWidget {

  final Widget crosswiseBarrage;

  LiveBarrageWidget({
    key,
    this.crosswiseBarrage,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LiveBarrageWidgetState();
}

class LiveBarrageWidgetState extends State<LiveBarrageWidget> {

  ScrollController msgController = ScrollController();

  List<BarrageEntity> dataList = [];

  void addMessage(BarrageEntity barrageEntity) {
    setState(() {
      dataList.add(barrageEntity);
    });
    scrollMsgBottom();
  }

  void scrollMsgBottom() {
    if (dataList.length > 0)
      Timer(Duration(milliseconds: 500),
              () => msgController.jumpTo(msgController.position.maxScrollExtent)
      );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          child: widget.crosswiseBarrage
        ),
        Container(
          height: 200,
          width: 260,
          margin: EdgeInsets.only(left: 15),
          child: ListView.builder(
            controller: msgController,
            itemCount: dataList.length,
            itemBuilder: itemBuilder,
            physics: BouncingScrollPhysics(),
          )
        )
      ],
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    BarrageEntity barrageEntity = dataList[index];
    return Wrap(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 2),
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color.fromRGBO(0, 0, 0, 0.5),
          ),
          child: Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              Text.rich(TextSpan(
                  children: [
                    TextSpan(
                        text: "${barrageEntity.userName}",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffEABD46)
                        )
                    ),
                    TextSpan(
                      text: barrageEntity.message,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white
                      ),
                    ),
                  ]
              ),),
            ],
          )
        )
      ],
    );
  }

}

///直播页面上的输入框按钮
class LiveInputWidget extends StatelessWidget {
  final Function(bool isInput) onShowInput;

  LiveInputWidget({this.onShowInput});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onShowInput(true);
      },
      child: Container(
        width: 200,
        height: 35,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Color.fromRGBO(0, 0, 0, 0.5),
        ),
        child: Text('聊点什么吧', style: TextStyle(color: Colors.white),),
      ),
    );
  }
}

///直播中输入框控件
class LiveChatInputWidget extends StatefulWidget {
  final Function(String message) onSend;
  final Function(bool onHidden) onHidden;

  LiveChatInputWidget({
    this.onSend,
    this.onHidden
  });

  @override
  _LiveChatInputWidgetState createState() => _LiveChatInputWidgetState();
}

class _LiveChatInputWidgetState extends State<LiveChatInputWidget> {
  FocusNode focusNodeInput = FocusNode();

  TextEditingController controller = TextEditingController();

  bool controllerIsEmpty = true;

  void onSendEvent() {
    if (!controllerIsEmpty) {
      widget.onSend(controller.text);
      widget.onHidden(false);
    } else {
      ToastCustom.showToast(msg: '请输入内容');
    }

  }

  void controllerListener() {
    setState(() {
      controllerIsEmpty = controller.text.length == 0 ? true : false;
    });
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(controllerListener);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            widget.onHidden(false);
          },
          child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Color.fromRGBO(0, 0, 0, 0.1),
              ),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: TextField(
                              keyboardType: TextInputType.text,
                              autofocus: true,
                              focusNode: focusNodeInput,
                              decoration: InputDecoration(
                                hintText: '说点什么吧...',
                                contentPadding: EdgeInsets.all(10.0),
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                              ),
                              controller: controller,
                            )
                        ),
                        GestureDetector(
                            onTap: onSendEvent,
                            child: Container(
                              padding: EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                              color: Colors.transparent,
                              child: Icon(Icons.near_me, color: Colors.blue,),
                            )
                        )
                      ],
                    ),
                  )
              )
          ),
        )
    );
  }
}

///直播中的美颜
class LiveBeautyModelWidget extends StatefulWidget {

  final double beautyLevel;

  final double whitenessLevel;

  final double ruddyLevel;

  final Function(double beautyLevel, double whitenessLevel, double ruddyLevel) onBeauty;

  LiveBeautyModelWidget({
    this.beautyLevel,
    this.whitenessLevel,
    this.ruddyLevel,
    this.onBeauty
  });

  @override
  _LiveBeautyModelWidgetState createState() => _LiveBeautyModelWidgetState();
}

class _LiveBeautyModelWidgetState extends State<LiveBeautyModelWidget> {
  double beautyLevel;

  double whitenessLevel;

  double ruddyLevel;

  @override
  void initState() {
    super.initState();
    beautyLevel = widget.beautyLevel;
    whitenessLevel = widget.whitenessLevel;
    ruddyLevel = widget.ruddyLevel;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: beautyLevelWidget()
    );
  }

  Widget beautyLevelWidget() {
    return Container(
        height: 150,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                beautyLevelTitleWidget("美颜级别"),
                Expanded(
                  child: Slider(
                    value: beautyLevel,
                    max: 9,
                    min: 0,
                    activeColor: Colors.blue,
                    onChanged: (double val) {
                      setState(() {
                        beautyLevel = val;
                      });
                      widget.onBeauty(beautyLevel, whitenessLevel, ruddyLevel);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                beautyLevelTitleWidget("美白级别"),
                Expanded(
                  child: Slider(
                    value: whitenessLevel,
                    max: 9,
                    min: 0,
                    activeColor: Colors.blue,
                    onChanged: (double val) {
                      setState(() {
                        whitenessLevel = val;
                      });
                      widget.onBeauty(beautyLevel, whitenessLevel, ruddyLevel);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                beautyLevelTitleWidget("红润级别"),
                Expanded(
                  child: Slider(
                    value: ruddyLevel,
                    max: 9,
                    min: 0,
                    activeColor: Colors.blue,
                    onChanged: (double val) {
                      setState(() {
                        ruddyLevel = val;
                      });
                      widget.onBeauty(beautyLevel, whitenessLevel, ruddyLevel);
                    },
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  Widget beautyLevelTitleWidget(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: Text(title, style: TextStyle(color: Colors.black),),
    );
  }

}








