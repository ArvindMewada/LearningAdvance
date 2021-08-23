class StudentData {
  String? userImagePath;
  String? userId;
  String? userHash;
  String? userFirstName;
  String? userLastName;
  String? userEmail;
  String? userContactNo;
  String? userAddress;
  String? zipCode;
  String? userQual;
  String? stream;
  String? orgName;
  String? jobTitle;
  String? prevExamPercentage;
  String? userStateName;
  String? userCountryName;
  String? userCityName;
  String? role;
  bool? isAdmin;
  int? percentage;
  int? flag;

  StudentData(
      {required this.userImagePath,
      required this.userId,
      required this.userHash,
      required this.userFirstName,
      required this.userLastName,
      required this.userEmail,
      required this.userContactNo,
      required this.userAddress,
      required this.zipCode,
      required this.userQual,
      required this.stream,
      required this.orgName,
      required this.jobTitle,
      required this.prevExamPercentage,
      required this.userStateName,
      required this.userCountryName,
      required this.userCityName,
      required this.role,
      required this.isAdmin,
      required this.percentage,
      required this.flag});

  StudentData.fromJson(Map<String, dynamic> json) {
    userImagePath = json['user_image_path'];
    userId = json['user_id'].toString();
    userHash = json['user_hash'];
    userFirstName = json['user_first_name'];
    userLastName = json['user_last_name'];
    userEmail = json['user_email'];
    userContactNo = json['user_contact_no'];
    userAddress = json['user_address'];
    zipCode = json['zip_code'];
    userQual = json['user_qual'];
    stream = json['stream'];
    orgName = json['org_name'];
    jobTitle = json['job_title'];
    prevExamPercentage = json['prev_exam_percentage'];
    userStateName = json['user_state_name'];
    userCountryName = json['user_country_name'];
    userCityName = json['user_city_name'];
    role = json['role'];
    isAdmin = json['is_admin'];
    percentage = json['percentage'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_image_path'] = this.userImagePath;
    data['user_id'] = this.userId;
    data['user_hash'] = this.userHash;
    data['user_first_name'] = this.userFirstName;
    data['user_last_name'] = this.userLastName;
    data['user_email'] = this.userEmail;
    data['user_contact_no'] = this.userContactNo;
    data['user_address'] = this.userAddress;
    data['zip_code'] = this.zipCode;
    data['user_qual'] = this.userQual;
    data['stream'] = this.stream;
    data['org_name'] = this.orgName;
    data['job_title'] = this.jobTitle;
    data['prev_exam_percentage'] = this.prevExamPercentage;
    data['user_state_name'] = this.userStateName;
    data['user_country_name'] = this.userCountryName;
    data['user_city_name'] = this.userCityName;
    data['role'] = this.role;
    data['is_admin'] = this.isAdmin;
    data['percentage'] = this.percentage;
    data['flag'] = this.flag;
    return data;
  }
}
