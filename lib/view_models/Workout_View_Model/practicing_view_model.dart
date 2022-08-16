// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/Api%20services/workout2_api.dart';

class PracticingViewModel with ChangeNotifier {
  int _currentExercise = 0;
  int _practiceId = 0;
  bool _isLoading = false;
  int _timer = 0;
  bool _isPlaying = false;
  bool _isBreak1 = false;
  bool _isBreak2 = false;
  bool _isSkipped = false;

  int _breakSec = 0;
  int _breakLimit = 15;
  int _totalSec = 0;
  List<int> _finishedIds = [];

  void addToFinishedIDs(int i) {
    if (!_finishedIds.contains(i)) _finishedIds.add(i);
    log(_finishedIds.toString());
    notifyListeners();
  }

  void addToTotlaSec(int i) {
    _breakSec = 0;
    _totalSec += i;
    log('Total Seconds: $_totalSec');
    notifyListeners();
  }

  void addToTotlaSecFromBreak(int i) {
    _totalSec += i;
    log('Total Seconds: $_totalSec');
    notifyListeners();
  }

  void increaseBreakLimit() {
    if (_breakLimit + 10 == 55)
      _breakLimit += 5;
    else if (_breakLimit + 10 < 60) _breakLimit += 10;
    log(_breakLimit.toString());
    notifyListeners();
  }

  void setIs1Break(value) {
    _isBreak1 = value;
    notifyListeners();
  }

  void setIsSKipped(value) {
    _isSkipped = value;
    notifyListeners();
  }

  void setIs2Break(value) {
    _isBreak1 = value;
    notifyListeners();
  }

  void setBreakSec(int i) {
    _breakSec += 1;
    notifyListeners();
  }

  void resetBreakSec() {
    _breakSec = 0;
    notifyListeners();
  }

  void setIsPlaying(value) {
    _isPlaying = value;
    notifyListeners();
  }

  void reset() {
    log('Resetting');
    _currentExercise = 0;
    _practiceId = 0;
    _isLoading = false;
    _timer = 0;
    _isPlaying = false;
    _isBreak1 = false;
    _isBreak2 = false;

    _breakSec = 0;
    _breakLimit = 15;
    _totalSec = 0;
    _finishedIds = [];
    notifyListeners();
  }

  void setTimer(int i) {
    _timer = i;
    notifyListeners();
  }

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> startPractice({required String lang, required int id}) async {
    setIsLoading(true);
    _practiceId = await Workout2Api().startPractice(lang: lang, id: id);
    setIsLoading(false);
    log(_practiceId.toString());
    notifyListeners();
  }

  void setCurrentExerciseIndex(int i) {
    log(i.toString());
    _currentExercise = i;
    notifyListeners();
  }

  int get getCurrentExerciseIndex => _currentExercise;
  bool get getIsLoading => _isLoading;
  int get getTimer => _timer;
  bool get getIsPlaying => _isPlaying;
  bool get getIsBreak1 => _isBreak1;
  bool get getIsBreak2 => _isBreak2;
  bool get getIsSkipped => _isSkipped;

  int get getBreakSec => _breakSec;
  int get getBreakLimit => _breakLimit;
  int get getTotalSeconds => _totalSec;
  List<int> get getFinishedIds => _finishedIds;
}
