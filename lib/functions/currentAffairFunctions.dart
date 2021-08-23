import 'dart:convert';

import 'package:elearning/constants.dart';
import 'package:elearning/schemas/currentAffairsSchema.dart';
import 'package:flutter/foundation.dart';
import 'package:elearning/MyStore.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

Future<List<CurrentAffairs>> getList(String param) async {
  MyStore store = VxState.store;
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
  dynamic data;
  print(formattedDate);
  await http.post(Uri.parse(currentAffairsContent_URL), body: {
    'user_id': store.studentID,
    'user_hash': store.studentHash,
    'category': 'CA_' + param,
    'add_date': formattedDate,
    'country': '-',
    'app_hash': app_hash,
  }).then((value) async {
    data = await compute(jsonDecode, value.body);
    print(data);
  });
  return List.from(CurrentAffair.fromJson(data).currentAffairs!.reversed);
}

Future<List<CurrentAffairs>> getListINTL(String param) async {
  MyStore store = VxState.store;
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
  dynamic data;
  print(formattedDate);
  await http.post(Uri.parse(currentAffairsContent_URL), body: {
    'user_id': store.studentID,
    'user_hash': store.studentHash,
    'category': 'CA_INTL_' + param,
    'add_date': formattedDate,
    'country': '-',
    'app_hash': app_hash,
  }).then((value) async {
    data = await compute(jsonDecode, value.body);
    print(data);
  });
  return List.from(CurrentAffair.fromJson(data).currentAffairs!.reversed);
}
