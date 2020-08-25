import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastCustom {

  static showToast({
    String msg,
    ToastGravity gravity = ToastGravity.CENTER,
    Color backgroundColor = const Color(0xffF5F5F5),
    Color textColor = const Color(0xff000000),
    double fontSize = 13
  }) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize
    );
  }

  static Future<bool> cancel() {
    return Fluttertoast.cancel();
  }

  static bool _show = false;

  static bool _willShow = false;

  static showLoading(BuildContext context, String text) {
    if (_willShow || _show) return;
    _willShow = true;
    Future.delayed(Duration(milliseconds: 300), () {
      if (!_willShow) return;
      _show = true;
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => _ToastDialog(
            text: text,
            loading: true,
          )
      );
    });
  }

  static void close(BuildContext context) {
    _willShow = false;
    if (_show == false) return;
    Navigator.of(context).pop();
    _show = false;
  }

  static bool get isLoading => _show;

  static void clearLoadingData() {
    _willShow = false;
    _show = false;
  }

}

class _ToastDialog extends Dialog {
  _ToastDialog({Key key, this.text, this.loading}) : super(key: key);
  final String text;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: WillPopScope(
          child: Center(
            child: new SizedBox(
              width: 120.0,
              height: 120.0,
              child: new Container(
                padding: const EdgeInsets.all(15),
                decoration: ShapeDecoration(
                  color: Color.fromARGB(191, 40, 40, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                ),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    loading == true
                        ? CupertinoActivityIndicator(
                      radius: 15,
                    )
                        : Icon(
                      Icons.check,
                      size: 56,
                      color: Colors.white,
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: new Text(
                        text,
                        style: new TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          onWillPop: () => Future.value(false)),
    );
  }
}