import 'package:flutter/material.dart';
import 'package:notepad/providers/notesProvider.dart';
import 'package:provider/provider.dart';
import 'package:notepad/models/note.dart';

List<Color> cardColors = [
  Colors.amber,
  Colors.pink,
  Colors.blue,
  Colors.deepOrange,
  Colors.purple,
  Colors.brown,
  Colors.red,
  Colors.teal,
  Colors.green,
];

class NoteGrid extends StatefulWidget {
  const NoteGrid({Key? key}) : super(key: key);

  @override
  State<NoteGrid> createState() => _NoteGridState();
}

class _NoteGridState extends State<NoteGrid> {
  @override
  void initState() {
    Provider.of<NotesProvider>(context, listen: false).getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context, listen: true);
    if (notesProvider.notes.isEmpty) {
      return const NoteEmptyGrid();
    }
    return NoteGridWithData(notesProvider: notesProvider);
  }
}

class NoteGridWithData extends StatelessWidget {
  const NoteGridWithData({
    super.key,
    required this.notesProvider,
  });

  final NotesProvider notesProvider;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const NoteAppBar(),
      bottomNavigationBar: const NoteBottomBar(),
      backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (screenWidth ~/ 250).clamp(2, 6),
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemCount: notesProvider.notes.length,
                itemBuilder: (context, index) {
                  int colorIndex = index % cardColors.length;
                  Note note = notesProvider.notes[index];
                  return NoteCard(
                    note: note,
                    color: cardColors[colorIndex],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoteEmptyGrid extends StatelessWidget {
  const NoteEmptyGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NoteAppBar(),
      bottomNavigationBar: const NoteBottomBar(),
      backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: const Text("Lista nie zawiera notatek"),
      ),
    );
  }
}

class NoteAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NoteAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(220, 220, 220, 1),
      title: const Text(
        "Twoje notatki",
        style: TextStyle(
          fontSize: 30,
          color: Color.fromRGBO(40, 40, 40, 1),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class NoteBottomBar extends StatelessWidget {
  const NoteBottomBar({
    super.key,
  });

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
              icon: const Icon(Icons.add, color: Color.fromRGBO(40, 40, 40, 1)),
              onPressed: () => {Navigator.pushNamed(context, '/note')},
            ),
          ),
        ],
      ),
    );
  }
}

class NoteCard extends StatefulWidget {
  final Note note;
  final Color color;

  const NoteCard({
    Key? key,
    required this.note,
    required this.color,
  }) : super(key: key);

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      cursor: _isHovered ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/note', arguments: widget.note);
        },
        child: Card(
          color: widget.color,
          elevation: _isHovered ? 50 : 10,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.note.title ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 239, 239, 239),
                  ),
                ),
                const SizedBox(height: 8),
                Text(widget.note.content ?? '',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 239, 239, 239),
                    ),
                    maxLines: screenWidth > 500
                        ? 8
                        : screenWidth > 350
                            ? 4
                            : 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
