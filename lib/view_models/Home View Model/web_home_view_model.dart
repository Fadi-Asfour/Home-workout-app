// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/models/workout_model.dart';
import 'package:home_workout_app/view_models/profile_view_model.dart';
import 'package:home_workout_app/views/Home%20View/Mobile/Pages/posts_page.dart';
import 'package:home_workout_app/views/Home%20View/Mobile/Pages/profile_page.dart';
import 'package:home_workout_app/views/Home%20View/Web/Pages/web_home_page.dart';
import 'package:home_workout_app/views/Home%20View/Web/Pages/web_posts_page.dart';
import 'package:home_workout_app/views/Home%20View/Web/Pages/web_profile_page.dart';
import 'package:provider/provider.dart';

class WebHomeViewModel with ChangeNotifier {
  String selectedPage = 'Home';
  double _homeScale = 1;
  double _profileScale = 1;
  double _postsScale = 1;
  double _logoScale = 1;

  void setScale(page, scaleStatus) {
    switch (page) {
      case 'Home':
        if (scaleStatus)
          _homeScale = 1.2;
        else
          _homeScale = 1;
        break;
      case 'Posts':
        if (scaleStatus)
          _postsScale = 1.2;
        else
          _postsScale = 1;
        break;
      case 'Profile':
        if (scaleStatus)
          _profileScale = 1.2;
        else
          _profileScale = 1;
        break;
      case 'Logo':
        if (scaleStatus)
          _logoScale = 1.2;
        else
          _logoScale = 1;
        break;
      default:
    }
    notifyListeners();
  }

  String selectedCategorie = 'Recommended';
  //temporary
  Map<String, bool> categories = {
    'Recommended': true,
    'All': false,
    'Arm': false,
    'Chest': false,
    'Back': false,
    'Leg': false,
  };

  Map<String, dynamic> pages = {
    'Home': WebHomePage(),
    'Posts': WebPostsPage(),
    'Profile': ProfilePage()
  };

  changeSelectedPage(String page) {
    selectedPage = page;
    notifyListeners();
  }

  Widget getPage() {
    return pages[selectedPage];
  }

  changeSelectedCategorie(String categorie) {
    selectedCategorie = categorie;
    notifyListeners();
  } //temporary

  List<Map<dynamic, dynamic>> workouts = [
    {
      'id': 1,
      'data': {
        'name': 'Arm',
        'categorie': 'Arm',
        'excersises': 7,
        'publisher': 'Ahmad',
        'excpectedTime': 50,
        'imageUrl':
            'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/full-body-workout-1563458040.jpg'
      },
    },
    {
      'id': 5,
      'data': {
        'name': 'Arm',
        'categorie': 'Arm',
        'excersises': 7,
        'publisher': 'Ahmad',
        'excpectedTime': 50,
        'imageUrl':
            'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/full-body-workout-1563458040.jpg'
      },
    },
    {
      'id': 2,
      'data': {
        'name': 'Arm',
        'categorie': 'Leg',
        'excersises': 7,
        'excpectedTime': 50,
        'publisher': 'Ahmad',
        'imageUrl':
            'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/full-body-workout-1563458040.jpg'
      }
    },
    {
      'id': 3,
      'data': {
        'name': 'Arm',
        'categorie': 'All',
        'excersises': 7,
        'excpectedTime': 50,
        'publisher': 'Ahmad',
        'imageUrl':
            'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/full-body-workout-1563458040.jpg'
      }
    },
    {
      'id': 4,
      'data': {
        'name': 'Arm',
        'categorie': 'Recommended',
        'excersises': 7,
        'excpectedTime': 50,
        'publisher': 'Ahmad',
        'imageUrl':
            'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/full-body-workout-1563458040.jpg'
      }
    },
    {
      'id': 4,
      'data': {
        'name': 'Arm',
        'categorie': 'Recommended',
        'excersises': 7,
        'excpectedTime': 50,
        'publisher': 'Ahmad',
        'imageUrl':
            'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/full-body-workout-1563458040.jpg'
      }
    },
    {
      'id': 4,
      'data': {
        'name': 'Arm',
        'categorie': 'Recommended',
        'excersises': 7,
        'excpectedTime': 50,
        'publisher': 'Ahmad',
        'imageUrl':
            'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/full-body-workout-1563458040.jpg'
      }
    }
  ];

  List<WorkoutModel> getWorkouts() {
    List<WorkoutModel> workoutsList = [];
    for (int i = 0; i < workouts.length; i++) {
      workoutsList.add(WorkoutModel.fromJson(workouts[i]));
    }
    return workoutsList;
  }

  double get getHomeScale => _homeScale;
  double get getPostsScale => _postsScale;
  double get getProfileScale => _profileScale;
  double get getLogoScale => _logoScale;
}
