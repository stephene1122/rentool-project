class NotificationModel {
  String? title;
  String? body;
  String? from;
  String? to;
  DateTime? dateCreated;

  NotificationModel({
    this.title,
    this.body,
    this.from,
    this.to,
    this.dateCreated,
  });

  //taking data from server
  factory NotificationModel.fromMap(map) {
    return NotificationModel(
      title: map['title'],
      body: map['body'],
      from: map['from'],
      to: map['to'],
      dateCreated: map['dateCreated'],
    );
  }

  // sending data from server
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'from': from,
      'to': to,
      'dateCreated': DateTime.now(),
    };
  }
}
