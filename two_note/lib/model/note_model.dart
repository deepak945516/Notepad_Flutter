class Note {
  int id;
  String title;
  String details;
  String createdDate;
  String updatedDate;

  Note({this.id, this.title, this.details, this.createdDate, this.updatedDate});

  // factory Note.fromJson(Map<String, dynamic> json) {
  //   return Note(
  //     id: json['id'],
  //     title: json['title'],
  //     details: json['details'],
  //     date: json['date'],
  //   );
  // }

  Note.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    details = json['details'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['details'] = this.details;
    data['createdDate'] = this.createdDate;
    data['updatedDate'] = this.updatedDate;
    return data;
  }
}
