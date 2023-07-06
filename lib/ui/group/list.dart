import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roger_that/models/group.dart';
import 'package:roger_that/providers/group.dart';
import 'package:roger_that/ui/group/detail.dart';

class GroupList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<GroupModel> groups = Provider.of<GroupProvider>(context).groups;

    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.person),
          title: Text(groups[index].name),
          onTap: () {
            Provider.of<GroupProvider>(context, listen: false).selectGroup(index);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupDetailPage(),
              ),
            );
          },
          trailing: IconButton(
            tooltip: 'Activate Group',
            icon: Icon(Icons.play_for_work),
            onPressed: () => Provider.of<GroupProvider>(context, listen: false).activateGroup(groups[index]),
          ),
        );
      },
    );
  }
}
