import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:notes/interfaces/note.dart';
import 'package:notes/providers/note.provider.dart';
import 'package:notes/store/actions/notes.action.dart';
import 'package:notes/store/states/app.state.dart';
import 'package:notes/utils/navigation.dart';
import 'package:notes/utils/string-utls.dart';
import 'package:redux/redux.dart';

class HomePageState extends StatefulWidget {
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePageState> {
  bool databaseQuestion = false;

  Future<void> retrieveNotesFromDatabase(Store<AppState> store) async {
    NoteProvider noteProvider = NoteProvider();
    List<INote> notes = await noteProvider.retrieveNotes();
    if (notes != null && notes.length > 0) {
      store.dispatch({
        'type': SetNoteCollectionAction,
        'notes': notes
      });
    }
  }

  StoreConnector noteListWidget() {
    return StoreConnector<AppState, List<INote>>(
      converter: (store) {
        List<INote> noteList = store.state.noteState.notes.reversed.toList();
        if (!this.databaseQuestion) {
          this.retrieveNotesFromDatabase(store);
          this.databaseQuestion = true;
        }
        return noteList;
      },
      builder: (context, notes) {
        return notes.length > 0 
        ? ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            INote currentNote = notes[index];
            return StoreConnector<AppState, VoidCallback>(
              converter: (store) {
                return () {
                  store.dispatch({
                    'type': SetCurrentNoteAction,
                    'note': currentNote
                  });
                  NavigationApp.navigate('/view', context);
                };
              },
              builder: (context, callback) {
                return ListTile(
                  subtitle: Text(StringUtils.addEllipsis(currentNote.note.replaceAll('\n', ' '), 30)),
                  title: Text('Posted at ${currentNote.createdAt.toString().substring(0, 19)}'),
                  onTap: callback,
                  leading: Icon(Icons.history),
                );      
              },
            );
          },
        ) 
        : Center(
          child: Text(
            'There are no notes to display.\n\nCreate your first note pressing + button',
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              NavigationApp.navigate('/create', context);
            },
            tooltip: 'Add a note',
          ),
        ],
      ),
      body: Container(
        child: noteListWidget(),
      ),
    );
  }
}
