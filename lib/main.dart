import 'package:flutter/material.dart';
import 'package:notepad/screens/noteDetails.dart';
import 'package:notepad/providers/notesProvider.dart';
import 'package:notepad/screens/noteGrid.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const Notepad());
}

class Notepad extends StatelessWidget {
  const Notepad({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotesProvider(),
      child: MaterialApp(
        title: 'Notatnik',
        debugShowCheckedModeBanner: false,
        home: const NoteGrid(),
        routes: {
          '/note': (context) => const NoteDetails(),
        },
        builder: (BuildContext context, Widget? child) {
          return Container(
            child: child,
          );
        },
      ),
    );
  }
}
