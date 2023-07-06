import 'package:flutter/material.dart';
import 'package:roger_that/models/group.dart';
import 'package:roger_that/models/user.dart';
import 'package:roger_that/ui/components.dart';

class GroupMemberListTile extends StatefulWidget {
  final String email;
  final GroupModel group;
  final GlobalKey<ScaffoldState> scaffoldkey;
  GroupMemberListTile(this.email, {@required this.scaffoldkey, @required this.group});

  @override
  _GroupMemberListTileState createState() => _GroupMemberListTileState();
}

class _GroupMemberListTileState extends State<GroupMemberListTile> {
  UserModel _user;

  @override
  void initState() {
    _user = UserModel(email: widget.email);
    _user.getPhoto().then((value) => setState(() {}));
    super.initState();
  }

  Widget _child() => ListTile(
        leading: CircleAvatar(backgroundImage: _user.photo != null ? NetworkImage(_user.photo) : null),
        title: Text(_user.email),
        subtitle: _user.photo == null ? Text('User not registered !') : null,
      );

  @override
  Widget build(BuildContext context) {
    return widget.group.isAdmin
        ? Dismissible(
            key: Key(_user.email),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 15),
              color: Colors.red,
              child: Icon(Icons.delete_forever, color: Colors.white),
            ),
            confirmDismiss: (direction) {
              return showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  title: Text('Confirm Delete'),
                  content: Text(_user.email),
                  actions: <Widget>[
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('OK'),
                    ),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) => widget.group.removeUser(_user.email).then((value) {
              if (value) {
                showSnackBar(msg: 'Member Removed Successfully !', scaffoldKey: widget.scaffoldkey);
              }
            }),
            child: _child(),
          )
        : _child();
  }
}
