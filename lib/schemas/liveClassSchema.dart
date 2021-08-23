class LiveClassScheme {
  List<LiveClass>? liveClass;
  int? flag;

  LiveClassScheme({required this.liveClass, required this.flag});

  LiveClassScheme.fromJson(Map<String, dynamic> json) {
    if (json['live_class'] != null) {
      liveClass = new List.empty(growable: true);
      json['live_class'].forEach((v) {
        liveClass!.add(new LiveClass.fromJson(v));
      });
    }
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.liveClass != null) {
      data['live_class'] = this.liveClass!.map((v) => v.toJson()).toList();
    }
    data['flag'] = this.flag;
    return data;
  }
}

class LiveClass {
  String? meetingid;
  int? server;
  String? studentname;
  String? comment;
  String? classDate;
  String? startTime;
  String? endTime;
  String? duration;
  String? title;
  String? recordedLink;
  String? url;
  String? categoryName;
  String? createdOn;

  LiveClass(
      {required this.meetingid,
      required this.server,
      required this.studentname,
      required this.comment,
      required this.classDate,
      required this.startTime,
      required this.endTime,
      required this.duration,
      required this.title,
      required this.recordedLink,
      required this.categoryName,
      required this.createdOn});

  LiveClass.fromJson(Map<String, dynamic> json) {
    meetingid = json['meetingid'];
    server = json['server'];
    studentname = json['studentname'];
    comment = json['comment'];
    classDate = json['class_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    duration = json['duration'];
    title = json['title'];
    recordedLink = json['recorded_link'];
    url=json['url'];
    categoryName = json['category_name'];
    createdOn = json['created_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['meetingid'] = this.meetingid;
    data['server'] = this.server;
    data['studentname'] = this.studentname;
    data['comment'] = this.comment;
    data['class_date'] = this.classDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['duration'] = this.duration;
    data['title'] = this.title;
    data['recorded_link'] = this.recordedLink;
    data['category_name'] = this.categoryName;
    data['created_on'] = this.createdOn;
    data['url']=this.url;
    return data;
  }
}
