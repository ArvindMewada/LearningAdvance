class SectionQuiz {
  List<QuestionData>? questionData;
  int? flag;

  SectionQuiz({required this.questionData, required this.flag});

  SectionQuiz.fromJson(Map<String, dynamic> json) {
    if (json['question_data'] != null) {
      questionData = new List<QuestionData>.empty(growable: true);
      json['question_data'].forEach((v) {
        questionData!.add(new QuestionData.fromJson(v));
      });
    }
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.questionData != null) {
      data['question_data'] =
          this.questionData!.map((v) => v.toJson()).toList();
    }
    data['flag'] = this.flag;
    return data;
  }
}

class QuestionData {
  String? quesId;
  String? quesDesc;
  String? positiveMark;
  String? negativeMark;
  String? quesExpl;
  List<Options>? options;

  QuestionData(
      {required this.quesId,
      required this.quesDesc,
      required this.positiveMark,
      required this.negativeMark,
      required this.quesExpl,
      required this.options});

  QuestionData.fromJson(Map<String, dynamic> json) {
    quesId = json['ques_id'];
    quesDesc = json['ques_desc'];
    positiveMark = json['positive_mark'];
    negativeMark = json['negative_mark'];
    quesExpl = json['ques_expl'];
    if (json['options'] != null) {
      options = new List<Options>.empty(growable: true);
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ques_id'] = this.quesId;
    data['ques_desc'] = this.quesDesc;
    data['positive_mark'] = this.positiveMark;
    data['negative_mark'] = this.negativeMark;
    data['ques_expl'] = this.quesExpl;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  String? ansKey;
  String? optionDesc;
  String? isCorrect;

  Options(
      {required this.ansKey,
      required this.optionDesc,
      required this.isCorrect});

  Options.fromJson(Map<String, dynamic> json) {
    ansKey = json['ans_key'];
    optionDesc = json['option_desc'];
    isCorrect = json['is_correct'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ans_key'] = this.ansKey;
    data['option_desc'] = this.optionDesc;
    data['is_correct'] = this.isCorrect;
    return data;
  }
}
