// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lister_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListerItem _$ListerItemFromJson(Map<String, dynamic> json) => ListerItem(
      json['id'] as int?,
      json['list_id'] as int,
      json['name'] as String,
      json['description'] as String? ?? '',
      json['rating'] as int,
      Utils.intToBool(json['experienced'] as int),
      Utils.dateFromMillis(json['created_on'] as int?),
      Utils.dateFromMillis(json['modified_on'] as int?),
    );

Map<String, dynamic> _$ListerItemToJson(ListerItem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['list_id'] = instance.listId;
  val['name'] = instance.name;
  val['description'] = instance.description;
  val['rating'] = instance.rating;
  val['experienced'] = Utils.boolToInt(instance.experienced);
  val['created_on'] = Utils.dateToMillis(instance.createdOn);
  val['modified_on'] = Utils.dateToMillis(instance.modifiedOn);
  return val;
}
