import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live/common/config/LiveConfig.dart';
import 'package:live/live/model/LiveUtilEntity.dart';
import 'package:live/live/widget/LiveWidget.dart';
import 'package:live/widget/Alert.dart';
import 'package:live/widget/Loading.dart';
import 'package:live/widget/Toast.dart';
import 'package:screen/screen.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tencent_im_plugin/enums/add_group_opt_enum.dart';
import 'package:tencent_live_flutter/tencent_live_flutter.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'dart:convert';

import 'model/BarrageEntity.dart';

class LivePushPage extends StatefulWidget {
  @override
  _LivePushPageState createState() => _LivePushPageState();
}

class _LivePushPageState extends State<LivePushPage> {

  TXCloudPushViewController livePushController;

  GlobalKey<LiveBarrageWidgetState> messageKey = GlobalKey();

  bool isLogin = false;

  bool isLive = false;

  ///是否显示输入框
  bool inputShow = false;

  ///是否显示美颜model
  bool showBeauty = false;

  ///美颜参数
  int beautyLevel = 5,
      whitenessLevel = 6,
      ruddyLevel = 2,
      beautyStyle = 0;

  ///直播人数统计
  int liveNumber = 0;

  void initLogin() async {
    String userSig = await TencentImPlugin.getUserSig(LiveConfig.LIVE_APP_KEY, LiveConfig.LIVE_SECRET_KEY, LiveConfig.LIVE_USER_ID);
    TencentImPlugin.login(identifier: LiveConfig.LIVE_USER_ID, userSig: userSig).then((value) {
      if (value == 0) {
        Map<String, dynamic> map = Map();
        map['Tag_Profile_IM_Nick'] = LiveConfig.LIVE_USER_NAME;
        map['Tag_Profile_IM_Image'] = LiveConfig.LIVE_USER_AVATAR;
        TencentImPlugin.modifySelfProfile(params: map);
        setState(() {
          isLogin = true;
        });
      } else {
        ToastCustom.showToast(msg: value.toString());
      }
    });
  }

  /// 发送文本消息
  void sendRoomTextMsg(String message) {
    TencentImPlugin.sendMessage(
      sessionId: LiveConfig.GROUP_ID,
      sessionType: SessionType.Group,
      node: TextMessageNode(
          content: message
      ),
    ).then((res) {
      BarrageEntity barrageEntity = BarrageEntity();
      barrageEntity.userName = LiveConfig.LIVE_USER_NAME + '：';
      barrageEntity.message = message;
      messageKey.currentState.addMessage(barrageEntity);
    }).catchError((e) {
      ToastCustom.showToast(msg: '消息发送失败: $e');
    });
  }

  void changeInput(bool value) {
    setState(() {
      inputShow = value;
    });
  }

  onLivePushViewCreated(TXCloudPushViewController controller) async {
    livePushController = controller;
    livePushController.startCameraPreview();
    livePushController.txBeautyManager.setBeautyLevel(beautyLevel);
    livePushController.txBeautyManager.setWhitenessLevel(whitenessLevel);
    livePushController.txBeautyManager.setRuddyLevel(ruddyLevel);
    livePushController.txBeautyManager.setBeautyStyle(beautyStyle);
  }

  /// 切换摄像头
  void switchCamera() {
    livePushController.switchCamera();
  }

  /// 开始推流
  void startPush() {
    livePushController.startPush('rtmp://push.cmbenny.cn/live/chaoxielive?txSecret=207c6b32772d6a15709ef2b9c1051410&txTime=5F4E439B').then((value) {
      print('创建直播的状态==${value}');
      if (value == 0) {
        setState(() {
          isLive = true;
        });
        createdGroup();
      } else {
        ToastCustom.showToast(msg: '推流失败，错误码：$value');
      }
    });
  }

  ///停止推流
  void stopPush() {
    Alert.showCustomDialog(
        context: context,
        title: '直播提示',
        message: '您是否要退出当前直播',
        certainPressed: () {
          if (isLive) {
            livePushController.stopPush();
            TencentImPlugin.deleteGroup(groupId: LiveConfig.GROUP_ID);
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
          }
        }
    );
  }

  ///创建直播群
  void createdGroup() {
    TencentImPlugin.createGroup(
        type: 'Public',
        name: '直播吧',
        groupId: LiveConfig.GROUP_ID,
        addOption: AddGroupOptEnum.TIM_GROUP_ADD_ANY
    );
  }

  ///美颜的model
  void onBeautyShowBottomSheet() {
    setState(() {
      showBeauty = true;
    });
    Alert.showCustomBottomSheet(
        context,
        proportion: 3.5,
        color: Color.fromRGBO(255, 255, 255, 0.3),
        modelWidget: LiveBeautyModelWidget(
          beautyLevel: double.parse(beautyLevel.toString()),
          whitenessLevel: double.parse(whitenessLevel.toString()),
          ruddyLevel: double.parse(ruddyLevel.toString()),
          onBeauty: onSetLiveBeauty,
        ),
        onCancel: () {
          setState(() {
            showBeauty = false;
          });
        }
    );
  }

  ///修改美颜
  void onSetLiveBeauty(double getBeautyLevel, double getWhitenessLevel, double getRuddyLevel) {
    int setBeautyLevel = int.parse(getBeautyLevel.toStringAsFixed(0));
    int setWhitenessLevel = int.parse(getWhitenessLevel.toStringAsFixed(0));
    int setRuddyLevel = int.parse(getRuddyLevel.toStringAsFixed(0));
    if (beautyLevel != null) {
      livePushController.txBeautyManager.setBeautyLevel(setBeautyLevel);
    } else if (whitenessLevel != null) {
      livePushController.txBeautyManager.setWhitenessLevel(setWhitenessLevel);
    } else if (ruddyLevel != null) {
      livePushController.txBeautyManager.setRuddyLevel(setRuddyLevel);
    }
    setState(() {
      beautyLevel = setBeautyLevel;
      whitenessLevel = setWhitenessLevel;
      ruddyLevel = setRuddyLevel;
    });
  }

