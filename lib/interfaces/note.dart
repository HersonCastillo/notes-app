import 'package:notes/providers/note.provider.dart';

class INote extends NoteProvider {
  String id;
  String note;
  dynamic createdAt;

  INote(this.note, {
    this.createdAt,
    this.id
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'note': this.note,
      'createdAt': this.createdAt.toString()
    };
  }

  INote.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    note = map['note'];
    createdAt = map['createdAt'];
  }

  Future<bool> save() async {
    bool record = await super.saveNote(this);
    super.closeApplication();
    return record;
  }

  Future<int> update() async {
    int records = await super.updateNote(this);
    super.closeApplication();
    return records;
  }

  Future<int> delete() async {
    int deleteCount = await super.deleteNote(this.id);
    super.closeApplication();
    return deleteCount;
  }
}
