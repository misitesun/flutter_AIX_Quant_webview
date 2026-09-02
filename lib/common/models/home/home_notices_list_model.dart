import 'package:XSmartPay/common/index.dart';

class HomeNoticesListModel {
  int? id;
  String? title;
  String? content;
  String? originContent;
  String? updatedAt;
  String? updatedDate;

  HomeNoticesListModel({
    this.id,
    this.title,
    this.content,
    this.originContent,
    this.updatedAt,
    this.updatedDate,
  });

  factory HomeNoticesListModel.fromJson(Map<String, dynamic> json) {
    return HomeNoticesListModel(
      id: DataUtils.toInt(json['id']),
      title: DataUtils.toStr(json['title']),
      content: DataUtils.toStr(json['content']),
      originContent: DataUtils.toStr(json['origin_content']),
      updatedAt: DataUtils.toStr(json['updated_at']),
      updatedDate: DataUtils.toStr(json['updated_date']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'origin_content': originContent,
        'updated_at': updatedAt,
        'updated_date': updatedDate,
      };
}
