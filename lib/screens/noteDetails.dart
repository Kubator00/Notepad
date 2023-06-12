import 'package:flutter/material.dart';
import 'package:notepad/models/note.dart';
import 'package:notepad/providers/notesProvider.dart';
import 'package:provider/provider.dart';

class NoteDetails extends StatefulWidget {
  const NoteDetails({Key? key}) : super(key: key);

  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void saveNoteHandler() {
    String title = _titleController.text;
    String content = _contentController.text;
    Note newNote = Note(
      title: title,
      content: content,
    );

    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    final existNote = ModalRoute.of(context)?.settings.arguments as Note?;

    if (existNote != null) {
      notesProvider.updateNote(existNote, newNote);
    } else {
      notesProvider.addNote(newNote);
    }

    Navigator.pop(context);
  }

  void deleteNoteHandler() {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    final existNote = ModalRoute.of(context)?.settings.arguments as Note?;

    if (existNote != null) {
      notesProvider.deleteNote(existNote);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Note? existNote = ModalRoute.of(context)?.settings.arguments as Note?;

    _titleController.text = existNote?.title ?? '';
    _contentController.text = existNote?.content ?? '';

    return Scaffold(
      appBar: NoteAppBar(
          deleteNoteHandler: existNote != null ? deleteNoteHandler : null),
      bottomNavigationBar: BottomBar(saveNoteHandler: saveNoteHandler),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            TextFormField(
              maxLength: 30,
              controller: _titleController,
              style: const TextStyle(fontSize: 25),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 20),
                counterText: '',
                hintText: "Nagłówek",
              ),
            ),
            Expanded(
              child: TextFormField(
                maxLines: null,
                controller: _contentController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoteAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NoteAppBar({
    Key? key,
    required this.deleteNoteHandler,
  }) : super(key: key);

  final VoidCallback? deleteNoteHandler;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(195, 195, 195, 1),
      iconTheme: const IconThemeData(
        color: Color.fromRGBO(40, 40, 40, 1),
      ),
      actions: deleteNoteHandler != null
          ? [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: deleteNoteHandler,
              ),
            ]
          : [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class BottomBar extends StatelessWidget {
  final VoidCallback saveNoteHandler;

  const BottomBar({Key? key, required this.saveNoteHandler}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 50,
      color: const Color.fromRGBO(215, 215, 215, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconTheme(
            data: const IconThemeData(size: 35),
            child: IconButton(
              icon: const Icon(Icons.save_outlined),
              onPressed: saveNoteHandler,
            ),
          )
        ],
      ),
    );
  }
}
