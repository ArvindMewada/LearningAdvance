class InstituteNoti {
  String? postId;
  String? communityId;
  int? appId;
  String? userId;
  String? fname;
  String? lname;
  String? postType;
  String? postTitle;
  String? postDescription;
  String? videoUrl;
  String? userOrgName;
  int? commentCount;
  int? upvoteCount;
  int? viewCount;
  String? cityName;
  int? spamCount;
  String? postDate;
  int? isNotify;
  String? tag;
  String? questionReward;
  String? correctResponse;
  String? status;
  int? isUserPost;
  String? displayType;
  String? reserve1;
  String? groupHashTag;
  int? quesAttemptFlag;
  int? isQuesCorrect;
  String? attemptmsg;
  String? userImage;
  String? postImage;
  int? upvoteFlag;
  String? jobTitle;

  InstituteNoti(
      {required this.postId,
      required this.communityId,
      required this.appId,
      required this.userId,
      required this.fname,
      required this.lname,
      required this.postType,
      required this.postTitle,
      required this.postDescription,
      required this.videoUrl,
      required this.userOrgName,
      required this.commentCount,
      required this.upvoteCount,
      required this.viewCount,
      required this.cityName,
      required this.spamCount,
      required this.postDate,
      required this.isNotify,
      required this.tag,
      required this.questionReward,
      required this.correctResponse,
      required this.status,
      required this.isUserPost,
      required this.displayType,
      required this.reserve1,
      required this.groupHashTag,
      required this.quesAttemptFlag,
      required this.isQuesCorrect,
      required this.attemptmsg,
      required this.userImage,
      required this.postImage,
      required this.upvoteFlag,
      required this.jobTitle});

  InstituteNoti.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    communityId = json['community_id'];
    appId = json['app_id'];
    userId = json['user_id'];
    fname = json['fname'];
    lname = json['lname'];
    postType = json['post_type'];
    postTitle = json['post_title'];
    postDescription = json['post_description'];
    videoUrl = json['video_url'];
    userOrgName = json['user_org_name'];
    commentCount = json['comment_count'];
    upvoteCount = json['upvote_count'];
    viewCount = json['view_count'];
    cityName = json['city_name'];
    spamCount = json['spam_count'];
    postDate = json['post_date'];
    isNotify = json['is_notify'];
    tag = json['tag'];
    questionReward = json['question_reward'];
    correctResponse = json['correct_response'];
    status = json['status'];
    isUserPost = json['is_user_post'];
    displayType = json['display_type'];
    reserve1 = json['reserve_1'];
    groupHashTag = json['group_hash_tag'];
    quesAttemptFlag = json['ques_attempt_flag'];
    isQuesCorrect = json['is_ques_correct'];
    attemptmsg = json['attemptmsg'];
    userImage = json['user_image'];
    postImage = json['post_image'];
    upvoteFlag = json['upvoteFlag'];
    jobTitle = json['job_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['community_id'] = this.communityId;
    data['app_id'] = this.appId;
    data['user_id'] = this.userId;
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['post_type'] = this.postType;
    data['post_title'] = this.postTitle;
    data['post_description'] = this.postDescription;
    data['video_url'] = this.videoUrl;
    data['user_org_name'] = this.userOrgName;
    data['comment_count'] = this.commentCount;
    data['upvote_count'] = this.upvoteCount;
    data['view_count'] = this.viewCount;
    data['city_name'] = this.cityName;
    data['spam_count'] = this.spamCount;
    data['post_date'] = this.postDate;
    data['is_notify'] = this.isNotify;
    data['tag'] = this.tag;
    data['question_reward'] = this.questionReward;
    data['correct_response'] = this.correctResponse;
    data['status'] = this.status;
    data['is_user_post'] = this.isUserPost;
    data['display_type'] = this.displayType;
    data['reserve_1'] = this.reserve1;
    data['group_hash_tag'] = this.groupHashTag;
    data['ques_attempt_flag'] = this.quesAttemptFlag;
    data['is_ques_correct'] = this.isQuesCorrect;
    data['attemptmsg'] = this.attemptmsg;
    data['user_image'] = this.userImage;
    data['post_image'] = this.postImage;
    data['upvoteFlag'] = this.upvoteFlag;
    data['job_title'] = this.jobTitle;
    return data;
  }
}
