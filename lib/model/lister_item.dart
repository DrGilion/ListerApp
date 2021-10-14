import 'package:json_annotation/json_annotation.dart';
import 'package:lister_app/utils.dart';

part 'lister_item.g.dart';

@JsonSerializable()
class ListerItem{
  static const String tableName = "core_list_item";

  @JsonKey(includeIfNull: false)
  int? id;
  @JsonKey(name: 'list_id')
  int listId;
  String name;
  @JsonKey(defaultValue: '')
  String description;
  int rating;
  @JsonKey(fromJson: Utils.intToBool, toJson: Utils.boolToInt)
  bool experienced;
  @JsonKey(name: 'created_on', fromJson: Utils.dateFromMillis, toJson: Utils.dateToMillis)
  DateTime createdOn;
  @JsonKey(name: 'modified_on', fromJson: Utils.dateFromMillis, toJson: Utils.dateToMillis)
  DateTime modifiedOn;

  ListerItem(this.id, this.listId, this.name, this.description, this.rating, this.experienced, this.createdOn,
      this.modifiedOn);

  factory ListerItem.fromJson(Map<String, dynamic> json) => _$ListerItemFromJson(json);

  Map<String, dynamic> toJson() => _$ListerItemToJson(this);

}