import 'dart:async';

import 'package:flutter/material.dart';

class Countdown extends StatefulWidget {

  final DateTime dateTime;

  final Function(int roomId) backTimer;

  final TextStyle textStyle;

  final int roomId;  ///用于判断是哪个直播间的倒计时归零

  Countdown({
    this.dateTime,
    this.backTimer,
    this.textStyle,
    this.roomId
  });

  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {

  Timer timer;

  int seconds;

  String timeString = '00:00:00';

  bool isExpire = false;

  void startTimer() {
    const period = const Duration(seconds: 1);
    timer = Timer.periodic(period, (timer) {
      setState(() {
        seconds--;
      });
      if (seconds == 0) {
        cancelTimer();
        widget.backTimer(widget.roomId);
      }
    });
  }

  void cancelTimer() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
  }

  @override
  void initState() {
    super.initState();
    //获取当期时间
    var now = DateTime.now();
    //到期日期
    final expireTimer = widget.dateTime;
    //比较相差的秒
//    String difference = now.difference(expireTimer).inMinutes.toString();
    String difference = now.difference(expireTimer).inSeconds.toString();
    String type = difference.substring(0,1);
    //如果当前时间还没有到到期时间，则开始倒计时, 反之如果当前时间已经过了到期时间则不倒计时
    if (type == '-') {
      setState(() {
        isExpire = true;
      });
      int differenceTimerBetween = int.parse(difference.substring(1,difference.length));
//      var twoHours = now.add(Duration(seconds: differenceTimerBetween)).difference(now);
      seconds = now.add(Duration(seconds: differenceTimerBetween)).difference(now).inSeconds;
      seconds = seconds - 2;  //计算出的相差时间总是相差2秒，  所以在此处把总秒数减2
//      获取总秒数
//      seconds = twoHours.inSeconds;
      startTimer();
    } else {
      setState(() {
        isExpire = false;
        if (widget.roomId != null) {
          widget.backTimer(widget.roomId); ///如果时间到了则返回roomId
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    cancelTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(isExpire ? constructTime(seconds) : timeString, style: widget.textStyle,),
    );
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


}