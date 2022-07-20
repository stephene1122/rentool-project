class UserModel {
  String? uid;
  String? fullName;
  String? birthDate;
  String? gender;
  String? homeAddress;
  String? contactNumber;
  String? emailAddress;
  String? isAdmin;
  String? isUserGranted;
  String? nToken;

  UserModel(
      {this.uid,
      this.fullName,
      this.birthDate,
      this.gender,
      this.homeAddress,
      this.contactNumber,
      this.emailAddress,
      this.isAdmin,
      this.isUserGranted,
      this.nToken});

  // taking data from server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        fullName: map['fullName'],
        birthDate: map['birthDate'],
        gender: map['gender'],
        homeAddress: map['homeAddress'],
        contactNumber: map['contactNumber'],
        emailAddress: map['emailAddress'],
        isAdmin: map['isAdmin'],
        isUserGranted: map['isUserGranted'],
        nToken: map['nToken']);
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
      'isUserGranted': '0',
      'isAdmin': '0',
      'nToken': nToken,
      'dateCreated': DateTime.now(),
    };
  }
}
