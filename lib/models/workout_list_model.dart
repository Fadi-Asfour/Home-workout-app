class WorkoutListModel {
  int? id;
  String? name;
  String? equipment;
  int? user_id;
  int? predicted_burnt_calories;
  String? message;
  int? excersise_count;
  int? difficulty;
  int? length;
  int? statusCode;
  String? subs;
  String? workout_image_url;
  String? prof_img_url;
  String? created_at;
  String? description;
  bool? saved;
  String? categorie_name;
  bool? reviewd;

  String? f_name;
  String? l_name;
  double? rating;

  // bool? save;
  WorkoutListModel(
      {this.id,
      this.name,
      this.message,
      this.equipment,
      this.user_id,
      this.statusCode,
      this.predicted_burnt_calories,
      this.difficulty,
      this.length,
      this.subs,
      this.workout_image_url,
      this.excersise_count,
      this.f_name,
      this.prof_img_url,
      this.created_at,
      this.description,
      this.saved,
      this.l_name,
      this.categorie_name,
      this.reviewd,
      this.rating});
  // to convert data from json to dart object
  factory WorkoutListModel.fromJson(Map<String, dynamic> user) =>
      WorkoutListModel(
          // message: user['message'] ?? '',
          // statusCode: user['status'] ?? 0,
          id: user['id'] ?? 0,
          name: user['name'] ?? '',
          equipment: user['equipment'] ?? '',
          f_name: user['user']['f_name'] ?? '',
          l_name: user['user']['l_name'] ?? '',
          prof_img_url: user['user']['prof_img_url'] ?? '',
          user_id: user['user']['id'] ?? '',
          predicted_burnt_calories: user['predicted_burnt_calories'] ?? 0,
          excersise_count: user['excersise_count'] ?? 0,
          difficulty: user['difficulty'] ?? 0,
          length: user['length'] ?? 0,
          workout_image_url: user['workout_image_url'] ?? '',
          saved: user['saved'] ?? false,
          created_at: user['created_at'] ?? '',
          description: user['description'] ?? '',
          categorie_name: user['categorie_name']['name'],
          reviewd: user['is_reviewed'] ?? false,
          rating: double.tryParse(user['review_count'].toString()) ?? 0);

  // factory WorkoutListModel.fromJsonForParticipate(Map<String, dynamic> user) =>
  //     WorkoutListModel(
  //       message: user['message'] ?? '',
  //       statusCode: user['status'] ?? 0,
  //       is_sub: user['is_sub'] ?? false,
  //       subs: user['subs'] ?? '',
  //     );
  factory WorkoutListModel.fromCategoriesJson(Map<String, dynamic> user) =>
      WorkoutListModel(
        // message: user['message'] ?? '',
        // statusCode: user['status'] ?? 0,
        id: user['id'] ?? 0,
        name: user['name'] ?? '',
        // img: user['img'] ?? '',
        //  ca: user['ca'] ?? '',
      );
  factory WorkoutListModel.fromJsonWithErrors(Map<String, dynamic> user) =>
      WorkoutListModel(
          message: user['message'], statusCode: user['status'] ?? 0);
  //to convert data to json
  // Map<String, dynamic> toJson() => {
  //       'email': email,
  //       'password': password,
  //       'c_name': c_name,
  //       'mac': 'mac',
  //       'm_token': m_token
  //     };
}
