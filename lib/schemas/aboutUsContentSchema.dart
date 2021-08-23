class AboutUsContent {
  int? flag;
  String? orgLogo;
  String? orgName;
  String? orgAddress;
  String? orgType;
  String? aboutUs;
  String? city;
  String? state;
  String? contactDetails;
  bool? isAdmin;
  bool? walletSupport;

  AboutUsContent(
      {required this.flag,
      required this.orgLogo,
      required this.orgName,
      required this.orgAddress,
      required this.orgType,
      required this.aboutUs,
      required this.city,
      required this.state,
      required this.contactDetails,
      required this.isAdmin,
      required this.walletSupport});

  AboutUsContent.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    orgLogo = json['org_logo'];
    orgName = json['org_name'];
    orgAddress = json['org_address'];
    orgType = json['org_type'];
    aboutUs = json['about_us'];
    city = json['city'];
    state = json['state'];
    contactDetails = json['contact_details'];
    isAdmin = json['is_admin'];
    walletSupport = json['wallet_support'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    data['org_logo'] = this.orgLogo;
    data['org_name'] = this.orgName;
    data['org_address'] = this.orgAddress;
    data['org_type'] = this.orgType;
    data['about_us'] = this.aboutUs;
    data['city'] = this.city;
    data['state'] = this.state;
    data['contact_details'] = this.contactDetails;
    data['is_admin'] = this.isAdmin;
    data['wallet_support'] = this.walletSupport;
    return data;
  }
}
