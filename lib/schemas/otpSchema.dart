class OTP {
  int? flag;
  String? pin;
  String? msg;

  OTP({required this.flag, required this.pin, required this.msg});

  OTP.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    pin = json['pin'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    data['pin'] = this.pin;
    data['msg'] = this.msg;
    return data;
  }
}
