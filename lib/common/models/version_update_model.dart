import 'package:XSmartPay/common/index.dart';

class VersionUpdateModel {
  int? id;
  dynamic createdAt;
  String? updatedAt;
  String? describe;
  dynamic editionUrl;
  String? editionForce;
  String? packageType;
  dynamic editionIssue;
  int? editionNumber;
  String? editionName;
  dynamic editionSilence;
  String? iosEditionUrl;
  dynamic akpUrl;
  dynamic appUrl;
  dynamic hotUpdate;
  dynamic downloadUrl;

  VersionUpdateModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.describe,
    this.editionUrl,
    this.editionForce,
    this.packageType,
    this.editionIssue,
    this.editionNumber,
    this.editionName,
    this.editionSilence,
    this.iosEditionUrl,
    this.akpUrl,
    this.appUrl,
    this.hotUpdate,
    this.downloadUrl,
  });

  factory VersionUpdateModel.fromJson(Map<String, dynamic> json) => VersionUpdateModel(
        id: DataUtils.toInt(json['id']),
        createdAt: DataUtils.toStr(json['created_at']),
        updatedAt: DataUtils.toStr(json['updated_at']),
        describe: DataUtils.toStr(json['describe']),
        editionUrl: DataUtils.toStr(json['edition_url']),
        editionForce: DataUtils.toStr(json['edition_force']),
        packageType: DataUtils.toStr(json['package_type']),
        editionIssue: DataUtils.toStr(json['edition_issue']),
        editionNumber: DataUtils.toInt(json['edition_number']),
        editionName: DataUtils.toStr(json['edition_name']),
        editionSilence: DataUtils.toStr(json['edition_silence']),
        iosEditionUrl: DataUtils.toStr(json['ios_edition_url']),
        akpUrl: DataUtils.toStr(json['akp_url']),
        appUrl: DataUtils.toStr(json['app_url']),
        hotUpdate: DataUtils.toStr(json['hot_update']),
        downloadUrl: DataUtils.toStr(json['download_url']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'describe': describe,
        'edition_url': editionUrl,
        'edition_force': editionForce,
        'package_type': packageType,
        'edition_issue': editionIssue,
        'edition_number': editionNumber,
        'edition_name': editionName,
        'edition_silence': editionSilence,
        'ios_edition_url': iosEditionUrl,
        'akp_url': akpUrl,
        'app_url': appUrl,
        'hot_update': hotUpdate,
        'download_url': downloadUrl,
      };
}
