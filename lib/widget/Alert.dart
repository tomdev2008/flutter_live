import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AlertItem {
  final String title;
  final int id;
  final String identify;

  AlertItem({this.title, this.id, this.identify});
}

class Alert {

  static const int cancelColor = 0xFF007AFF;

  static const int dialogLineColor = 0x2F000000;

  static const TextStyle cancelTextStyle = TextStyle(
    fontFamily: '.SF UI Text',
    inherit: false,
    fontSize: 18,
    color: Color(cancelColor),
    textBaseline: TextBaseline.alphabetic,
  );

  static const TextStyle itemTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 16,
  );

  static const TextStyle dialogTitleTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 15,
  );

  static const TextStyle dialogMsgTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 17,
  );

  static showBottomSheet(
      BuildContext context,
      List<AlertItem> dataList,
      {
        void Function() cancelPressed,
        void Function(AlertItem alertItem) itemPressed,
      }) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          final double itemHeight = 55.0;
          final double bottomHeight = 34.0;
          final double itemVerSpace = 20;
          final double height = (dataList.length + 1) * itemHeight + bottomHeight + itemVerSpace + dataList.length - 1;

          List<Widget> list = [];
          for (AlertItem item in dataList) {
            list.add(Container(
                height: itemHeight,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  onPressed: () {
                    Navigator.pop(context);
                    if (itemPressed != null) itemPressed(item);
                  },
                  child: Text(item.title, style: itemTextStyle,),
                )));
            list.add(Container(color: Colors.black12, height: 1.0,));
          }
          list.removeLast();
          return Container(
            alignment: Alignment(0, 1),
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Card(
                  margin: EdgeInsets.all(0),
                  elevation: 5,
                  color:  Colors.white,
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.white,
                        width: 1.0
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: list,
                  ),
                ),
                Container(height: itemVerSpace,),
                Container(
                  height: itemHeight,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    color: Colors.white,
                    child: Text('取消', style: cancelTextStyle,),
                    onPressed: () {
                      if (cancelPressed != null) cancelPressed();
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(height: bottomHeight,),
              ],
            ),
          );
        });
  }

  static showCustomDialog({
    @required BuildContext context,
    String title,
    String message,
    VoidCallback cancelPressed,
    VoidCallback certainPressed,
    bool singleCertainButton = false,
  }) {
    double buttonHeight = 55;
    List <Widget> list = [];
    if (title != null) {
      list.add(Padding(
        padding: message != null ? EdgeInsets.only(top: 20) : EdgeInsets.symmetric(vertical: 20),
        child: Text(
          title,
          style: dialogTitleTextStyle,
        ),
      ));
    }
    if (message != null) {
      list.add(Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Text(
          message,
          style: dialogMsgTextStyle,
          textAlign: TextAlign.center,
        ),
      ));
    }
    list.add(_dialogButtonBar(
      context: context,
      buttonHeight: buttonHeight,
      cancelPressed: cancelPressed,
      certainPressed: certainPressed,
      singleCertainButton: singleCertainButton,
    ));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          alignment: Alignment(0, 0),
          child: Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 20),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              side: BorderSide(
                color: Colors.black26,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: list,
            ),
          ),
        );
      },

    );
  }

  static Widget _dialogButtonBar({
    @required BuildContext context,
    @required double buttonHeight,
    VoidCallback cancelPressed,
    VoidCallback certainPressed,
    bool singleCertainButton,
  }) {
    List<Widget> list = [];
    if (singleCertainButton) {
      list.add(Expanded(
        child: _dialogButton(Text('确定', style: cancelTextStyle,), () {
          Navigator.pop(context);
          if (certainPressed != null) certainPressed();
        }, buttonHeight),
      ));
    } else {
      list = [
        Expanded(
          child: _dialogButton(Text('取消', style: cancelTextStyle,), () {
            Navigator.pop(context);
            if (cancelPressed != null) cancelPressed();
          }, buttonHeight),
        ),
        Container(
          color: Color(dialogLineColor),
          width: 1,
          height: buttonHeight,
        ),
        Expanded(
          child: _dialogButton(Text('确定', style: cancelTextStyle,), () {
            Navigator.pop(context);
            if (certainPressed != null) certainPressed();
          }, buttonHeight),
        ),
      ];
    }
    return Container(
      height: buttonHeight,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                color: Color(dialogLineColor),
              )
          )
      ),
      child: Row(
        children: list,
      ),
    );
  }

  static Widget _dialogButton(Text text, VoidCallback onPressed, double height) {
    return Container(
      height: height,
      child: FlatButton(
        onPressed: onPressed,
        child: text,
      ),
    );
  }

  static showCustomBottomSheet(BuildContext context, {
    @required Widget modelWidget,
    isScrollControlled = true,
    Color color = const Color(0xffffffff),
    double borderRadius = 6,
    double proportion = 1.3,
    Function onCancel,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: isScrollControlled,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height / proportion,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: color,
            ),
            child: modelWidget
        );
      },
    ).then((value) {
      onCancel();
    });
  }
}