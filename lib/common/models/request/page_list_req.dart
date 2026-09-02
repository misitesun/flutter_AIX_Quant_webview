import 'package:XSmartPay/common/index.dart';

class PageListReq {
  int? pageNo;
  int? pageSize;

  PageListReq({this.pageNo, this.pageSize});

  factory PageListReq.fromJson(Map<String, dynamic> json) {
    return PageListReq(
      pageNo: DataUtils.toInt(json['page_no']),
      pageSize: DataUtils.toInt(json['page_size']),
    );
  }

  Map<String, dynamic> toJson() => {
        'page_no': pageNo,
        'page_size': pageSize,
      };
}
