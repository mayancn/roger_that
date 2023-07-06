import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roger_that/models/group.dart';
import 'package:roger_that/providers/group.dart';
import 'package:roger_that/ui/components.dart';
import 'actions/list.dart';
import 'dialog.dart';
import 'member/list.dart';

class GroupDetailPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    GroupModel group = Provider.of<GroupProvider>(context).selectedGroup;

    Map choices = {
      'update': {
        'label': 'Update',
        'action': () => showDialog(
              context: context,
              builder: (context) => GroupDialog(
                group: group,
                isEdit: true,
              ),
            ).then((value) {
              if (value) {
                showSnackBar(msg: 'Group Updated Successfully !', scaffoldKey: _scaffoldkey);
              }
            }),
      },
      'delete': {
        'label': 'Delete',
        'action': () => group.deleteGroup().then((value) => Navigator.of(context).pop())
      }
    };

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(group.name),
          actions: [
            PopupMenuButton(
              elevation: 3.2,
              initialValue: choices[1],
              tooltip: 'Settings',
              onSelected: (value) => choices[value]['action'](),
              itemBuilder: (context) => choices.keys
                  .map(
                    (e) => PopupMenuItem(
                      child: Text(choices[e]['label']),
                      value: e,
                    ),
                  )
                  .toList(),
            ),
          ],
          bottom: TabBar(tabs: [
            Tab(text: 'Actions', icon: Icon(Icons.record_voice_over)),
            Tab(text: 'Members', icon: Icon(Icons.people)),
          ]),
        ),
        body: TabBarView(children: [
          GroupActionsList(),
          GroupMemberList()
        ]),
      ),
    );
  }
}
