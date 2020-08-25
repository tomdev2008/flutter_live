import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitCircle(
            color: Color(0xff696969),
            size: 60.0,
          ),
          SizedBox(height: 10,),
          Text('请稍等...')
        ],
      ),
    );
  }
}