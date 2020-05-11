import 'package:notes/interfaces/note.dart';

class NoteState {
  List<INote> notes;
  INote currentNote;

  NoteState({this.notes, this.currentNote});
}
