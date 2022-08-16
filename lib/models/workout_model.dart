class WorkoutModel {
  late int id;
  late String name;
  late String categorie;
  late int excersises;
  late int excpectedTime;
  late String imageUrl;
  late String publisherName;
  WorkoutModel(this.id, this.name, this.categorie, this.excersises,
      this.excpectedTime, this.imageUrl, this.publisherName);

  WorkoutModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['data']['name'] ?? '';
    categorie = json['data']['categorie'] ?? '';
    excersises = json['data']['excersises'] ?? 0;
    excpectedTime = json['data']['excpectedTime'] ?? 0;
    imageUrl = json['data']['imageUrl'];
    publisherName = json['data']['publisher'];
  }
}
