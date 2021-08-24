class StudentPermission {
  List<String>? studentPermissions;
  int? flag;

  StudentPermission({required this.studentPermissions, required this.flag});

  StudentPermission.fromJson(Map<String, dynamic> json) {
    studentPermissions!.clear();
    studentPermissions = json['student_permissions'].cast<String>();
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    studentPermissions!.clear();
    data['student_permissions'] = this.studentPermissions;
    data['flag'] = this.flag;
    return data;
  }
}
