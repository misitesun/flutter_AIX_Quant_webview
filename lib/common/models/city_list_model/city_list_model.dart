import 'child.dart';

class CityListModel {
  String? label;
  String? value;
  List<Child>? children;

  CityListModel({this.label, this.value, this.children});

  factory CityListModel.fromJson(Map<String, dynamic> json) => CityListModel(
        label: json['label'] as String?,
        value: json['value'] as String?,
        children: (json['children'] as List<dynamic>?)
            ?.map((e) => Child.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'label': label,
        'value': value,
        'children': children?.map((e) => e.toJson()).toList(),
      };
}
