class FLTTestData {
  int? flag;
  List<TestData>? testData;

  FLTTestData({required this.flag, required this.testData});

  FLTTestData.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    if (json['test_data'] != null) {
      testData = List<TestData>.empty(growable: true);
      json['test_data'].forEach((v) {
        testData!.add(new TestData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    if (this.testData != null) {
      data['test_data'] = this.testData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TestData {
  String? testId;
  int? examId;
  String? testLanguage;
  int? testStatus;
  String? testName;
  String? totalQues;
  String? totalTime;
  String? testDesc;
  String? addDate;
  String? positiveMark;
  String? negativeMark;
  String? totalMark;
  String? testReqPer;
  int? isAttempted;
  dynamic resCount;
  dynamic percentage;
  dynamic markObtain;

  TestData(
      {required this.testId,
      required this.examId,
      required this.testLanguage,
      required this.testStatus,
      required this.testName,
      required this.totalQues,
      required this.totalTime,
      required this.testDesc,
      required this.addDate,
      required this.positiveMark,
      required this.negativeMark,
      required this.totalMark,
      required this.testReqPer,
      required this.isAttempted,
      required this.resCount,
      required this.percentage,
      required this.markObtain});

  TestData.fromJson(Map<String, dynamic> json) {
    testId = json['test_id'];
    examId = json['exam_id'];
    testLanguage = json['test_language'];
    testStatus = json['test_status'];
    testName = json['test_name'];
    totalQues = json['total_ques'];
    totalTime = json['total_time'];
    testDesc = json['test_desc'];
    addDate = json['add_date'];
    positiveMark = json['positive_mark'];
    negativeMark = json['negative_mark'];
    totalMark = json['total_mark'];
    testReqPer = json['test_req_per'];
    isAttempted = json['is_attempted'];
    resCount = json['res_count'];
    percentage = json['percentage'];
    markObtain = json['mark_obtain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['test_id'] = this.testId;
    data['exam_id'] = this.examId;
    data['test_language'] = this.testLanguage;
    data['test_status'] = this.testStatus;
    data['test_name'] = this.testName;
    data['total_ques'] = this.totalQues;
    data['total_time'] = this.totalTime;
    data['test_desc'] = this.testDesc;
    data['add_date'] = this.addDate;
    data['positive_mark'] = this.positiveMark;
    data['negative_mark'] = this.negativeMark;
    data['total_mark'] = this.totalMark;
    data['test_req_per'] = this.testReqPer;
    data['is_attempted'] = this.isAttempted;
    data['res_count'] = this.resCount;
    data['percentage'] = this.percentage;
    data['mark_obtain'] = this.markObtain;
    return data;
  }
}
