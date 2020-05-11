import 'package:notes/store/actions/notes.action.dart';
import 'package:notes/store/reducers/note.reducer.dart';
import 'package:notes/store/states/app.state.dart';
import 'package:notes/store/states/note.state.dart';

AppState appReducers(AppState state, dynamic action) {
  switch (action['type']) {
    case CreateNoteAction:
    case DeleteNoteAction:
    case SetCurrentNoteAction:
    case SetNoteCollectionAction:
    case EditNoteAction:
      NoteState noteState = notesReducer(state.noteState, action);
      AppState appState = AppState(noteState: noteState);
      return appState;
    default:
      return state;
  }
}
