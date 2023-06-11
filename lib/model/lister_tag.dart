import 'package:json_annotation/json_annotation.dart';

part 'lister_tag.g.dart';

@JsonSerializable()
class ListerTag {
  static const String tableName = "core_tag";

  @JsonKey(includeIfNull: false)
  int? id;
  String name;
  int color;

  ListerTag(this.id, this.name, this.color);

  factory ListerTag.fromJson(Map<String, dynamic> json) => _$ListerTagFromJson(json);

  Map<String, dynamic> toJson() => _$ListerTagToJson(this);
}
