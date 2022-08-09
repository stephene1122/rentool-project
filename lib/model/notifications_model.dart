class NotificationModel {
  String? title;
  String? body;
  String? from;
  String? to;
  int? typeId;
  DateTime? dateCreated;

  NotificationModel({
    this.title,
    this.body,
    this.from,
    this.to,
    this.typeId,
    this.dateCreated,
  });

  //taking data from server
  factory NotificationModel.fromMap(map) {
    return NotificationModel(
      title: map['title'],
      body: map['body'],
      from: map['from'],
      to: map['to'],
      typeId: map['typeId'],
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
      'typeId': typeId,
      'dateCreated': DateTime.now(),
    };
  }
}
