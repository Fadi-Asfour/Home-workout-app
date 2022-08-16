class AppFeuturesModel {
  String name = '';
  int id = 0;
  int isActive = 0;

  AppFeuturesModel();

  AppFeuturesModel.fromJson(Map json) {
    name = json['name'] ?? '';
    id = json['id'] ?? 0;
    isActive = json['is_active'] ?? 0;
  }
}
