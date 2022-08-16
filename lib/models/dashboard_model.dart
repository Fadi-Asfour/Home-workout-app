// ignore_for_file: non_constant_identifier_names

class DashboardModel {
  String posts = '0';
  String CVs = '0';
  String reportedPosts = '0';
  String reportedComments = '0';

  DashboardModel();
  DashboardModel.fromJson(Map json) {
    posts = json['data']['posts'] ?? '0';
    CVs = json['data']['CVs'] ?? '0';
    reportedComments = json['data']['Reported_Comments'] ?? '0';
    reportedPosts = json['data']['Reported_Posts'] ?? '0';
  }
}
