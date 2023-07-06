import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:roger_that/blocs/auth/auth_bloc.dart';
import 'package:roger_that/models/group.dart';
import 'package:roger_that/static/firestore_collections.dart';

class GroupProvider extends ChangeNotifier {
  List<GroupModel> groups = List();
  GroupModel selectedGroup;

  getGroups() {
    Firestore.instance.collection(collectionGroup).where('members', arrayContains: user.email).snapshots().listen((event) {
      this.groups = event.documents.map<GroupModel>((e) => GroupModel.fromSnapshot(document: e)).toList();

      if (this.selectedGroup != null) {
        this.selectedGroup = this.groups.firstWhere((element) => element.docId == this.selectedGroup.docId);
      }

      notifyListeners();
    });
  }

  selectGroup(int index) {
    this.selectedGroup = this.groups[index];
    notifyListeners();
  }

  activateGroup(GroupModel group) async {
    if (await group.downloadActions()) {
      try {
        await appChannel.invokeMethod('openFloatingOverlay', {
          'groupId': group.docId
        });
      } on PlatformException catch (e) {
        // TODO:
        print(e.message);
      }
    }
  }
}
