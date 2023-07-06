import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roger_that/models/group.dart';
import 'package:roger_that/models/user.dart';
import 'package:roger_that/providers/group.dart';
import 'package:roger_that/static/firestore_collections.dart';

class MemberDialog extends StatefulWidget {
  UserModel user;
  GroupModel group;
  MemberDialog(this.user, {@required this.group});

  @override
  _MemberDialogState createState() => _MemberDialogState();
}

class _MemberDialogState extends State<MemberDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  bool _inProgress = false;

  @override
  void initState() {
    _nameController.text = widget.user.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: EdgeInsets.all(15),
      title: Text('Create Member'),
      actions: [
        RaisedButton(
          color: Theme.of(context).primaryColor,
          onPressed: _inProgress == true
              ? null
              : () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    setState(() => _inProgress = true);
                    widget.group.addUser(widget.user.email).then((value) => Navigator.of(context).pop(value));
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
            onSaved: (value) => widget.user.email = value.trim(),
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value.isEmpty) return 'Email cannot be blank !';
              if (!value.isValidEmail()) return 'Email not valid !';
              return null;
            },
          ),
        ),
      ),
    );
  }
}
