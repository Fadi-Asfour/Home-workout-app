import 'package:flutter/material.dart';
import 'package:home_workout_app/Api%20services/general_challenges_api.dart';
import 'package:home_workout_app/models/challenge_model.dart';

class GeneralChallengesViewModel with ChangeNotifier {
  List<ChallengeModel>? challengesList = [];
  int page = 1;
  bool isLoading = false;
  setfuturechallengesList(List<ChallengeModel>? futurechallengesList) {
    // challengesList = futurechallengesList;
    challengesList?.addAll(futurechallengesList!);
    isLoading = false;
    print(challengesList);
    notifyListeners();
  }

  increasePages() {
    page++;
    notifyListeners();
  }

  setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  reset() {
    challengesList = [];
    page = 1;
    isLoading = false;
    notifyListeners();
  }

  getData(String lang, int page, String linkType) async {
    isLoading = true;
    setfuturechallengesList(
        await GeneralChallengesAPI().getUserchallenges(lang, page, linkType));
    increasePages();
    notifyListeners();
    // return futurechallengesList;
  }

  sendParticipate(String lang, int? id) async {
    return await GeneralChallengesAPI().participate(lang, id);
    notifyListeners();
  }

  getSpecificChallengeData(String lang, int? page, String linkType) {
    GeneralChallengesAPI().getUserchallenges(lang, page, linkType);
    notifyListeners();
  }

  deleteSpecificChallengeData(String lang, int? id) async {
    return await GeneralChallengesAPI().deleteChallenge(lang, id);
    notifyListeners();
  }

  List<ChallengeModel>? get getchallengesList => challengesList;
}
