import 'package:objectbox/objectbox.dart';
import 'package:elearning/objectbox.g.dart';
// ignore_for_file: non_constant_identifier_names

// ignore_for_file: camel_case_types

@Entity()
class Post {
  // Each Entity needs a unique integer ID property.
  // Add `@Id()` annotation if its name isn't id (case insensitive).
  int? id;
  String post_id;
  String community_id;
  int app_id;
  String user_id;
  String? fname;
  String? lname;
  String? post_type;
  String? post_title;
  String? post_description;
  String? video_url;
  String? user_org_name;
  int comment_count;
  int upvote_count;
  int view_count;
  String? city_name;
  int spam_count;
  String post_date;
  int is_notify;
  String? tag;
  String? question_reward;
  String? correct_response;
  String? status;
  int is_user_post;
  String? display_type;
  String? reserve_1;
  String? group_hash_tag;
  int? ques_attempt_flag;
  int is_ques_correct;
  String? attemptmsg;
  String? post_image;
  int? upvoteFlag;
  String? job_title;
  String? user_image;

  // An empty default constructor is needed but you can use optional args.
  Post({
    this.id = 0,
    required this.post_id,
    required this.community_id,
    required this.app_id,
    required this.user_id,
    required this.fname,
    required this.lname,
    required this.post_type,
    required this.post_title,
    required this.post_description,
    required this.video_url,
    required this.user_org_name,
    required this.comment_count,
    required this.upvote_count,
    required this.view_count,
    required this.city_name,
    required this.spam_count,
    required this.post_date,
    required this.is_notify,
    required this.tag,
    required this.question_reward,
    required this.correct_response,
    required this.status,
    required this.is_user_post,
    required this.display_type,
    required this.reserve_1,
    required this.group_hash_tag,
    required this.ques_attempt_flag,
    required this.is_ques_correct,
    required this.attemptmsg,
    required this.post_image,
    required this.upvoteFlag,
    required this.job_title,
    required this.user_image,
  });
}

@Entity()
class TestDataElement {
  // Each Entity needs a unique integer ID property.
  // Add `@Id()` annotation if its name isn't id (case insensitive).
  int? id;
  String? test_hash;
  int? exam_id;
  int? test_status;
  String? test_name;
  String? test_tag;
  String? total_ques;
  String? total_time;
  String? test_desc;
  String? test_sequence_no;
  int? is_notify;
  String? add_date;
  String? positive_mark;
  String? negative_mark;
  String? total_mark;
  int? is_attempted;
  dynamic percentage;
  double? mark_obtain;

  // An empty default constructor is needed but you can use optional args.
  TestDataElement({
    this.id = 0,
    required this.test_hash,
    required this.add_date,
    required this.exam_id,
    required this.is_attempted,
    required this.is_notify,
    required this.mark_obtain,
    required this.negative_mark,
    required this.percentage,
    required this.positive_mark,
    required this.test_desc,
    required this.test_name,
    required this.test_sequence_no,
    required this.test_status,
    required this.test_tag,
    required this.total_mark,
    required this.total_ques,
    required this.total_time,
  });
}

@Entity()
class ExamElement {
  // Each Entity needs a unique integer ID property.
  // Add `@Id()` annotation if its name isn't id (case insensitive).
  int? id;
  int? exam_id;
  String? exam_name;
  String? exam_title_1;
  String? exam_title_2;
  String? tag;
  int? sequence_no;
  int? status;

  // An empty default constructor is needed but you can use optional args.
  ExamElement(
      {this.id = 0,
      required this.exam_id,
      required this.exam_title_1,
      required this.exam_name,
      required this.exam_title_2,
      required this.sequence_no,
      required this.status,
      required this.tag});
}

@Entity()
class TestReadingElement {
  // Each Entity needs a unique integer ID property.
  // Add `@Id()` annotation if its name isn't id (case insensitive).
  int? id;
  String? mob_post_hash;
  String? title;
  String? content;
  String? add_date;
  String? category;
  String? subcategory;
  String? type;
  String? url;
  int? seq_no;
  String? status;
  int? is_notify;

  // An empty default constructor is needed but you can use optional args.
  TestReadingElement(
      {this.id = 0,
      required this.add_date,
      required this.category,
      required this.content,
      required this.is_notify,
      required this.mob_post_hash,
      required this.seq_no,
      required this.status,
      required this.subcategory,
      required this.title,
      required this.type,
      required this.url});
}

@Entity()
class FLTExamElement {
  // Each Entity needs a unique integer ID property.
  // Add `@Id()` annotation if its name isn't id (case insensitive).
  int? id;
  String? title;
  String? subtitle;
  String? sub_menu1;
  // An empty default constructor is needed but you can use optional args.
  FLTExamElement({this.id = 0, this.title, this.subtitle, this.sub_menu1});
}

@Entity()
class GroupElement {
  // Each Entity needs a unique integer ID property.
  // Add `@Id()` annotation if its name isn't id (case insensitive).
  int? id;
  String communityId;
  String tag;
  int countFollower;
  int countPost;
  String about;
  String groupHashTag;
  int checkedStatus;
  // An empty default constructor is needed but you can use optional args.
  GroupElement(
      {this.id = 0,
      required this.communityId,
      required this.tag,
      required this.countFollower,
      required this.countPost,
      required this.about,
      required this.groupHashTag,
      required this.checkedStatus});
}

@Entity()
class BookmarkElement {
  // Each Entity needs a unique integer ID property.
  // Add `@Id()` annotation if its name isn't id (case insensitive).
  int? id;
  String title;
  String subtitle;
  String content;
  // An empty default constructor is needed but you can use optional args.
  BookmarkElement(
      {this.id = 0,
      required this.subtitle,
      required this.title,
      required this.content});
}
