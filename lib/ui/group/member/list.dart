import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roger_that/models/group.dart';
import 'package:roger_that/models/user.dart';
import 'package:roger_that/providers/group.dart';
import 'package:roger_that/ui/components.dart';
import 'dialog.dart';
import 'list_item.dart';

class GroupMemberList extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    GroupModel group = Provider.of<GroupProvider>(context).selectedGroup;

    return Scaffold(
      key: _scaffoldkey,
      floatingActionButton: group.isAdmin
          ? FloatingActionButton(
              tooltip: 'Add New Member',
              child: Icon(Icons.person),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => MemberDialog(UserModel(), group: group),
              ).then((value) {
                if (value == true) {
                  showSnackBar(msg: 'Member Added Successfully !', scaffoldKey: _scaffoldkey);
                }
              }),
            )
          : null,
      body: ListView.builder(
        itemCount: group.members.length,
        itemBuilder: (context, index) {
          return GroupMemberListTile(
            group.members[index].email,
            scaffoldkey: _scaffoldkey,
            group: group,
          );
        },
      ),
    );
  }
}
