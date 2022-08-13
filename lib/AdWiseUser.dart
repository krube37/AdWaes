class AdWiseUser {
  final String userId, userName, phoneNumber;
  final String? emailId, companyName, gstNumber, businessType;
  final int? age;


  AdWiseUser(
    this.userId,
    this.userName,
    this.phoneNumber, {
    this.emailId,
    this.companyName,
    this.gstNumber,
    this.age,
    this.businessType,
  });

  factory AdWiseUser.fromFireBase(Map<String, dynamic> user) =>
      AdWiseUser(user['userId'], user['userName'], user['phoneNumber'],
          emailId: user['emailId'],
          companyName: user['companyName'],
          gstNumber: user['gstNumber'],
          age: user['age'],
          businessType: user['businessType']);

  Map<String, dynamic> get map => {
        'userId': userId,
        'userName': userName,
        'phoneNumber': phoneNumber,
        'emailId': emailId,
        'companyName': companyName,
        'gstNumber': gstNumber,
        'age': age,
        'businessType': businessType,
      };
}
