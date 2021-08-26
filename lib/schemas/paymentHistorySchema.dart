class PaymentHistory {
  List<Response>? response;
  String? status;
  String? msg;
  int? flag;

  PaymentHistory(
      {required this.response,
      required this.status,
      required this.msg,
      required this.flag});

  PaymentHistory.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = new List<Response>.empty(growable: true);
      json['response'].forEach((v) {
        response!.add(new Response.fromJson(v));
      });
    }
    status = json['status'];
    msg = json['msg'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['msg'] = this.msg;
    data['flag'] = this.flag;
    return data;
  }
}

class Response {
  String? paymentId;
  String? amount;
  String? createdOn;

  Response(
      {required this.paymentId, required this.amount, required this.createdOn});

  Response.fromJson(Map<String, dynamic> json) {
    paymentId = json['payment_id'];
    amount = json['amount'];
    createdOn = json['created_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_id'] = this.paymentId;
    data['amount'] = this.amount;
    data['created_on'] = this.createdOn;
    return data;
  }
}
