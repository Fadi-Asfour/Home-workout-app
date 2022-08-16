import 'dart:developer';

import 'package:home_workout_app/view_models/profile_view_model.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class CommentsModel {
  String owner = '';
  String ownerImageUrl = '';
  String comment = '';
  String createdAt = '';
  int id = 0;
  int ownerId = 0;
  int reports = 0;
  double reviewRate = 0;

  CommentsModel();
  CommentsModel.fromJson(Map<String, dynamic> json) {
    log(json.toString());
    owner = json['name'] ?? '';
    comment = json['comment'] ?? '';
    createdAt = json['created_at'];
    id = json['comment_id'] ?? 0;
    ownerId = json['user_id'] ?? 0;
    ownerImageUrl = json['img'] ?? '';
    if (ownerImageUrl.substring(0, 4) != 'http') {
      ownerImageUrl = '$ip/$ownerImageUrl';
    }
    reports = json['reports'] ?? 0;
    reviewRate = double.tryParse(json['stars'].toString()) ?? 0;
  }

  CommentsModel.fromJsonForReview(Map<String, dynamic> json) {
    log(json.toString());
    owner = json['user_id']['f_name'] + ' ' + json['user_id']['l_name'] ?? '';
    comment = json['description'] ?? '';
    createdAt = json['created_at'] ?? '';
    id = json['id'] ?? 0;

    log('userId $id');
    ownerId = json['user_id']['id'] ?? 0;

    ownerImageUrl = json['user_id']['prof_img_url'] ?? '';
    if (ownerImageUrl.substring(0, 4) != 'http') {
      ownerImageUrl = '$ip/$ownerImageUrl';
    }
    reports = json['reports'] ?? 0;
    reviewRate = double.tryParse(json['stars'].toString()) ?? 0;
    // log(reviewRate.toString());
  }
}
