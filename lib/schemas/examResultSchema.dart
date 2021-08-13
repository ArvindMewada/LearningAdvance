class ExamResult {
  int? flag;
  int? authFlag;
  List<Ques>? ques;
  int? percentage;
  int? totCorrect;
  int? totIncorrect;
  int? notAttempt;
  int? markObtain;

  ExamResult(
      {required this.flag,
      required this.authFlag,
      required this.ques,
      required this.percentage,
      required this.totCorrect,
      required this.totIncorrect,
      required this.notAttempt,
      required this.markObtain});

  ExamResult.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    authFlag = json['authFlag'];
    if (json['ques'] != null) {
      ques = new List<Ques>.empty(growable: true);
      json['ques'].forEach((v) {
        ques!.add(new Ques.fromJson(v));
      });
    }
    percentage = json['percentage'];
    totCorrect = json['totCorrect'];
    totIncorrect = json['totIncorrect'];
    notAttempt = json['notAttempt'];
    markObtain = json['mark_obtain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    data['authFlag'] = this.authFlag;
    if (this.ques != null) {
      data['ques'] = this.ques!.map((v) => v.toJson()).toList();
    }
    data['percentage'] = this.percentage;
    data['totCorrect'] = this.totCorrect;
    data['totIncorrect'] = this.totIncorrect;
    data['notAttempt'] = this.notAttempt;
    data['mark_obtain'] = this.markObtain;
    return data;
  }
}

class Ques {
  String? quesId;
  String? quesDesc;
  String? opt1;
  String? opt2;
  String? opt3;
  String? opt4;
  String? opt5;
  String? correctOpt;
  String? quesExpl;
  dynamic userResponse;
  String? quesStatus;

  Ques(
      {required this.quesId,
      required this.quesDesc,
      required this.opt1,
      required this.opt2,
      required this.opt3,
      required this.opt4,
      this.opt5,
      required this.correctOpt,
      required this.quesExpl,
      required this.userResponse,
      required this.quesStatus});

  Ques.fromJson(Map<String, dynamic> json) {
    quesId = json['ques_id'];
    quesDesc = json['ques_desc'];
    opt1 = json['opt_1'];
    opt2 = json['opt_2'];
    opt3 = json['opt_3'];
    opt4 = json['opt_4'];
    opt5 = json['opt_5'];
    correctOpt = json['correct_opt'];
    quesExpl = json['ques_expl'];
    userResponse = json['user_response'];
    quesStatus = json['ques_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ques_id'] = this.quesId;
    data['ques_desc'] = this.quesDesc;
    data['opt_1'] = this.opt1;
    data['opt_2'] = this.opt2;
    data['opt_3'] = this.opt3;
    data['opt_4'] = this.opt4;
    data['opt_5'] = this.opt5;
    data['correct_opt'] = this.correctOpt;
    data['ques_expl'] = this.quesExpl;
    data['user_response'] = this.userResponse;
    data['ques_status'] = this.quesStatus;
    return data;
  }
}
