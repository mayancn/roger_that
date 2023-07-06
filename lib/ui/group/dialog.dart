import 'package:flutter/material.dart';
import 'package:roger_that/models/group.dart';

class GroupDialog extends StatefulWidget {
  GroupModel group;
  final bool isEdit;
  GroupDialog({@required this.group, this.isEdit = false});

  @override
  _GroupDialogState createState() => _GroupDialogState();
}

class _GroupDialogState extends State<GroupDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  bool _inProgress = false;

  @override
  void initState() {
    _nameController.text = widget.group.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: EdgeInsets.all(15),
      title: widget.isEdit ? Text('Update Group: ${widget.group.name}') : Text('Create Group'),
      actions: [
        RaisedButton(
          color: Theme.of(context).primaryColor,
          onPressed: _inProgress == true
              ? null
              : () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    setState(() => _inProgress = true);

                    if (widget.isEdit) {
                      widget.group.updateGroup().then((value) => Navigator.of(context).pop(true));
                    } else {
                      widget.group.createGroup().then((value) => Navigator.of(context).pop(true));
                    }
                  }
                },
          child: Text('OK'),
        ),
        FlatButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
      content: Form(
        key: _formKey,
        child: ListTile(
          leading: Icon(Icons.person),
          title: TextFormField(
            controller: _nameController,
            enabled: !_inProgress,
            autofocus: true,
            onSaved: (value) => widget.group.name = value.trim(),
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value.isEmpty) return 'Name cannot be blank !';
              return null;
            },
          ),
        ),
      ),
    );
  }
}
