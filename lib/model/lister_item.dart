class ListerItem{
  int id;
  int listId;
  String name;
  String description;
  int rating;
  bool experienced;
  DateTime createdOn;
  DateTime modifiedOn;

  ListerItem(this.id, this.listId, this.name, this.description, this.rating, this.experienced, this.createdOn,
      this.modifiedOn);
}