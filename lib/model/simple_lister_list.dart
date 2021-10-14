import 'package:json_annotation/json_annotation.dart';

part 'simple_lister_list.g.dart';

@JsonSerializable()
class SimpleListerList {
  static const String tableName = "core_list";

  @JsonKey(includeIfNull: false)
  int? id;
  String name;

  SimpleListerList(this.id, this.name);

  factory SimpleListerList.fromJson(Map<String, dynamic> json) => _$SimpleListerListFromJson(json);

  Map<String, dynamic> toJson() => _$SimpleListerListToJson(this);
}