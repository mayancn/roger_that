import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:roger_that/models/action.dart';
import 'package:roger_that/models/group.dart';

class ActionDialog extends StatefulWidget {
  GroupActionModel action;
  GroupModel group;
  ActionDialog({@required this.group, @required this.action});

  @override
  _ActionDialogState createState() => _ActionDialogState();
}

class _ActionDialogState extends State<ActionDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  bool _inProgress = false;

  @override
  void initState() {
    _nameController.text = widget.action.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: EdgeInsets.all(15),
      title: Text('Create Action'),
      actions: [
        RaisedButton(
          color: Theme.of(context).primaryColor,
          onPressed: _inProgress == true || widget.action.file == null
              ? null
              : () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    setState(() => _inProgress = true);

                    widget.group.addAction(widget.action).then((value) => Navigator.of(context).pop(value));
                  }
                },
          child: Text('OK'),
        ),
        FlatButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formKey,
            child: ListTile(
              leading: Icon(Icons.person),
              title: TextFormField(
                controller: _nameController,
                enabled: !_inProgress,
                autofocus: true,
                onSaved: (value) => widget.action.name = value.trim(),
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value.isEmpty) return 'Name cannot be blank !';
                  return null;
                },
              ),
            ),
          ),
          // ListTile(
          //   leading: Icon(Icons.audiotrack),
          //   title: Text('Upload Sound Sample (.mp3)'),
          //   enabled: !_inProgress,
          //   onTap: () async {
          //     widget.action.file = await FilePicker.getFile(type: FileType.audio);
          //     if (widget.action.file != null) {
          //       setState(() {});
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
