class ResultSchema {
  int? flag;
  Result? result;
  List<Section>? section;
  List<QuestionData>? questionData;

  ResultSchema(
      {required this.flag,
      required this.result,
      required this.section,
      required this.questionData});

  ResultSchema.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
    if (json['section'] != null) {
      section = new List.empty(growable: true);
      json['section'].forEach((v) {
        section!.add(new Section.fromJson(v));
      });
    }
    if (json['question_data'] != null) {
      questionData = new List.empty(growable: true);
      json['question_data'].forEach((v) {
        questionData!.add(new QuestionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    if (this.section != null) {
      data['section'] = this.section!.map((v) => v.toJson()).toList();
    }
    if (this.questionData != null) {
      data['question_data'] =
          this.questionData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? resId;
  String? resReqPer;
  String? scoredPercentage;
  String? resCorrectAns;
  String? resWrongAns;
  String? resPositiveMark;
  String? resNegativeMark;
  String? resMarksObtain;
  String? resCreated;

  Result(
      {required this.resId,
      required this.resReqPer,
      required this.scoredPercentage,
      required this.resCorrectAns,
      required this.resWrongAns,
      required this.resPositiveMark,
      required this.resNegativeMark,
      required this.resMarksObtain,
      required this.resCreated});

  Result.fromJson(Map<String, dynamic> json) {
    resId = json['res_id'];
    resReqPer = json['res_req_per'];
    scoredPercentage = json['scored_percentage'];
    resCorrectAns = json['res_correct_ans'];
    resWrongAns = json['res_wrong_ans'];
    resPositiveMark = json['res_positive_mark'];
    resNegativeMark = json['res_negative_mark'];
    resMarksObtain = json['res_marks_obtain'];
    resCreated = json['res_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res_id'] = this.resId;
    data['res_req_per'] = this.resReqPer;
    data['scored_percentage'] = this.scoredPercentage;
    data['res_correct_ans'] = this.resCorrectAns;
    data['res_wrong_ans'] = this.resWrongAns;
    data['res_positive_mark'] = this.resPositiveMark;
    data['res_negative_mark'] = this.resNegativeMark;
    data['res_marks_obtain'] = this.resMarksObtain;
    data['res_created'] = this.resCreated;
    return data;
  }
}

class Section {
  String? sectionId;
  String? sectionName;
  String? sectionTime;
  String? secTotalQuestion;
  String? secTotalMark;

  Section(
      {required this.sectionId,
      required this.sectionName,
      required this.sectionTime,
      required this.secTotalQuestion,
      required this.secTotalMark});

  Section.fromJson(Map<String, dynamic> json) {
    sectionId = json['section_id'];
    sectionName = json['section_name'];
    sectionTime = json['section_time'];
    secTotalQuestion = json['sec_total_question'];
    secTotalMark = json['sec_total_mark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['section_id'] = this.sectionId;
    data['section_name'] = this.sectionName;
    data['section_time'] = this.sectionTime;
    data['sec_total_question'] = this.secTotalQuestion;
    data['sec_total_mark'] = this.secTotalMark;
    return data;
  }
}

class QuestionData {
  String? quesId;
  String? sectionId;
  String? quesDesc;
  String? positiveMark;
  String? negativeMark;
  String? quesTime;
  String? quesExpl;
  List<Options>? options;

  QuestionData(
      {required this.quesId,
      required this.sectionId,
      required this.quesDesc,
      required this.positiveMark,
      required this.negativeMark,
      required this.quesTime,
      required this.quesExpl,
      required this.options});

  QuestionData.fromJson(Map<String, dynamic> json) {
    quesId = json['ques_id'];
    sectionId = json['section_id'];
    quesDesc = json['ques_desc'];
    positiveMark = json['positive_mark'];
    negativeMark = json['negative_mark'];
    quesTime = json['ques_time'];
    quesExpl = json['ques_expl'];
    if (json['options'] != null) {
      options = new List.empty(growable: true);
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ques_id'] = this.quesId;
    data['section_id'] = this.sectionId;
    data['ques_desc'] = this.quesDesc;
    data['positive_mark'] = this.positiveMark;
    data['negative_mark'] = this.negativeMark;
    data['ques_time'] = this.quesTime;
    data['ques_expl'] = this.quesExpl;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  String? optionDesc;
  String? isCorrect;
  String? ansScore;
  int? userResponse;

  Options(
      {required this.optionDesc,
      required this.isCorrect,
      required this.ansScore,
      required this.userResponse});

  Options.fromJson(Map<String, dynamic> json) {
    optionDesc = json['option_desc'];
    isCorrect = json['is_correct'];
    ansScore = json['ans_score'];
    userResponse = json['user_response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['option_desc'] = this.optionDesc;
    data['is_correct'] = this.isCorrect;
    data['ans_score'] = this.ansScore;
    data['user_response'] = this.userResponse;
    return data;
  }
}
