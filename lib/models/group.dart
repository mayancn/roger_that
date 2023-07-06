import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:roger_that/blocs/auth/auth_bloc.dart';
import 'package:roger_that/models/action.dart';
import 'package:roger_that/models/user.dart';
import 'package:roger_that/static/firestore_collections.dart';

class GroupModel {
  String name = 'test';
  String uid;
  String docId;
  List<UserModel> members;
  List<dynamic> admins;
  List<GroupActionModel> actions;
  bool isAdmin = false;

  GroupModel();

  @override
  String toString() => 'Name: $name';

  GroupModel.fromSnapshot({DocumentSnapshot document}) {
    this.name = document.data['name'];
    this.uid = document.data['userId'];
    this.members = document.data['members'].map<UserModel>((e) => UserModel(email: e)).toList();
    this.actions = document.data['actions'].map<GroupActionModel>((e) => GroupActionModel(document: e)).toList();
    this.admins = document.data['admins'];
    this.docId = document.documentID;
    this.isAdmin = this.admins.contains(user.email);
  }

  Future<bool> updateGroup() async {
    await Firestore.instance.collection(collectionGroup).document(docId).updateData({
      'name': name
    });
    return true;
  }

  Future<bool> createGroup() async {
    await Firestore.instance.collection(collectionGroup).document().setData({
      'name': name,
      'members': [
        user.email
      ],
      'actions': [],
      'admins': [
        user.email
      ]
    });
    return true;
  }

  Future<bool> deleteGroup() async {
    await Firestore.instance.collection(collectionGroup).document(docId).delete();
    return true;
  }

  Future<bool> addUser(String email) async {
    await Firestore.instance.collection(collectionGroup).document(docId).updateData({
      'members': FieldValue.arrayUnion([
        email
      ])
    });
    return true;
  }

  Future<bool> removeUser(String email) async {
    await Firestore.instance.collection(collectionGroup).document(docId).updateData({
      'members': FieldValue.arrayRemove([
        email
      ])
    });
    return true;
  }

  Future<bool> addAction(GroupActionModel action) async {
    final bool uploaded = await action.uploadFile(groupId: docId, name: action.name, file: action.file);
    if (uploaded) {
      await Firestore.instance.collection(collectionGroup).document(docId).updateData({
        'actions': FieldValue.arrayUnion([
          {
            'name': action.name,
            'file': action.filePath
          }
        ])
      });
      return true;
    }
    return false;
  }

  Future<bool> removeAction(GroupActionModel action) async {
    final bool filedeleted = await action.deleteFile(name: action.name, groupId: docId);
    if (filedeleted) {
      await Firestore.instance.collection(collectionGroup).document(docId).updateData({
        'actions': FieldValue.arrayRemove([
          {
            'name': action.name,
            'file': action.filePath
          }
        ])
      });
      return true;
    }
    return false;
  }

  Future<bool> downloadActions() async {
    actions.forEach((element) async {
      if (!element.isDownloaded) {
        await element.downloadAction(docId);
      }
    });
    return true;
  }
}
