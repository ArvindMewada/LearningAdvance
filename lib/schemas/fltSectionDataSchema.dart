class FLTSectionData {
  int? flag;
  List<SectionData>? sectionData;

  FLTSectionData({required this.flag, required this.sectionData});

  FLTSectionData.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    if (json['section_data'] != null) {
      sectionData = new List<SectionData>.empty(growable: true);
      json['section_data'].forEach((v) {
        sectionData!.add(new SectionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    if (this.sectionData != null) {
      data['section_data'] = this.sectionData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SectionData {
  String? sectionId;
  String? sectionName;
  String? sectionTime;
  String? secTotalQuestion;
  String? secTotalMark;

  SectionData(
      {required this.sectionId,
      required this.sectionName,
      required this.sectionTime,
      required this.secTotalQuestion,
      required this.secTotalMark});

  SectionData.fromJson(Map<String, dynamic> json) {
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
