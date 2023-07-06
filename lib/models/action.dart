import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class GroupActionModel {
  String name = 'action 1';
  String filePath;
  File file;
  bool isDownloaded = false;

  @override
  String toString() => 'Name: $name, File: $filePath';

  GroupActionModel({Map<String, dynamic> document}) {
    if (document != null) {
      this.name = document['name'];
      this.filePath = document['file'];
    }
  }

  Future<bool> uploadFile({@required String name, @required File file, @required String groupId}) async {
    StorageUploadTask upload = FirebaseStorage.instance.ref().child(groupId).child(name).putFile(file);
    StorageTaskSnapshot downloadUrl = await upload.onComplete;
    String url = await downloadUrl.ref.getDownloadURL();
    this.filePath = url;
    return true;
  }

  Future<bool> deleteFile({@required String name, @required String groupId}) async {
    await FirebaseStorage.instance.ref().child(groupId).child(name).delete();
    return true;
  }

  Future<void> checkDownloadStatus(String groupId) async {
    String path = await getDownloadPath(groupId);
    Directory directory = Directory(path);
    List<FileSystemEntity> files = directory.listSync().where((element) => element.path.contains(this.name)).toList();
    if (files.length > 0) {
      this.filePath = files[0].path;
      this.isDownloaded = true;
    }
  }

  Future<String> getDownloadPath(String groupId) async {
    await Permission.storage.request();
    Directory _directory = await getExternalStorageDirectory();
    String _localPath = _directory.path + Platform.pathSeparator + groupId;
    _directory = await Directory(_localPath).create();
    return _directory.path;
  }

  static Future<void> downloadCallback(String id, DownloadTaskStatus status, int progress) async {
    print('$id $status, $progress');
  }

  // FlutterDownloader.registerCallback(downloadCallback);

  Future<void> downloadAction(String groupId) async {
    await FlutterDownloader.enqueue(
      fileName: this.name,
      url: this.filePath,
      savedDir: await getDownloadPath(groupId),
      requiresStorageNotLow: true,
      showNotification: true,
      openFileFromNotification: true,
    );
  }
}
