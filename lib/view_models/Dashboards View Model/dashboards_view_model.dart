// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/Api%20services/cv_api.dart';
import 'package:home_workout_app/Api%20services/dashboards_api.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/models/comments_model.dart';
import 'package:home_workout_app/models/cv_model.dart';
import 'package:home_workout_app/models/dashboard_model.dart';
import 'package:home_workout_app/models/post_models.dart';

class DashboardsViewModel with ChangeNotifier {
  bool _isLoading = false;
  DashboardModel _dashboard = DashboardModel();
  List<PostModel> _pendingPosts = [];
  List<PostModel> _reportedPosts = [];
  List<CVModel> _pendingCVs = [];
  List<CommentsModel> _reportedComments = [];
  bool _isARLoading = false;
  int _page = 0;

  void reset() {
    _dashboard = DashboardModel();
    _pendingCVs.clear();
    _pendingPosts.clear();
    _reportedComments.clear();
    _reportedPosts.clear();
    _page = 0;
  }

  void setPage(value) {
    _page = value;
    notifyListeners();
  }

  void setARLoading(value) {
    _isARLoading = value;
    notifyListeners();
  }

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> setDashbaord({required String lang}) async {
    setIsLoading(true);
    _dashboard = await DashboardsAPI().getDashboards(lang: lang);
    setIsLoading(false);
  }

  Future<void> setCVs({required String lang}) async {
    setPage(getPage + 1);
    setIsLoading(true);
    final newArray =
        await DashboardsAPI().getCVsDashbaord(lang: lang, page: getPage);
    print(newArray.length);
    if (newArray.isEmpty) setPage(getPage - 1);
    _pendingCVs.addAll(newArray);
    print(_pendingCVs.length);
    setIsLoading(false);
  }

  Future<void> setPostsDashbaord({required String lang}) async {
    setPage(getPage + 1);
    setIsLoading(true);
    final newArray =
        await DashboardsAPI().getPostsDashboard(lang: lang, page: getPage);
    _pendingPosts.addAll(newArray);
    if (newArray.isEmpty) setPage(getPage - 1);
    print(_pendingPosts);
    setIsLoading(false);
  }

  Future<void> setReportedPostsDashbaord({required String lang}) async {
    setIsLoading(true);
    setPage(getPage + 1);
    final newArray = await DashboardsAPI()
        .getReportedPostDashboard(lang: lang, page: getPage);
    _reportedPosts.addAll(newArray);
    if (newArray.isEmpty) setPage(getPage - 1);
    setIsLoading(false);
  }

  Future<void> setReportedCommentsDashbaord({required String lang}) async {
    setPage(getPage + 1);
    setIsLoading(true);
    final newArray = await DashboardsAPI()
        .getReportedCommentsDashbaord(lang: lang, page: getPage);
    _reportedComments.addAll(newArray);
    if (newArray.isEmpty) setPage(getPage - 1);

    setIsLoading(false);
  }

  Future<void> ARPosts(
      {required String lang,
      required String id,
      required bool acc,
      required BuildContext context,
      required bool reported}) async {
    setARLoading(true);
    final response = await DashboardsAPI().ARPost(lang: lang, id: id, acc: acc);
    if (response['success']) {
      if (reported)
        _reportedPosts
            .removeWhere((element) => element.postId.toString() == id);
      else
        _pendingPosts.removeWhere((element) => element.postId.toString() == id);
      notifyListeners();
    } else {
      showSnackbar(Text(response['message'].toString()), context);
    }
    setARLoading(false);
  }

  Future<void> ARComments(
      {required String lang,
      required String id,
      required bool acc,
      required BuildContext context}) async {
    final response =
        await DashboardsAPI().ARComments(lang: lang, id: id, acc: acc);
    if (response['success']) {
      _reportedComments.removeWhere((element) => element.id.toString() == id);
      notifyListeners();
    } else {
      showSnackbar(Text(response['message'].toString()), context);
    }
  }

  Future<void> ARCV(
      {required String id,
      required bool state,
      required String lang,
      required BuildContext context}) async {
    final response;
    if (state) {
      response = await CVApi().AcceptCV(lang: lang, id: id);
    } else {
      response = await CVApi().RefuseCV(lang: lang, id: id);
    }

    if (response['success']) {
      _pendingCVs.removeWhere((element) => element.id.toString() == id);
      notifyListeners();
    } else
      showSnackbar(Text(response['message'].toString()), context);
  }

  bool get getIsLoading => _isLoading;
  DashboardModel get getDashboard => _dashboard;
  List<PostModel> get getPendingPosts => _pendingPosts;
  List<PostModel> get getReportedPosts => _reportedPosts;
  List<CommentsModel> get getReportedComments => _reportedComments;

  bool get getARLoading => _isARLoading;
  List<CVModel> get getCVsDashbaord => _pendingCVs;
  int get getPage => _page;
}
