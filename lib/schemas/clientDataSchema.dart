class ClientData {
  List<HomeElements>? homeElements;
  int? flag;

  ClientData({required this.homeElements, required this.flag});

  ClientData.fromJson(Map<String, dynamic> json) {
    if (json['home_elements'] != null) {
      homeElements = new List.empty(growable: true);
      json['home_elements'].forEach((v) {
        homeElements!.add(new HomeElements.fromJson(v));
      });
    }
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.homeElements != null) {
      data['home_elements'] =
          this.homeElements!.map((v) => v.toJson()).toList();
    }
    data['flag'] = this.flag;
    return data;
  }
}

class HomeElements {
  String? homeElementId;
  String? status;
  String? title1;
  String? title2;
  int? seqNo;

  HomeElements(
      {required this.homeElementId,
      required this.status,
      required this.title1,
      required this.title2,
      required this.seqNo});

  HomeElements.fromJson(Map<String, dynamic> json) {
    homeElementId = json['home_element_id'];
    status = json['status'];
    title1 = json['title_1'];
    title2 = json['title_2'];
    seqNo = json['seq_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['home_element_id'] = this.homeElementId;
    data['status'] = this.status;
    data['title_1'] = this.title1;
    data['title_2'] = this.title2;
    data['seq_no'] = this.seqNo;
    return data;
  }
}
