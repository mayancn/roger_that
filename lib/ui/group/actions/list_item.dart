import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:roger_that/models/action.dart';
import 'package:roger_that/models/group.dart';
import 'package:roger_that/ui/components.dart';

class GroupActionListTileParent extends StatelessWidget {
  final GroupModel group;
  final GroupActionModel action;
  final GlobalKey<ScaffoldState> scaffoldkey;
  GroupActionListTileParent({@required this.group, @required this.scaffoldkey, @required this.action});

  @override
  Widget build(BuildContext context) {
    return group.isAdmin
        ? Dismissible(
            key: Key(action.hashCode.toString()),
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
                  content: Text(action.name),
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
            onDismissed: (direction) => group.removeAction(action).then((value) {
              if (value == true) {
                showSnackBar(msg: 'Action Removed Successfully !', scaffoldKey: scaffoldkey);
              }
            }),
            child: GroupActionListTile(action, group),
          )
        : GroupActionListTile(action, group);
  }
}

class GroupActionListTile extends StatefulWidget {
  final GroupActionModel action;
  final GroupModel group;
  GroupActionListTile(this.action, this.group);

  @override
  _GroupActionListTileState createState() => _GroupActionListTileState();
}

class _GroupActionListTileState extends State<GroupActionListTile> {
  @override
  void initState() {
    widget.action.checkDownloadStatus(widget.group.docId).then((value) {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.music_note),
      title: Text(widget.action.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Play Sample',
            icon: Icon(Icons.play_circle_outline),
            onPressed: () async {
              final assetsAudioPlayer = AssetsAudioPlayer();

              try {
                if (!widget.action.isDownloaded) {
                  await assetsAudioPlayer.open(Audio.network(widget.action.filePath));
                } else {
                  assetsAudioPlayer.open(Audio.file(widget.action.filePath));
                }
              } catch (t) {
                //mp3 unreachable
                // TODO:
                print(t);
              }
            },
          ),
          IconButton(
            tooltip: 'Download Sample',
            icon: Icon(Icons.file_download),
            color: !widget.action.isDownloaded ? Colors.blue : null,
            onPressed: !widget.action.isDownloaded ? () => widget.action.downloadAction(widget.group.docId) : null,
          ),
        ],
      ),
    );
  }
}
