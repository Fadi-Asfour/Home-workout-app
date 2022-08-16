// ignore_for_file: curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/Api%20services/comments_api.dart';
import 'package:home_workout_app/Api%20services/diet_api.dart';
import 'package:home_workout_app/Api%20services/post_api.dart';
import 'package:home_workout_app/Api%20services/workout_list_api.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/models/comments_model.dart';
import 'package:home_workout_app/view_models/Diet%20View%20Model/Diet/diet_list_view_model.dart';
import 'package:home_workout_app/view_models/Posts%20View%20Model/posts_view_model.dart';
import 'package:home_workout_app/view_models/Workout_View_Model/workout_list_view_model.dart';
import 'package:provider/provider.dart';

class CommentsViewModel with ChangeNotifier {
  List<CommentsModel> _comments = [];
  int _page = 0;
  bool _getMoreLoading = false;
  bool _isLoading = false;
  bool _isdeleteLoading = false;
  bool _isReportLoading = false;

  void setIsReportLoading(value) {
    _isReportLoading = value;
    notifyListeners();
  }

  void setMoreLoading(value) {
    _getMoreLoading = value;
    notifyListeners();
  }

  void setPage(int i) {
    _page = i;
    notifyListeners();
  }

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  void setIsdeleteLoading(value) {
    _isdeleteLoading = value;
    notifyListeners();
  }

  void resetComments() {
    _comments.clear();
    notifyListeners();
  }

  Future<void> setComments({required int id, required String lang}) async {
    print('called');
    if (_comments.isEmpty) setIsLoading(true);
    setPage(getPage + 1);
    if (_comments.isNotEmpty) setMoreLoading(true);
    print('Page: ${getPage.toString()}');
    final newComments =
        await CommentsApi().getComments(id: id, lang: lang, page: getPage);
    _comments.addAll(newComments);
    print('Comments Count: ${newComments.length}');
    if (newComments.isEmpty) setPage(getPage - 1);
    setIsLoading(false);
    setMoreLoading(false);
    notifyListeners();
  }

  Future<void> setReviews({required int id, required String lang}) async {
    print('called');
    if (_comments.isEmpty) setIsLoading(true);
    setPage(getPage + 1);
    if (_comments.isNotEmpty) setMoreLoading(true);
    print('Page: ${getPage.toString()}');
    final newComments =
        await DietAPI().getReviews(id: id, lang: lang, page: getPage);
    _comments.addAll(newComments);

    if (newComments.isEmpty) setPage(getPage - 1);
    setIsLoading(false);
    setMoreLoading(false);
    notifyListeners();
  }

  Future<void> setReviewsForWorkout(
      {required int id, required String lang}) async {
    print('called');
    if (_comments.isEmpty) setIsLoading(true);
    setPage(getPage + 1);
    if (_comments.isNotEmpty) setMoreLoading(true);
    print('Page: ${getPage.toString()}');
    final newComments =
        await WorkoutListsAPI().getReviews(id: id, lang: lang, page: getPage);
    _comments.addAll(newComments);

    if (newComments.isEmpty) setPage(getPage - 1);
    setIsLoading(false);
    setMoreLoading(false);
    notifyListeners();
  }

  Future<void> sendComment(
      {required int id,
      required String lang,
      required String comment,
      required BuildContext context}) async {
    setIsLoading(true);
    final response = await CommentsApi()
        .sendCommet(comment: comment, postId: id, lang: lang);
    if (response['success']) {
      _comments.add(CommentsModel.fromJson(response['data']));
      Provider.of<PostsViewModel>(context, listen: false)
          .updatePostCommentsCount(response['data']['total'], id);
      notifyListeners();
    } else
      showSnackbar(Text(response['message']), context);
    setIsLoading(false);
  }

  Future<void> deleteComment(
      {required int commentId,
      required int postId,
      required String lang,
      required BuildContext context}) async {
    setIsdeleteLoading(true);
    final response =
        await CommentsApi().deleteComment(lang: lang, commentId: commentId);
    if (response['success']) {
      _comments.removeWhere((element) => element.id == commentId);
    } else
      showSnackbar(Text(response['message']), context);
    setIsdeleteLoading(false);
  }

