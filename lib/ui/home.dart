import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roger_that/blocs/auth/auth_bloc.dart';
import 'package:roger_that/models/group.dart';
import 'package:roger_that/ui/components.dart';
import 'package:roger_that/ui/group/dialog.dart';
import 'package:roger_that/ui/group/list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = const MethodChannel('com.example.roger_that');
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  void _openBubble() {
    try {
      platform.invokeMethod('openFloatingOverlay').then((value) => null);
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home'),
        actions: [
          IconButton(icon: Icon(Icons.more_vert), onPressed: () => BlocProvider.of<AuthBloc>(context).add(GoogleLogout()))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create Group',
        child: Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => GroupDialog(
            group: GroupModel(),
          ),
        ).then((value) {
          if (value == true) {
            showSnackBar(msg: 'Group Created Successfully !', scaffoldKey: _scaffoldkey);
          }
        }),
      ),
      body: GroupList(),
    );
  }
}
