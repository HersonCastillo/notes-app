import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:notes/interfaces/note.dart';
import 'package:notes/store/actions/notes.action.dart';
import 'package:notes/store/states/app.state.dart';
import 'package:notes/utils/dialogs.dart';
import 'package:notes/utils/navigation.dart';

class ViewNotePageState extends StatefulWidget {
  _ViewNotePage createState() => _ViewNotePage();
}

class _ViewNotePage extends State<ViewNotePageState> {
  INote note;
  final formKey = GlobalKey<FormState>();
  TextEditingController noteFieldController = TextEditingController();
  bool isNoteAlive = false;
  bool isEditing = false;

  StoreConnector saveNote() {
    return StoreConnector<AppState, VoidCallback>(
      converter: (store) {
        return () async {
          if (formKey.currentState.validate()) {
            String noteValue = noteFieldController.value.text;
            noteValue = noteValue.toString().trim();
            this.note.note = noteValue;
            int noteRecord = await this.note.update();
            if (noteRecord > 0) {
              noteFieldController.clear();
              store.dispatch({
                'type': EditNoteAction,
                'note': note
              });
              store.dispatch({
                'type': SetCurrentNoteAction,
                'note': note
              });
              setState(() {
                isEditing = false;
              });
            } else {
              AlertDialogApp.showSnackBar(
                'Something went wrong when updating',
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
          icon: Icon(Icons.check),
          onPressed: isNoteAlive ? callback : null,
          tooltip: 'Save note',
        );
      },
    );
  }

  StoreConnector currentNote() {
    this.refreshAppBar();
    return StoreConnector<AppState, INote>(
      converter: (store) => store.state.noteState.currentNote,
      builder: (context, currentNote) {
        if (currentNote != null) {
          this.note = currentNote;
          noteFieldController.value = TextEditingController(
            text: currentNote.note
          ).value;
          return Form(
            key: formKey,
            child: TextFormField(
              decoration: InputDecoration.collapsed(
                hintText: 'Write a note...',
              ),
              controller: noteFieldController,
              maxLines: null,
              readOnly: !isEditing,
              maxLength: isEditing ? 5000 : null,
              autovalidate: isEditing,
              validator: (value) {
                if (value.trim().replaceAll('\n', '').length == 0) {
                  return 'Note is required';
                }
                return null;
              }
            ),
          );
        }
        return Text('The note does not exist or was deleted');
      },
    );
  }

  StoreConnector deleteNote() {
    return StoreConnector<AppState, VoidCallback>(
      converter: (store) {
        return () {
          AlertDialogApp.showAlertDialog(
              'Delete note', 'Are you sure you want delete this note?', context,
              () async {
            int deleteCount = await this.note.delete();
            if (deleteCount > 0) {
              store.dispatch({'type': DeleteNoteAction, 'id': note.id});
              NavigationApp.backOneRoute(context);
            }
          });
        };
      },
      builder: (context, callback) {
        return !isEditing
        ? IconButton(
          icon: Icon(Icons.delete),
          tooltip: 'Delete note',
          onPressed: isNoteAlive && !isEditing ? callback : null,
        )
        : IconButton(
          icon: Icon(Icons.close),
          tooltip: 'Cancel edit',
          onPressed: () {
            setState(() {
              isEditing = false;
            });
          },
        );
      },
    );
  }

  Future<void> refreshAppBar() async {
    if (note == null) {
      Future.delayed(Duration.zero, () {
        setState(() {
          isNoteAlive = note != null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isNoteAlive
            ? Text(note.createdAt.toString().substring(0, 19))
            : Text('...'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Create note',
            onPressed: isNoteAlive && !isEditing ? () {
              NavigationApp.navigate('/create', context);
            } : null,
          ),
          !isEditing 
          ? IconButton(
              icon: Icon(Icons.edit),
              tooltip: 'Edit note',
              onPressed: isNoteAlive ? () {
                setState(() {
                  isEditing = true;
                });
              } : null,
            )
          : saveNote(),
          deleteNote()
        ],
      ),
      body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
            children: <Widget>[
              currentNote()
            ],
          ),
        )
      ),
    );
  }
}