  Future<bool> deleteReview(
      {required int reviewId,
      required String lang,
      required int dietId,
      required BuildContext context}) async {
    setIsdeleteLoading(true);
    final response = await DietAPI()
        .deleteReview(lang: lang, reviewId: reviewId, dietId: dietId);
    setIsdeleteLoading(false);

    if (response['success']) {
      _comments.removeWhere((element) => element.id == reviewId);
      Provider.of<DietListViewModel>(context, listen: false)
          .changeIsReviews(dietId: dietId, value: false);
      setIsdeleteLoading(false);
      return true;
    } else
      showSnackbar(Text(response['message']), context);
    setIsdeleteLoading(false);
    return false;
  }

  Future<bool> deleteReviewForWorkout(
      {required int reviewId,
      required String lang,
      required int workoutId,
      required BuildContext context}) async {
    setIsdeleteLoading(true);
    final response = await DietAPI().deleteReviewForWorkout(
        lang: lang, reviewId: reviewId, workoutId: workoutId);
    setIsdeleteLoading(false);

    if (response['success']) {
      _comments.removeWhere((element) => element.id == reviewId);
      Provider.of<WorkoutListViewModel>(context, listen: false)
          .changeIsReviews(dietId: workoutId, value: false);
      setIsdeleteLoading(false);
      return true;
    } else
      showSnackbar(Text(response['message']), context);
    setIsdeleteLoading(false);
    return false;
  }

  Future<void> updateComment(
      {required int commentId,
      required int postId,
      required String comment,
      required String lang,
      required BuildContext context}) async {
    final response = await CommentsApi()
        .updateComment(lang: lang, commentId: commentId, comment: comment);
    if (response['success']) {
      {
        _comments.firstWhere((element) => element.id == commentId).comment =
            comment;
        notifyListeners();
      }
    } else
      showSnackbar(Text(response['message']), context);
  }

  Future<void> updateReview(
      {required int reviewId,
      required int dietId,
      required String comment,
      required String lang,
      required double stars,
      required BuildContext context}) async {
    final response = await DietAPI().updateReview(
        lang: lang,
        reviewId: reviewId,
        comment: comment,
        dietId: dietId,
        stars: stars);
    if (response['success']) {
      {
        _comments.firstWhere((element) => element.id == reviewId).comment =
            comment;
        _comments.firstWhere((element) => element.id == reviewId).reviewRate =
            stars;
        notifyListeners();
      }
    } else
      showSnackbar(Text(response['message']), context);
  }

  Future<void> updateReviewForWorkout(
      {required int reviewId,
      required int workoutId,
      required String comment,
      required String lang,
      required double stars,
      required BuildContext context}) async {
    final response = await DietAPI().updateReviewForWorkout(
        lang: lang,
        reviewId: reviewId,
        comment: comment,
        workoutId: workoutId,
        stars: stars);
    if (response['success']) {
      {
        _comments.firstWhere((element) => element.id == reviewId).comment =
            comment;
        _comments.firstWhere((element) => element.id == reviewId).reviewRate =
            stars;
        notifyListeners();
      }
    } else
      showSnackbar(Text(response['message']), context);
  }

  Future<void> reportComment(
      {required int commentId,
      required String lang,
      required BuildContext context}) async {
    setIsReportLoading(true);
    final response =
        await CommentsApi().reportComment(lang: lang, commentId: commentId);
    setIsReportLoading(false);

    //showSnackbar(Text(response['message']), context);
  }

  List<CommentsModel> get getComments => _comments;
  bool get getIsLoading => _isLoading;
  bool get getdeleteIsLoading => _isdeleteLoading;
  int get getPage => _page;
  bool get getMoreLoading => _getMoreLoading;
  bool get getIsReportLoading => _isReportLoading;
}
