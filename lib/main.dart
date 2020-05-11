import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:notes/pages/view-note.dart';
import 'package:notes/store/reducers/app.reducers.dart';
import 'package:notes/store/states/note.state.dart';
import 'package:redux/redux.dart';
import 'package:notes/pages/create-note.dart';
import 'package:notes/pages/home.dart';
import 'package:notes/store/states/app.state.dart';

void main() {
  Random rand = Random();
  Store<AppState> store = getStore();
  runApp(NotesApp(
    store: store,
    indexColor: rand.nextInt(5),
  ));
}

Store<AppState> getStore() {
  return Store<AppState>(appReducers, initialState: AppState(
    noteState: NoteState(
      notes: [], 
      currentNote: null
    ))
  );
}

class NotesApp extends StatelessWidget {
  final Store<AppState> store;
  final colors = [
    Colors.blue,
    Colors.grey,
    Colors.green,
    Colors.yellow,
    Colors.red,
    Colors.orange
  ];
  final int indexColor;

  NotesApp({Key key, this.store, this.indexColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Notes',
        theme: ThemeData(
          primarySwatch: this.colors[indexColor] != null 
            ? this.colors[indexColor] 
            : Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/home',
        routes: {
          '/home': (context) => HomePageState(),
          '/create': (context) => CreateNotePageState(),
          '/view': (context) => ViewNotePageState()
        },
      ),
    );
  }
}
