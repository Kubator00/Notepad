import 'package:flutter/material.dart';
import 'package:notepad/models/note.dart';
import 'package:notepad/providers/notesProvider.dart';
import 'package:provider/provider.dart';

class NoteDetails extends StatefulWidget {
  const NoteDetails({super.key});

  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Note? note = ModalRoute.of(context)?.settings.arguments as Note?;

    _titleController.text = note?.title ?? '';
    _contentController.text = note?.content ?? '';

    return Scaffold(
      appBar: NoteAppBar(note: note),
      bottomNavigationBar: BottomBar(
        titleController: _titleController,
        contentController: _contentController,
      ),
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

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}

class NoteAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NoteAppBar({
    super.key,
    required this.note,
  });

  final Note? note;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(195, 195, 195, 1),
      iconTheme: const IconThemeData(
        color: Color.fromRGBO(40, 40, 40, 1),
      ),
      actions: note != null
          ? [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  Provider.of<NotesProvider>(context, listen: false)
                      .deleteNote(note!);
                  Navigator.pop(context);
                },
              ),
            ]
          : [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class BottomBar extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;

  const BottomBar({
    Key? key,
    required this.titleController,
    required this.contentController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
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
              onPressed: () {
                String title = titleController.text;
                String content = contentController.text;
                Note newNote = Note(
                  title: title,
                  content: content,
                );
                notesProvider.addNote(newNote);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
