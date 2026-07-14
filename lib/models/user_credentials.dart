class UserCrendentials {
  late String firstName;
  late String? middleName;
  late String? lastName;
  late String phoneNumber;
  late String? emailId;
  late String stateOrUT;

  UserCrendentials({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.phoneNumber,
    required this.emailId,
    required this.stateOrUT,
  });

  UserCrendentials.fromJSON(Map<String, dynamic> json) {
    firstName = json['firstName'] ?? "";
    middleName = json['middleName'] ?? "";
    lastName = json['lastName'] ?? "";
    phoneNumber = json['phoneNumber'] ?? "";
    emailId = json['emailId'] ?? "";
    stateOrUT = json['stateOrUT'] ?? "";
  }

  Map<String, dynamic> toJSON() {
    final data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['phoneNumber'] = phoneNumber;
    data['emailId'] = emailId;
    data['stateOrUT'] = stateOrUT;
    return data;
  }
}
