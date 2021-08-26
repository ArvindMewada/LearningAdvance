// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

import 'dart:typed_data';

import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';

import 'dbModel.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(2, 9000443392276537990),
      name: 'Post',
      lastPropertyId: const IdUid(35, 7502677200632167705),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 7541377614141781770),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 1637578088121575353),
            name: 'post_id',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 5179427191730360769),
            name: 'community_id',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 3143112527487464426),
            name: 'app_id',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 7714052223704348819),
            name: 'user_id',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 2519171951148238352),
            name: 'fname',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 8015262498273619138),
            name: 'lname',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 2208069052742218661),
            name: 'post_type',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 2562412451641235809),
            name: 'post_title',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 7402747012513400828),
            name: 'post_description',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 593362540450387370),
            name: 'video_url',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 8710199618892406632),
            name: 'user_org_name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 8681596520323527645),
            name: 'comment_count',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 1117606731057839492),
            name: 'upvote_count',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 2635193640161133297),
            name: 'view_count',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(16, 6195547663351146382),
            name: 'city_name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(17, 1749921982624011130),
            name: 'spam_count',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(18, 7133076940103003541),
            name: 'post_date',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(20, 2134450632083811212),
            name: 'is_ques_correct',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(21, 4518938786339995317),
            name: 'attemptmsg',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(22, 8803986400893681506),
            name: 'post_image',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(23, 2731096345403903987),
            name: 'upvoteFlag',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(24, 2806790195388820753),
            name: 'job_title',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(25, 2977210165662540539),
            name: 'user_image',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(26, 2850712473524153180),
            name: 'is_notify',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(27, 1473029199216713711),
            name: 'tag',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(28, 2967766943945773549),
            name: 'question_reward',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(29, 8705285830659371686),
            name: 'correct_response',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(30, 3680602351936750598),
            name: 'status',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(31, 2347869612246580597),
            name: 'is_user_post',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(32, 1851670871258589590),
            name: 'display_type',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(33, 7340279216620633520),
            name: 'reserve_1',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(34, 3354719629737655876),
            name: 'group_hash_tag',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(35, 7502677200632167705),
            name: 'ques_attempt_flag',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(3, 6992210478004840866),
      name: 'TestDataElement',
      lastPropertyId: const IdUid(18, 2956387350210764498),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 851962447405202818),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 4886087822833632615),
            name: 'test_hash',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 736423790759024368),
            name: 'exam_id',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 5270467898002880792),
            name: 'test_status',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 553074083162732602),
            name: 'test_name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 240498217061775485),
            name: 'test_tag',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 1654950063770333365),
            name: 'total_ques',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 9058624755245736873),
            name: 'total_time',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 6238120725955493564),
            name: 'test_desc',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 2312570355069236227),
            name: 'test_sequence_no',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 3358751162161261424),
            name: 'is_notify',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 7466458220132919028),
            name: 'add_date',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 4811671847337686658),
            name: 'positive_mark',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 3420461047819434522),
            name: 'negative_mark',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 8128676254400295135),
            name: 'total_mark',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(16, 5044222684081359337),
            name: 'is_attempted',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(18, 2956387350210764498),
            name: 'mark_obtain',
            type: 8,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(4, 1450570847795846790),
      name: 'ExamElement',
      lastPropertyId: const IdUid(8, 6690872084469427101),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8591650649402728662),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 5706560343159759733),
            name: 'exam_id',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 5029765780007647962),
            name: 'exam_name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 5381920574316031054),
            name: 'exam_title_1',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 8210432467865448515),
            name: 'exam_title_2',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 5686637201192572110),
            name: 'tag',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 6333377532389966253),
            name: 'sequence_no',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 6690872084469427101),
            name: 'status',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(5, 830704992142205569),
      name: 'TestReadingElement',
      lastPropertyId: const IdUid(12, 4641240536771690673),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 4759317329129118100),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 4024226547150991876),
            name: 'mob_post_hash',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 8155178053402698780),
            name: 'title',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 2028062821262050401),
            name: 'content',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 3323237196064151127),
            name: 'add_date',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 7186259665186658647),
            name: 'category',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 5630285531438080149),
            name: 'subcategory',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 6946901187786634555),
            name: 'type',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 8481491386834918630),
            name: 'seq_no',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 8459169023736773048),
            name: 'status',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 5468770127286738050),
            name: 'is_notify',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 4641240536771690673),
            name: 'url',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(6, 4886452614378009734),
      name: 'FLTExamElement',
      lastPropertyId: const IdUid(4, 2522081532140424234),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 704491864299901404),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 3711224404892693953),
            name: 'title',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 5331561986087511844),
            name: 'subtitle',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 2522081532140424234),
            name: 'sub_menu1',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(9, 4235405095284060360),
      name: 'GroupElement',
      lastPropertyId: const IdUid(8, 1539095804424221965),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8357026563066017468),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 5794978026940603877),
            name: 'communityId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 1853143858347802777),
            name: 'tag',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 5158417335246525537),
            name: 'countFollower',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 7427223157089444508),
            name: 'countPost',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 20045892811171814),
            name: 'about',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 7195662573425259216),
            name: 'groupHashTag',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 1539095804424221965),
            name: 'checkedStatus',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(10, 9205414386661728961),
      name: 'BookmarkElement',
      lastPropertyId: const IdUid(4, 9039240801327902799),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 1516938904896800812),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 1818485065312487002),
            name: 'title',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 3058638415740611479),
            name: 'subtitle',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 9039240801327902799),
            name: 'content',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(10, 9205414386661728961),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [
        7288187141363789903,
        2171344003379964843,
        263046435501933612
      ],
      retiredIndexUids: const [],
      retiredPropertyUids: const [
        1010240379221807189,
        6826903485960449000,
        225697291107645537,
        9021354353655832093,
        6279412721829091579,
        416436645714174639,
        2368081061117040209,
        6200188029286662983,
        873517591058869888,
        7649060048755025587,
        379091133003067061,
        137756442739934465,
        3536431590074598379,
        1076727782599557943,
        6639090817568723058,
        1223396478346732709,
        1962274799594757688,
        1989893669239868951,
        8207709579635259126,
        717557306638580234,
        4774185574919187193,
        8947569676668661791,
        8296981545481828156,
        6636725050290761491,
        450291446583072183,
        5421414594909925679,
        8088928309458559353,
        7657460309410187249,
        1984476081455849627,
        396568761585135134,
        988592390489175890
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    Post: EntityDefinition<Post>(
        model: _entities[0],
        toOneRelations: (Post object) => [],
        toManyRelations: (Post object) => {},
        getId: (Post object) => object.id,
        setId: (Post object, int id) {
          object.id = id;
        },
        objectToFB: (Post object, fb.Builder fbb) {
          final post_idOffset = fbb.writeString(object.post_id);
          final community_idOffset = fbb.writeString(object.community_id);
          final user_idOffset = fbb.writeString(object.user_id);
          final fnameOffset =
              object.fname == null ? null : fbb.writeString(object.fname!);
          final lnameOffset =
              object.lname == null ? null : fbb.writeString(object.lname!);
          final post_typeOffset = object.post_type == null
              ? null
              : fbb.writeString(object.post_type!);
          final post_titleOffset = object.post_title == null
              ? null
              : fbb.writeString(object.post_title!);
          final post_descriptionOffset = object.post_description == null
              ? null
              : fbb.writeString(object.post_description!);
          final video_urlOffset = object.video_url == null
              ? null
              : fbb.writeString(object.video_url!);
          final user_org_nameOffset = object.user_org_name == null
              ? null
              : fbb.writeString(object.user_org_name!);
          final city_nameOffset = object.city_name == null
              ? null
              : fbb.writeString(object.city_name!);
          final post_dateOffset = fbb.writeString(object.post_date);
          final attemptmsgOffset = object.attemptmsg == null
              ? null
              : fbb.writeString(object.attemptmsg!);
          final post_imageOffset = object.post_image == null
              ? null
              : fbb.writeString(object.post_image!);
          final job_titleOffset = object.job_title == null
              ? null
              : fbb.writeString(object.job_title!);
          final user_imageOffset = object.user_image == null
              ? null
              : fbb.writeString(object.user_image!);
          final tagOffset =
              object.tag == null ? null : fbb.writeString(object.tag!);
          final question_rewardOffset = object.question_reward == null
              ? null
              : fbb.writeString(object.question_reward!);
          final correct_responseOffset = object.correct_response == null
              ? null
              : fbb.writeString(object.correct_response!);
          final statusOffset =
              object.status == null ? null : fbb.writeString(object.status!);
          final display_typeOffset = object.display_type == null
              ? null
              : fbb.writeString(object.display_type!);
          final reserve_1Offset = object.reserve_1 == null
              ? null
              : fbb.writeString(object.reserve_1!);
          final group_hash_tagOffset = object.group_hash_tag == null
              ? null
              : fbb.writeString(object.group_hash_tag!);
          fbb.startTable(36);
          fbb.addInt64(0, object.id ?? 0);
          fbb.addOffset(1, post_idOffset);
          fbb.addOffset(2, community_idOffset);
          fbb.addInt64(3, object.app_id);
          fbb.addOffset(4, user_idOffset);
          fbb.addOffset(5, fnameOffset);
          fbb.addOffset(6, lnameOffset);
          fbb.addOffset(7, post_typeOffset);
          fbb.addOffset(8, post_titleOffset);
          fbb.addOffset(9, post_descriptionOffset);
          fbb.addOffset(10, video_urlOffset);
          fbb.addOffset(11, user_org_nameOffset);
          fbb.addInt64(12, object.comment_count);
          fbb.addInt64(13, object.upvote_count);
          fbb.addInt64(14, object.view_count);
          fbb.addOffset(15, city_nameOffset);
          fbb.addInt64(16, object.spam_count);
          fbb.addOffset(17, post_dateOffset);
          fbb.addInt64(19, object.is_ques_correct);
          fbb.addOffset(20, attemptmsgOffset);
          fbb.addOffset(21, post_imageOffset);
          fbb.addInt64(22, object.upvoteFlag);
          fbb.addOffset(23, job_titleOffset);
          fbb.addOffset(24, user_imageOffset);
          fbb.addInt64(25, object.is_notify);
          fbb.addOffset(26, tagOffset);
          fbb.addOffset(27, question_rewardOffset);
          fbb.addOffset(28, correct_responseOffset);
          fbb.addOffset(29, statusOffset);
          fbb.addInt64(30, object.is_user_post);
          fbb.addOffset(31, display_typeOffset);
          fbb.addOffset(32, reserve_1Offset);
          fbb.addOffset(33, group_hash_tagOffset);
          fbb.addInt64(34, object.ques_attempt_flag);
          fbb.finish(fbb.endTable());
          return object.id ?? 0;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Post(
              id: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 4),
              post_id:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              community_id:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              app_id:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0),
              user_id:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 12, ''),
              fname: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 14),
              lname: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 16),
              post_type: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 18),
              post_title: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 20),
              post_description: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 22),
              video_url: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 24),
              user_org_name: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 26),
              comment_count:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 28, 0),
              upvote_count:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 30, 0),
              view_count: const fb.Int64Reader().vTableGet(buffer, rootOffset, 32, 0),
              city_name: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 34),
              spam_count: const fb.Int64Reader().vTableGet(buffer, rootOffset, 36, 0),
              post_date: const fb.StringReader().vTableGet(buffer, rootOffset, 38, ''),
              is_notify: const fb.Int64Reader().vTableGet(buffer, rootOffset, 54, 0),
              tag: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 56),
              question_reward: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 58),
              correct_response: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 60),
              status: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 62),
              is_user_post: const fb.Int64Reader().vTableGet(buffer, rootOffset, 64, 0),
              display_type: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 66),
              reserve_1: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 68),
              group_hash_tag: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 70),
              ques_attempt_flag: const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 72),
              is_ques_correct: const fb.Int64Reader().vTableGet(buffer, rootOffset, 42, 0),
              attemptmsg: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 44),
              post_image: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 46),
              upvoteFlag: const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 48),
              job_title: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 50),
              user_image: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 52));

          return object;
        }),
    TestDataElement: EntityDefinition<TestDataElement>(
        model: _entities[1],
        toOneRelations: (TestDataElement object) => [],
        toManyRelations: (TestDataElement object) => {},
        getId: (TestDataElement object) => object.id,
        setId: (TestDataElement object, int id) {
          object.id = id;
        },
        objectToFB: (TestDataElement object, fb.Builder fbb) {
          final test_hashOffset = object.test_hash == null
              ? null
              : fbb.writeString(object.test_hash!);
          final test_nameOffset = object.test_name == null
              ? null
              : fbb.writeString(object.test_name!);
          final test_tagOffset = object.test_tag == null
              ? null
              : fbb.writeString(object.test_tag!);
          final total_quesOffset = object.total_ques == null
              ? null
              : fbb.writeString(object.total_ques!);
          final total_timeOffset = object.total_time == null
              ? null
              : fbb.writeString(object.total_time!);
          final test_descOffset = object.test_desc == null
              ? null
              : fbb.writeString(object.test_desc!);
          final test_sequence_noOffset = object.test_sequence_no == null
              ? null
              : fbb.writeString(object.test_sequence_no!);
          final add_dateOffset = object.add_date == null
              ? null
              : fbb.writeString(object.add_date!);
          final positive_markOffset = object.positive_mark == null
              ? null
              : fbb.writeString(object.positive_mark!);
          final negative_markOffset = object.negative_mark == null
              ? null
              : fbb.writeString(object.negative_mark!);
          final total_markOffset = object.total_mark == null
              ? null
              : fbb.writeString(object.total_mark!);
          fbb.startTable(19);
          fbb.addInt64(0, object.id ?? 0);
          fbb.addOffset(1, test_hashOffset);
          fbb.addInt64(2, object.exam_id);
          fbb.addInt64(3, object.test_status);
          fbb.addOffset(4, test_nameOffset);
          fbb.addOffset(5, test_tagOffset);
          fbb.addOffset(6, total_quesOffset);
          fbb.addOffset(7, total_timeOffset);
          fbb.addOffset(8, test_descOffset);
          fbb.addOffset(9, test_sequence_noOffset);
          fbb.addInt64(10, object.is_notify);
          fbb.addOffset(11, add_dateOffset);
          fbb.addOffset(12, positive_markOffset);
          fbb.addOffset(13, negative_markOffset);
          fbb.addOffset(14, total_markOffset);
          fbb.addInt64(15, object.is_attempted);
          fbb.addFloat64(17, object.mark_obtain);
          fbb.finish(fbb.endTable());
          return object.id ?? 0;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = TestDataElement(
              id: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 4),
              test_hash: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 6),
              add_date: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 26),
              exam_id: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              is_attempted: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 34),
              is_notify: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 24),
              mark_obtain: const fb.Float64Reader()
                  .vTableGetNullable(buffer, rootOffset, 38),
              negative_mark: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 30),
              positive_mark: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 28),
              test_desc: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 20),
              test_name: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 12),
              test_sequence_no: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 22),
              test_status: const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 10),
              test_tag: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 14),
              total_mark: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 32),
              total_ques: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 16),
              total_time: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 18),
              percentage: null);

          return object;
        }),
    ExamElement: EntityDefinition<ExamElement>(
        model: _entities[2],
        toOneRelations: (ExamElement object) => [],
        toManyRelations: (ExamElement object) => {},
        getId: (ExamElement object) => object.id,
        setId: (ExamElement object, int id) {
          object.id = id;
        },
        objectToFB: (ExamElement object, fb.Builder fbb) {
          final exam_nameOffset = object.exam_name == null
              ? null
              : fbb.writeString(object.exam_name!);
          final exam_title_1Offset = object.exam_title_1 == null
              ? null
              : fbb.writeString(object.exam_title_1!);
          final exam_title_2Offset = object.exam_title_2 == null
              ? null
              : fbb.writeString(object.exam_title_2!);
          final tagOffset =
              object.tag == null ? null : fbb.writeString(object.tag!);
          fbb.startTable(9);
          fbb.addInt64(0, object.id ?? 0);
          fbb.addInt64(1, object.exam_id);
          fbb.addOffset(2, exam_nameOffset);
          fbb.addOffset(3, exam_title_1Offset);
          fbb.addOffset(4, exam_title_2Offset);
          fbb.addOffset(5, tagOffset);
          fbb.addInt64(6, object.sequence_no);
          fbb.addInt64(7, object.status);
          fbb.finish(fbb.endTable());
          return object.id ?? 0;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = ExamElement(
              id: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 4),
              exam_id: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 6),
              exam_title_1: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 10),
              exam_name: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              exam_title_2: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 12),
              sequence_no: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 16),
              status: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 18),
              tag: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 14));

          return object;
        }),
    TestReadingElement: EntityDefinition<TestReadingElement>(
        model: _entities[3],
        toOneRelations: (TestReadingElement object) => [],
        toManyRelations: (TestReadingElement object) => {},
        getId: (TestReadingElement object) => object.id,
        setId: (TestReadingElement object, int id) {
          object.id = id;
        },
        objectToFB: (TestReadingElement object, fb.Builder fbb) {
          final mob_post_hashOffset = object.mob_post_hash == null
              ? null
              : fbb.writeString(object.mob_post_hash!);
          final titleOffset =
              object.title == null ? null : fbb.writeString(object.title!);
          final contentOffset =
              object.content == null ? null : fbb.writeString(object.content!);
          final add_dateOffset = object.add_date == null
              ? null
              : fbb.writeString(object.add_date!);
          final categoryOffset = object.category == null
              ? null
              : fbb.writeString(object.category!);
          final subcategoryOffset = object.subcategory == null
              ? null
              : fbb.writeString(object.subcategory!);
          final typeOffset =
              object.type == null ? null : fbb.writeString(object.type!);
          final statusOffset =
              object.status == null ? null : fbb.writeString(object.status!);
          final urlOffset =
              object.url == null ? null : fbb.writeString(object.url!);
          fbb.startTable(13);
          fbb.addInt64(0, object.id ?? 0);
          fbb.addOffset(1, mob_post_hashOffset);
          fbb.addOffset(2, titleOffset);
          fbb.addOffset(3, contentOffset);
          fbb.addOffset(4, add_dateOffset);
          fbb.addOffset(5, categoryOffset);
          fbb.addOffset(6, subcategoryOffset);
          fbb.addOffset(7, typeOffset);
          fbb.addInt64(8, object.seq_no);
          fbb.addOffset(9, statusOffset);
          fbb.addInt64(10, object.is_notify);
          fbb.addOffset(11, urlOffset);
          fbb.finish(fbb.endTable());
          return object.id ?? 0;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = TestReadingElement(
              id: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 4),
              add_date: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 12),
              category: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 14),
              content: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 10),
              is_notify: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 24),
              mob_post_hash: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 6),
              seq_no: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 20),
              status: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 22),
              subcategory: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 16),
              title: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              type: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 18),
              url: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 26));

          return object;
        }),
    FLTExamElement: EntityDefinition<FLTExamElement>(
        model: _entities[4],
        toOneRelations: (FLTExamElement object) => [],
        toManyRelations: (FLTExamElement object) => {},
        getId: (FLTExamElement object) => object.id,
        setId: (FLTExamElement object, int id) {
          object.id = id;
        },
        objectToFB: (FLTExamElement object, fb.Builder fbb) {
          final titleOffset =
              object.title == null ? null : fbb.writeString(object.title!);
          final subtitleOffset = object.subtitle == null
              ? null
              : fbb.writeString(object.subtitle!);
          final sub_menu1Offset = object.sub_menu1 == null
              ? null
              : fbb.writeString(object.sub_menu1!);
          fbb.startTable(5);
          fbb.addInt64(0, object.id ?? 0);
          fbb.addOffset(1, titleOffset);
          fbb.addOffset(2, subtitleOffset);
          fbb.addOffset(3, sub_menu1Offset);
          fbb.finish(fbb.endTable());
          return object.id ?? 0;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = FLTExamElement(
              id: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 4),
              title: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 6),
              subtitle: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              sub_menu1: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 10));

          return object;
        }),
    GroupElement: EntityDefinition<GroupElement>(
        model: _entities[5],
        toOneRelations: (GroupElement object) => [],
        toManyRelations: (GroupElement object) => {},
        getId: (GroupElement object) => object.id,
        setId: (GroupElement object, int id) {
          object.id = id;
        },
        objectToFB: (GroupElement object, fb.Builder fbb) {
          final communityIdOffset = fbb.writeString(object.communityId);
          final tagOffset = fbb.writeString(object.tag);
          final aboutOffset = fbb.writeString(object.about);
          final groupHashTagOffset = fbb.writeString(object.groupHashTag);
          fbb.startTable(9);
          fbb.addInt64(0, object.id ?? 0);
          fbb.addOffset(1, communityIdOffset);
          fbb.addOffset(2, tagOffset);
          fbb.addInt64(3, object.countFollower);
          fbb.addInt64(4, object.countPost);
          fbb.addOffset(5, aboutOffset);
          fbb.addOffset(6, groupHashTagOffset);
          fbb.addInt64(7, object.checkedStatus);
          fbb.finish(fbb.endTable());
          return object.id ?? 0;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = GroupElement(
              id: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 4),
              communityId:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              tag: const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              countFollower:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0),
              countPost:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 12, 0),
              about:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 14, ''),
              groupHashTag:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 16, ''),
              checkedStatus:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 18, 0));

          return object;
        }),
    BookmarkElement: EntityDefinition<BookmarkElement>(
        model: _entities[6],
        toOneRelations: (BookmarkElement object) => [],
        toManyRelations: (BookmarkElement object) => {},
        getId: (BookmarkElement object) => object.id,
        setId: (BookmarkElement object, int id) {
          object.id = id;
        },
        objectToFB: (BookmarkElement object, fb.Builder fbb) {
          final titleOffset = fbb.writeString(object.title);
          final subtitleOffset = fbb.writeString(object.subtitle);
          final contentOffset = fbb.writeString(object.content);
          fbb.startTable(5);
          fbb.addInt64(0, object.id ?? 0);
          fbb.addOffset(1, titleOffset);
          fbb.addOffset(2, subtitleOffset);
          fbb.addOffset(3, contentOffset);
          fbb.finish(fbb.endTable());
          return object.id ?? 0;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = BookmarkElement(
              id: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 4),
              subtitle:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              title:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              content: const fb.StringReader()
                  .vTableGet(buffer, rootOffset, 10, ''));

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [Post] entity fields to define ObjectBox queries.
class Post_ {
  /// see [Post.id]
  static final id = QueryIntegerProperty<Post>(_entities[0].properties[0]);

  /// see [Post.post_id]
  static final post_id = QueryStringProperty<Post>(_entities[0].properties[1]);

  /// see [Post.community_id]
  static final community_id =
      QueryStringProperty<Post>(_entities[0].properties[2]);

  /// see [Post.app_id]
  static final app_id = QueryIntegerProperty<Post>(_entities[0].properties[3]);

  /// see [Post.user_id]
  static final user_id = QueryStringProperty<Post>(_entities[0].properties[4]);

  /// see [Post.fname]
  static final fname = QueryStringProperty<Post>(_entities[0].properties[5]);

  /// see [Post.lname]
  static final lname = QueryStringProperty<Post>(_entities[0].properties[6]);

  /// see [Post.post_type]
  static final post_type =
      QueryStringProperty<Post>(_entities[0].properties[7]);

  /// see [Post.post_title]
  static final post_title =
      QueryStringProperty<Post>(_entities[0].properties[8]);

  /// see [Post.post_description]
  static final post_description =
      QueryStringProperty<Post>(_entities[0].properties[9]);

  /// see [Post.video_url]
  static final video_url =
      QueryStringProperty<Post>(_entities[0].properties[10]);

  /// see [Post.user_org_name]
  static final user_org_name =
      QueryStringProperty<Post>(_entities[0].properties[11]);

  /// see [Post.comment_count]
  static final comment_count =
      QueryIntegerProperty<Post>(_entities[0].properties[12]);

  /// see [Post.upvote_count]
  static final upvote_count =
      QueryIntegerProperty<Post>(_entities[0].properties[13]);

  /// see [Post.view_count]
  static final view_count =
      QueryIntegerProperty<Post>(_entities[0].properties[14]);

  /// see [Post.city_name]
  static final city_name =
      QueryStringProperty<Post>(_entities[0].properties[15]);

  /// see [Post.spam_count]
  static final spam_count =
      QueryIntegerProperty<Post>(_entities[0].properties[16]);

  /// see [Post.post_date]
  static final post_date =
      QueryStringProperty<Post>(_entities[0].properties[17]);

  /// see [Post.is_ques_correct]
  static final is_ques_correct =
      QueryIntegerProperty<Post>(_entities[0].properties[18]);

  /// see [Post.attemptmsg]
  static final attemptmsg =
      QueryStringProperty<Post>(_entities[0].properties[19]);

  /// see [Post.post_image]
  static final post_image =
      QueryStringProperty<Post>(_entities[0].properties[20]);

  /// see [Post.upvoteFlag]
  static final upvoteFlag =
      QueryIntegerProperty<Post>(_entities[0].properties[21]);

  /// see [Post.job_title]
  static final job_title =
      QueryStringProperty<Post>(_entities[0].properties[22]);

  /// see [Post.user_image]
  static final user_image =
      QueryStringProperty<Post>(_entities[0].properties[23]);

  /// see [Post.is_notify]
  static final is_notify =
      QueryIntegerProperty<Post>(_entities[0].properties[24]);

  /// see [Post.tag]
  static final tag = QueryStringProperty<Post>(_entities[0].properties[25]);

  /// see [Post.question_reward]
  static final question_reward =
      QueryStringProperty<Post>(_entities[0].properties[26]);

  /// see [Post.correct_response]
  static final correct_response =
      QueryStringProperty<Post>(_entities[0].properties[27]);

  /// see [Post.status]
  static final status = QueryStringProperty<Post>(_entities[0].properties[28]);

  /// see [Post.is_user_post]
  static final is_user_post =
      QueryIntegerProperty<Post>(_entities[0].properties[29]);

  /// see [Post.display_type]
  static final display_type =
      QueryStringProperty<Post>(_entities[0].properties[30]);

  /// see [Post.reserve_1]
  static final reserve_1 =
      QueryStringProperty<Post>(_entities[0].properties[31]);

  /// see [Post.group_hash_tag]
  static final group_hash_tag =
      QueryStringProperty<Post>(_entities[0].properties[32]);

  /// see [Post.ques_attempt_flag]
  static final ques_attempt_flag =
      QueryIntegerProperty<Post>(_entities[0].properties[33]);
}

/// [TestDataElement] entity fields to define ObjectBox queries.
class TestDataElement_ {
  /// see [TestDataElement.id]
  static final id =
      QueryIntegerProperty<TestDataElement>(_entities[1].properties[0]);

  /// see [TestDataElement.test_hash]
  static final test_hash =
      QueryStringProperty<TestDataElement>(_entities[1].properties[1]);

  /// see [TestDataElement.exam_id]
  static final exam_id =
      QueryIntegerProperty<TestDataElement>(_entities[1].properties[2]);

  /// see [TestDataElement.test_status]
  static final test_status =
      QueryIntegerProperty<TestDataElement>(_entities[1].properties[3]);

  /// see [TestDataElement.test_name]
  static final test_name =
      QueryStringProperty<TestDataElement>(_entities[1].properties[4]);

  /// see [TestDataElement.test_tag]
  static final test_tag =
      QueryStringProperty<TestDataElement>(_entities[1].properties[5]);

  /// see [TestDataElement.total_ques]
  static final total_ques =
      QueryStringProperty<TestDataElement>(_entities[1].properties[6]);

  /// see [TestDataElement.total_time]
  static final total_time =
      QueryStringProperty<TestDataElement>(_entities[1].properties[7]);

  /// see [TestDataElement.test_desc]
  static final test_desc =
      QueryStringProperty<TestDataElement>(_entities[1].properties[8]);

  /// see [TestDataElement.test_sequence_no]
  static final test_sequence_no =
      QueryStringProperty<TestDataElement>(_entities[1].properties[9]);

  /// see [TestDataElement.is_notify]
  static final is_notify =
      QueryIntegerProperty<TestDataElement>(_entities[1].properties[10]);

  /// see [TestDataElement.add_date]
  static final add_date =
      QueryStringProperty<TestDataElement>(_entities[1].properties[11]);

  /// see [TestDataElement.positive_mark]
  static final positive_mark =
      QueryStringProperty<TestDataElement>(_entities[1].properties[12]);

  /// see [TestDataElement.negative_mark]
  static final negative_mark =
      QueryStringProperty<TestDataElement>(_entities[1].properties[13]);

  /// see [TestDataElement.total_mark]
  static final total_mark =
      QueryStringProperty<TestDataElement>(_entities[1].properties[14]);

  /// see [TestDataElement.is_attempted]
  static final is_attempted =
      QueryIntegerProperty<TestDataElement>(_entities[1].properties[15]);

  /// see [TestDataElement.mark_obtain]
  static final mark_obtain =
      QueryDoubleProperty<TestDataElement>(_entities[1].properties[16]);
}

/// [ExamElement] entity fields to define ObjectBox queries.
class ExamElement_ {
  /// see [ExamElement.id]
  static final id =
      QueryIntegerProperty<ExamElement>(_entities[2].properties[0]);

  /// see [ExamElement.exam_id]
  static final exam_id =
      QueryIntegerProperty<ExamElement>(_entities[2].properties[1]);

  /// see [ExamElement.exam_name]
  static final exam_name =
      QueryStringProperty<ExamElement>(_entities[2].properties[2]);

  /// see [ExamElement.exam_title_1]
  static final exam_title_1 =
      QueryStringProperty<ExamElement>(_entities[2].properties[3]);

  /// see [ExamElement.exam_title_2]
  static final exam_title_2 =
      QueryStringProperty<ExamElement>(_entities[2].properties[4]);

  /// see [ExamElement.tag]
  static final tag =
      QueryStringProperty<ExamElement>(_entities[2].properties[5]);

  /// see [ExamElement.sequence_no]
  static final sequence_no =
      QueryIntegerProperty<ExamElement>(_entities[2].properties[6]);

  /// see [ExamElement.status]
  static final status =
      QueryIntegerProperty<ExamElement>(_entities[2].properties[7]);
}

/// [TestReadingElement] entity fields to define ObjectBox queries.
class TestReadingElement_ {
  /// see [TestReadingElement.id]
  static final id =
      QueryIntegerProperty<TestReadingElement>(_entities[3].properties[0]);

  /// see [TestReadingElement.mob_post_hash]
  static final mob_post_hash =
      QueryStringProperty<TestReadingElement>(_entities[3].properties[1]);

  /// see [TestReadingElement.title]
  static final title =
      QueryStringProperty<TestReadingElement>(_entities[3].properties[2]);

  /// see [TestReadingElement.content]
  static final content =
      QueryStringProperty<TestReadingElement>(_entities[3].properties[3]);

  /// see [TestReadingElement.add_date]
  static final add_date =
      QueryStringProperty<TestReadingElement>(_entities[3].properties[4]);

  /// see [TestReadingElement.category]
  static final category =
      QueryStringProperty<TestReadingElement>(_entities[3].properties[5]);

  /// see [TestReadingElement.subcategory]
  static final subcategory =
      QueryStringProperty<TestReadingElement>(_entities[3].properties[6]);

  /// see [TestReadingElement.type]
  static final type =
      QueryStringProperty<TestReadingElement>(_entities[3].properties[7]);

  /// see [TestReadingElement.seq_no]
  static final seq_no =
      QueryIntegerProperty<TestReadingElement>(_entities[3].properties[8]);

  /// see [TestReadingElement.status]
  static final status =
      QueryStringProperty<TestReadingElement>(_entities[3].properties[9]);

  /// see [TestReadingElement.is_notify]
  static final is_notify =
      QueryIntegerProperty<TestReadingElement>(_entities[3].properties[10]);

  /// see [TestReadingElement.url]
  static final url =
      QueryStringProperty<TestReadingElement>(_entities[3].properties[11]);
}

/// [FLTExamElement] entity fields to define ObjectBox queries.
class FLTExamElement_ {
  /// see [FLTExamElement.id]
  static final id =
      QueryIntegerProperty<FLTExamElement>(_entities[4].properties[0]);

  /// see [FLTExamElement.title]
  static final title =
      QueryStringProperty<FLTExamElement>(_entities[4].properties[1]);

  /// see [FLTExamElement.subtitle]
  static final subtitle =
      QueryStringProperty<FLTExamElement>(_entities[4].properties[2]);

  /// see [FLTExamElement.sub_menu1]
  static final sub_menu1 =
      QueryStringProperty<FLTExamElement>(_entities[4].properties[3]);
}

/// [GroupElement] entity fields to define ObjectBox queries.
class GroupElement_ {
  /// see [GroupElement.id]
  static final id =
      QueryIntegerProperty<GroupElement>(_entities[5].properties[0]);

  /// see [GroupElement.communityId]
  static final communityId =
      QueryStringProperty<GroupElement>(_entities[5].properties[1]);

  /// see [GroupElement.tag]
  static final tag =
      QueryStringProperty<GroupElement>(_entities[5].properties[2]);

  /// see [GroupElement.countFollower]
  static final countFollower =
      QueryIntegerProperty<GroupElement>(_entities[5].properties[3]);

  /// see [GroupElement.countPost]
  static final countPost =
      QueryIntegerProperty<GroupElement>(_entities[5].properties[4]);

  /// see [GroupElement.about]
  static final about =
      QueryStringProperty<GroupElement>(_entities[5].properties[5]);

  /// see [GroupElement.groupHashTag]
  static final groupHashTag =
      QueryStringProperty<GroupElement>(_entities[5].properties[6]);

  /// see [GroupElement.checkedStatus]
  static final checkedStatus =
      QueryIntegerProperty<GroupElement>(_entities[5].properties[7]);
}

/// [BookmarkElement] entity fields to define ObjectBox queries.
class BookmarkElement_ {
  /// see [BookmarkElement.id]
  static final id =
      QueryIntegerProperty<BookmarkElement>(_entities[6].properties[0]);

  /// see [BookmarkElement.title]
  static final title =
      QueryStringProperty<BookmarkElement>(_entities[6].properties[1]);

  /// see [BookmarkElement.subtitle]
  static final subtitle =
      QueryStringProperty<BookmarkElement>(_entities[6].properties[2]);

  /// see [BookmarkElement.content]
  static final content =
      QueryStringProperty<BookmarkElement>(_entities[6].properties[3]);
}
