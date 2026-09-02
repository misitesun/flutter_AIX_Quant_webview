/// 错误体信息
class ErrorMessageModel {
  int? statusCode;
  String? message;

  ErrorMessageModel({
    this.statusCode,
    this.message,
  });

  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) {
    return ErrorMessageModel(
      statusCode: json['status_code'] as int?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'status_code': statusCode,
        'message': message,
      };
}
