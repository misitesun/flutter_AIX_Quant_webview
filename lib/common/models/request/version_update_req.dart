class VersionUpdateReq {
  String? version;
  String? device;

  VersionUpdateReq({this.version, this.device});

  factory VersionUpdateReq.fromJson(Map<String, dynamic> json) {
    return VersionUpdateReq(
      version: json['version'] as String?,
      device: json['device'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'version': version,
        'device': device,
      };
}
