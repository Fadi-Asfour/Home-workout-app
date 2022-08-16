import 'dart:developer';

import '../constants.dart';

class ExercisesModel {
  int position = 1;
  int count = 0;
  int length = 0;
  String description = '';

  int id = 0;
  String name = '';
  String imgUrl = '';

  ExercisesModel();

  ExercisesModel.fromJson(Map json) {
    position = json['position'] ?? 1;
    count = json['count'] ?? 0;
    length = json['length'] ?? 0;
    id = json['excersise']['id'] ?? 0;
    name = json['excersise']['name'] ?? '';
    imgUrl = json['excersise']['excersise_media_url'] ?? '';
    if (imgUrl.substring(0, 4) != 'http') imgUrl = '$ip/$imgUrl';
    description = json['excersise']['description'] ?? '';
  }
}
