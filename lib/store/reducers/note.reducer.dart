import 'package:notes/store/actions/notes.action.dart';
import 'package:notes/store/states/note.state.dart';

NoteState notesReducer(NoteState state, dynamic action) {
  switch (action['type']) {
    case CreateNoteAction:
      NoteState noteState =
        NoteState(notes: state.notes, currentNote: state.currentNote);
      noteState.notes.add(action['note']);
      return noteState;
    case DeleteNoteAction:
      NoteState noteState = NoteState(
        notes: state.notes.where((note) => note.id != action['id']).toList(),
        currentNote: state.currentNote);
      return noteState;
    case SetCurrentNoteAction:
      NoteState noteState =
        NoteState(notes: state.notes, currentNote: action['note']);
      return noteState;
    case SetNoteCollectionAction:
      NoteState noteState =
        NoteState(notes: action['notes'], currentNote: state.currentNote);
      return noteState;
    case EditNoteAction:
      NoteState noteState = NoteState(
        notes: state.notes.where((note) => note.id != action['note'].id).toList(),
        currentNote: state.currentNote);
        noteState.notes.add(action['note']);
      return noteState;
    default:
      return state;
  }
}