  listener(type, params) {
    if (type == ListenerTypeEnum.RefreshConversation) {
      for (var item in params) {
        if (item.message.note != '[群提示消息]') {
          if (item.group.groupId == LiveConfig.GROUP_ID) {
            if (item.message.userInfo.nickName != LiveConfig.LIVE_USER_NAME) {
              BarrageEntity barrageEntity = BarrageEntity();
              barrageEntity.userName = item.message.userInfo.nickName != ''
                  ? item.message.userInfo.nickName + '：'
                  : '';
              barrageEntity.message = item.message.note;
              messageKey.currentState.addMessage(barrageEntity);
            }
          }
        }
      }
    } else if(type == ListenerTypeEnum.GroupTips) {
      Map<String, dynamic> map = jsonDecode(params);
      String name = map['opUserInfo']['nickName'];
      BarrageEntity barrageEntity = BarrageEntity();
      barrageEntity.userName = name;
      barrageEntity.message = '加入了房间';
      messageKey.currentState.addMessage(barrageEntity);
    } else if (type == ListenerTypeEnum.ForceOffline) {
      ToastCustom.showToast(msg: '被踢下线，需要重新登录');
    } else if (type == ListenerTypeEnum.UserSigExpired) {
      ToastCustom.showToast(msg: '用户签名过期，需要重新登录');
    }
  }

  @override
  initState() {
    super.initState();
    TencentImPlugin.addListener(listener);
    initLogin();
    Screen.keepOn(true);
  }

  @override
  dispose() {
    Screen.keepOn(false);
    if (livePushController != null) {
      livePushController.stopCameraPreview();
    }
    TencentImPlugin.removeListener(listener);
    TencentImPlugin.logout();
    TencentImPlugin.deleteGroup(groupId: LiveConfig.GROUP_ID);
    super.dispose();
  }

  Future<bool> onPopScope() {
    stopPush();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onPopScope,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: isLogin
            ? Stack(
              children: <Widget>[
                //本地窗口
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: TXCloudPushView(
                    onTXCloudPushViewCreated: onLivePushViewCreated,
                  ),
                ),
                //左上角头像
                Positioned(
                    top: 10,
                    child: isLive ? Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                        child: headerWidget()
                    ) : SizedBox()
                ),
                //弹幕
                Positioned(
                  bottom: 100,
                  child: isLive
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          LiveBarrageWidget(
                            key: messageKey,
                          ),
                        ],
                      )
                      : Container(),
                ),
                Positioned(
                    bottom: 20,
                    child: SafeArea(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 20,),
                              isLive
                                  ? !showBeauty
                                      ? LiveAnchorUtilButtonWidget(
                                        inputWidget: LiveInputWidget(onShowInput: changeInput,),
                                        beautyWidget: beautyWidget(0, onTap: onBeautyShowBottomSheet ),
                                        closeWidget: closeWidget(onTap: stopPush),
                                      )
                                      : SizedBox()
                                  : !showBeauty
                                      ? Row(
                                        children: <Widget>[
                                          cameraWidget(30, onTap: switchCamera),
                                          enterRoomButtonWidget(onTap: startPush),
                                          beautyWidget(30, onTap: onBeautyShowBottomSheet )
                                        ],
                                      )
                                      : SizedBox()
                            ],
                          )
                      ),
                    )
                ),
                //自动聚焦的输入框
                inputShow
                    ? LiveChatInputWidget(
                      onSend: sendRoomTextMsg,
                      onHidden: changeInput,
                    )
                    : Container()
              ],
            )
            : LoadingWidget(),
      ),
    );
  }

  Widget headerWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          headerLeftWidget(),
          Container(
            child: Row(
              children: <Widget>[
                LiveTopAvatarWidget(),
                peopleNumberWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget headerLeftWidget() {
    return Container(
      height: 50,
      child: Row(
        children: <Widget>[
          avatarWidget('http://www.cmbenny.cn:9000/file/header1.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minio%2F20200827%2F%2Fs3%2Faws4_request&X-Amz-Date=20200827T133125Z&X-Amz-Expires=432000&X-Amz-SignedHeaders=host&X-Amz-Signature=eaaaa94973944608a11574dbefd4685c3d98b7d3df30f948f5494348ff340e1a'),
          SizedBox(width: 5),
          Text('潮牌', style: TextStyle(color: Colors.white, fontSize: 15),),
        ],
      ),
    );
  }

  Widget headerRightWidget() {
    return Container(
      height: 50,
      color: Colors.blue,
      child: Row(
        children: <Widget>[
          avatarWidget('http://www.cmbenny.cn:9000/file/header1.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minio%2F20200827%2F%2Fs3%2Faws4_request&X-Amz-Date=20200827T133125Z&X-Amz-Expires=432000&X-Amz-SignedHeaders=host&X-Amz-Signature=eaaaa94973944608a11574dbefd4685c3d98b7d3df30f948f5494348ff340e1a'),
          SizedBox(width: 5),
          Text('潮牌', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }

  Widget peopleNumberWidget() {
    return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
           color: Color(0xff808080),
            borderRadius: BorderRadius.circular(1000)
        ),
        alignment: Alignment.center,
        child: Text('${liveNumber}121', style: TextStyle(color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold),)
    );
  }

}
