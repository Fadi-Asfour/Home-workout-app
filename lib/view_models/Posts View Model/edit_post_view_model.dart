// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/Api%20services/post_api.dart';
import 'package:home_workout_app/components.dart';
import 'package:image_picker/image_picker.dart';

class EditPostViewModel with ChangeNotifier {
  List<XFile>? _pickedImages = [];
  List<XFile>? _pickedVideo = [];
  List<int> _deletedMedial = [];
  List<String> _choices = [];
  List<int> _deletedChoices = [];
  bool _isLoading = false;

  void resetPick() {
    _pickedImages!.clear();
    _pickedVideo!.clear();
    _deletedMedial.clear();
    _choices.clear();
    _deletedChoices = [];
    _isLoading = false;
    notifyListeners();
  }

  void addChoice(String value, BuildContext context, List oldChoices) {
    if (value.isEmpty) return;

    bool exists = false;

    oldChoices.forEach((element) {
      if (element['vote'] == value) exists = true;
    });

    if (_choices.contains(value)) {
      showSnackbar(
          const Text('You have already added this choice').tr(), context);
      return;
    } else if (exists) {
      showSnackbar(
          const Text('You have already added this choice').tr(), context);
      return;
    } else if (_choices.length + oldChoices.length == 10) {
      showSnackbar(
          const Text("You can't add more than 10 choices").tr(), context);
      return;
    } else {
      _choices.add(value);
      notifyListeners();
    }
  }

  void removeChoice(String value) {
    _choices.remove(value);
    notifyListeners();
  }

  void addToDeletedChoices(int id) {
    _deletedChoices.add(id);
    notifyListeners();
  }

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  void addToDeletedMedia(int i) {
    _deletedMedial.add(i);
    print(_deletedMedial);
    notifyListeners();
  }

  void removePhoto(String path) {
    _pickedImages!.removeWhere((element) => element.path == path);
    notifyListeners();
  }

  void removeVideo(String path) {
    _pickedVideo!.removeWhere((element) => element.path == path);
    notifyListeners();
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage(imageQuality: 25);
    if (pickedImages != null) {
      _pickedImages = pickedImages;
      notifyListeners();
    }
  }

  Future<void> pickVideos() async {
    final picker = ImagePicker();
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      _pickedVideo!.add(pickedVideo);
      notifyListeners();
    }
  }

  Future<void> updateNormalPost(
      {required String newtitle,
      required List<XFile> newimages,
      required List<XFile> newvideos,
      required int postId,
      required List<int> deletedMedia,
      required BuildContext context,
      required String lang}) async {
    if (newtitle.isEmpty) {
      showSnackbar(const Text('You have to add a text').tr(), context);
      return;
    }
    setIsLoading(true);
    final response = await PostAPI().updateNormalPost(
        newtitle: newtitle,
        newimages: newimages,
        newvideos: newvideos,
        postId: postId,
        lang: lang,
        deletedMedia: deletedMedia);
    if (response['success']) {
      showSnackbar(Text(response['message']), context);
      Navigator.pop(context);
    } else {
      showSnackbar(Text(response['message']), context);
    }
    setIsLoading(false);
    notifyListeners();
  }

  Future<void> updatePollPost(
      {required String newtitle,
      required int postId,
      required int postType,
      required BuildContext context,
      required String lang}) async {
    if (newtitle.isEmpty) {
      showSnackbar(const Text('You have to add a text').tr(), context);
      return;
    }
    setIsLoading(true);
    final response = await PostAPI().updatePollPost(
        postId: postId,
        type: postType,
        newtitle: newtitle,
        newchoices: getChoices,
        lang: lang,
        deletedChoices: getDeletedChoices);
    if (response['success']) {
      showSnackbar(Text(response['message']), context);
      Navigator.pop(context);
    } else {
      showSnackbar(Text(response['message']), context);
    }
    setIsLoading(false);
    notifyListeners();
  }

  List<XFile>? get getPickedImages => _pickedImages;
  List<XFile>? get getPickedVideo => _pickedVideo;
  List<String> get getChoices => _choices;
  List<int> get getDeletedChoices => _deletedChoices;
  List<int> get getDeletedMedia => _deletedMedial;
  bool get getIsLoading => _isLoading;
}
