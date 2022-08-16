class SummaryModel {
  String bmi = '';
  int workouts = 0;
  int calories = 0;
  double weight = 0;
  String dietName = '';
  int dietId = 0;

  SummaryModel();
  SummaryModel.fromJson(Map json) {
    print(json);
    bmi = json['BMI'] ?? '';
    workouts = json['Workouts Played'] ?? 0;
    calories = json['Calories Burnt'] ?? 0;
    weight = double.tryParse(json['Weight'].toString()) ?? 0;
    dietName = json['Current Diet']['name'] ?? '';
    dietId = json['Current Diet']['id'] ?? 0;
  }
}
