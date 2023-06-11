class Note {
  String? title;
  String? content;

  Note({
    this.title,
    this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'],
      content: map['content'],
    );
  }
}
