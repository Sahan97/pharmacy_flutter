class CommonResponse {
  bool success;
  dynamic data;
  String title;
  String subtitle;
  CommonResponse(json) {
    success = json['success'];
    data = json['data'];
    title = json['title'];
    subtitle = json['subtitle'];
  }
}
