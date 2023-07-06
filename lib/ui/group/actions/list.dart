import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roger_that/models/action.dart';
import 'package:roger_that/models/group.dart';
import 'package:roger_that/providers/group.dart';
import 'package:roger_that/ui/components.dart';
import 'package:roger_that/ui/group/actions/dialog.dart';
import 'package:roger_that/ui/group/actions/list_item.dart';

class GroupActionsList extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    GroupModel group = Provider.of<GroupProvider>(context).selectedGroup;

    return Scaffold(
      key: _scaffoldkey,
      floatingActionButton: group.isAdmin
          ? FloatingActionButton(
              tooltip: 'Add New Action',
              child: Icon(Icons.record_voice_over),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => ActionDialog(
                  group: group,
                  action: GroupActionModel(),
                ),
              ).then((value) {
                if (value == true) {
                  showSnackBar(msg: 'Action Added Successfully !', scaffoldKey: _scaffoldkey);
                }
              }),
            )
          : null,
      body: ListView.builder(
        itemCount: group.actions.length,
        itemBuilder: (context, index) {
          return GroupActionListTileParent(
            group: group,
            scaffoldkey: _scaffoldkey,
            action: group.actions[index],
          );
        },
      ),
    );
  }
}
