import 'package:flutter/material.dart';
import 'package:home_workout_app/Api%20services/general_challenges_api.dart';
import 'package:home_workout_app/models/challenge_model.dart';

class SpeceficChallengeViewModel with ChangeNotifier {
  ChallengeModel challenge = ChallengeModel();
  List<ChallengeModel> challengesList = [];
  int challengeCount = 0;
  int FinalCount = 0;
  int proximityCount = 0;
  bool previousProximityState = false;
  // int page = 1;
  bool isLoading = true;
  setfuturechallenge(List<ChallengeModel>? futurechallengesList) {
    // challengesList = futurechallengesList;
    challengesList.addAll(futurechallengesList!);
    challenge = futurechallengesList[0];
    isLoading = false;
    print(challenge.img);
    challengeCount = (challenge.total_count! - challenge.my_count!);
    FinalCount = challengeCount;
    notifyListeners();
  }

  setProximityVal(bool currentState) {
    if (currentState != previousProximityState) {
      if (challengeCount - proximityCount >= 0) proximityCount++;
      setFinalCount(proximityCount);
    }
    notifyListeners();
  }

  // increasePages() {
  //   page++;
  //   notifyListeners();
  // }

  setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  reset() {
    challenge = ChallengeModel();
    // page = 1;
    isLoading = true;
    challengeCount = 0;
    FinalCount = 0;
    proximityCount = 0;
    previousProximityState = false;
    notifyListeners();
  }

  setFinalCount(int Val) {
    if (challengeCount - Val >= 0) FinalCount = challengeCount - Val;
    notifyListeners();
  }

  decreaseFinalCount() {
    if (FinalCount > 0) {
      FinalCount--;
    }
    notifyListeners();
  }

  getData(String lang, int page, String linkType) async {
    isLoading = true;
    setfuturechallenge(
        await GeneralChallengesAPI().getUserchallenges(lang, page, linkType));
    isLoading = false;
    notifyListeners();
    // return futurechallengesList;
  }

  sendParticipate(String lang, int? id) async {
    return await GeneralChallengesAPI().participate(lang, id);
    notifyListeners();
  }

  // getSpecificChallengeData(String lang, int? page, String linkType) async {
  //   await GeneralChallengesAPI().getUserchallenges(lang, page, linkType);
  //   notifyListeners();
  // }

  deleteSpecificChallengeData(String lang, int? id) async {
    return await GeneralChallengesAPI().deleteChallenge(lang, id);
    notifyListeners();
  }

  saveSpecificChallengeData(int countVal, String lang, int id) async {
    return await GeneralChallengesAPI().saveSpecificChallengeData(
        ChallengeModel(
          count: countVal,
        ),
        id,
        lang);
    notifyListeners();
  }

  ChallengeModel get getchallenge => challenge;
  bool get getisLoading => isLoading;
  List<ChallengeModel>? get getchallengesList => challengesList;
}
