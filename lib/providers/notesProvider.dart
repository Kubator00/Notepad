import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:notepad/models/note.dart';

class NotesProvider extends ChangeNotifier {
  LocalStorage localStorage = LocalStorage('notes.json');
  List<Note> notes = [];

  Future<void> getNotes() async {
    await localStorage.ready;
    final notesData = localStorage.getItem('notes');
    if (notesData != null && notesData is List<dynamic>) {
      notes = notesData.map((data) => Note.fromMap(data)).toList();
      notifyListeners();
    }
  }

  Future<void> addNote(Note note) async {
    await localStorage.ready;
    notes.add(note);
    saveToLocalStorage();
    notifyListeners();
  }

  Future<void> updateNote(Note existNote, Note newNote) async {
    notes.remove(existNote);
    notes.add(newNote);
    saveToLocalStorage();
    notifyListeners();
  }

  Future<void> deleteNote(Note note) async {
    notes.remove(note);
    saveToLocalStorage();
    notifyListeners();
  }

  void saveToLocalStorage() async {
    await localStorage.ready;
    localStorage.setItem('notes', notes.map((n) => n.toMap()).toList());
  }
}
