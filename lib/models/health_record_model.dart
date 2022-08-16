class HealthRecordModel {
  int id = 0;
  String desc = '';
  List diseases = [];

  HealthRecordModel();

  HealthRecordModel.fromJson(Map json) {
    id = json['data']['record']['record_id'] ?? 0;
    desc = json['data']['record']['record_desc'] ?? '';
    print('ssss ${json['data']['record']['record_desc']}');
    diseases = json['data']['dis'] ?? [];
  }
}
