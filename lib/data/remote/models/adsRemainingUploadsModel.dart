class AdsRemainingUploadsModel {
  bool success;
  int remainingUploads;

  AdsRemainingUploadsModel({this.success, this.remainingUploads});

  AdsRemainingUploadsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    remainingUploads = json['remaining_uploads'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['remaining_uploads'] = this.remainingUploads;
    return data;
  }
}