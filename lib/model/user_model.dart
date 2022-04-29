class UserModel {
  String? uid;
  String? fullName;
  String? birthDate;
  String? gender;
  String? homeAddress;
  String? contactNumber;
  String? emailAddress;

  UserModel(
      {this.uid,
      this.fullName,
      this.birthDate,
      this.gender,
      this.homeAddress,
      this.contactNumber,
      this.emailAddress});

  // taking data from server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        fullName: map['fullName'],
        birthDate: map['birthDate'],
        gender: map['gender'],
        homeAddress: map['homeAddress'],
        contactNumber: map['contactNumber'],
        emailAddress: map['emailAddress']);
  }

  // sending data from server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'birthDate': birthDate,
      'gender': gender,
      'homeAddress': homeAddress,
      'contactNumber': contactNumber,
      'emailAddress': emailAddress,
      'dateCreated': DateTime.now()
    };
  }
}
