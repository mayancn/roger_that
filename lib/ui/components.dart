import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: CircularProgressIndicator());
}

showSnackBar({
  @required String msg,
  @required GlobalKey<ScaffoldState> scaffoldKey,
  Color color,
}) {
  if (scaffoldKey.currentState != null) {
    scaffoldKey.currentState.showSnackBar(_commonSnackBar(content: Text(msg), color: color));
  }
}

Widget _commonSnackBar({@required Widget content, Color color}) => SnackBar(
      content: content,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
    );
