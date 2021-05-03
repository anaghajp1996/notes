class Note {
  String id;
  String title;
  String content;
  DateTime createdOn;
  DateTime lastEditedOn;
  String imagePath;

  Note(
      {this.content,
      this.createdOn,
      this.lastEditedOn,
      this.title,
      this.id,
      this.imagePath});
}
