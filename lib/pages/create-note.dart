import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:notes/interfaces/note.dart';
import 'package:notes/store/actions/notes.action.dart';
import 'package:notes/store/states/app.state.dart';
import 'package:notes/utils/dialogs.dart';
import 'package:uuid/uuid.dart';

class CreateNotePageState extends StatefulWidget {
  _CreateNotePage createState() => _CreateNotePage();
}

class _CreateNotePage extends State<CreateNotePageState> {
  final formKey = GlobalKey<FormState>();
  TextEditingController noteFieldController = TextEditingController();

  StoreConnector saveNote() {
    return StoreConnector<AppState, VoidCallback>(
      converter: (store) {
        return () async {
          if (formKey.currentState.validate()) {
            String noteValue = noteFieldController.value.text;
            noteValue = noteValue.toString().trim();
            INote note = INote(
              noteValue, 
              createdAt: DateTime.now(), 
              id: Uuid().v1()
            );
            bool noteRecord = await note.save();
            if (noteRecord) {
              noteFieldController.clear();
              store.dispatch({
                'type': CreateNoteAction,
                'note': note
              });
              AlertDialogApp.showSnackBar('Note saved', formKey.currentContext);
            } else {
              AlertDialogApp.showSnackBar(
                'Something went wrong when saving',
                formKey.currentContext
              );
            }
          } else {
            AlertDialogApp.showSnackBar('Note is required', formKey.currentContext);
          }
        };
      },
      builder: (context, callback) {
        return IconButton(
          icon: Icon(Icons.save),
          onPressed: callback,
          tooltip: 'Save note',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a note'),
        actions: <Widget>[
          saveNote()
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Column(
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: noteFieldController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Write a note...',
                      ),
                      maxLines: null,
                      maxLength: 5000,
                      autofocus: true,
                      validator: (value) {
                        if (value.trim().replaceAll('\n', '').length == 0) {
                          return 'Note is required';
                        }
                        return null;
                      },
                      autovalidate: true,
                      style: TextStyle(
                        letterSpacing: 1,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
