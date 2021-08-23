class CurrentAffair {
  List<CurrentAffairs>? currentAffairs;
  int? flag;

  CurrentAffair({required this.currentAffairs, required this.flag});

  CurrentAffair.fromJson(Map<String, dynamic> json) {
    if (json['current_affairs'] != null) {
      currentAffairs = new List.empty(growable: true);
      json['current_affairs'].forEach((v) {
        currentAffairs!.add(new CurrentAffairs.fromJson(v));
      });
    }
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.currentAffairs != null) {
      data['current_affairs'] =
          this.currentAffairs!.map((v) => v.toJson()).toList();
    }
    data['flag'] = this.flag;
    return data;
  }
}

class CurrentAffairs {
  String? mobPostHash;
  String? title;
  String? content;
  String? addDate;
  String? category;
  String? subcategory;
  String? type;
  Null url;
  int? seqNo;
  String? status;
  int? isNotify;

  CurrentAffairs(
      {required this.mobPostHash,
      required this.title,
      required this.content,
      required this.addDate,
      required this.category,
      required this.subcategory,
      required this.type,
      this.url,
      required this.seqNo,
      required this.status,
      required this.isNotify});

  CurrentAffairs.fromJson(Map<String, dynamic> json) {
    mobPostHash = json['mob_post_hash'];
    title = json['title'];
    content = json['content'];
    addDate = json['add_date'];
    category = json['category'];
    subcategory = json['subcategory'];
    type = json['type'];
    url = json['url'];
    seqNo = json['seq_no'];
    status = json['status'];
    isNotify = json['is_notify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mob_post_hash'] = this.mobPostHash;
    data['title'] = this.title;
    data['content'] = this.content;
    data['add_date'] = this.addDate;
    data['category'] = this.category;
    data['subcategory'] = this.subcategory;
    data['type'] = this.type;
    data['url'] = this.url;
    data['seq_no'] = this.seqNo;
    data['status'] = this.status;
    data['is_notify'] = this.isNotify;
    return data;
  }
}
