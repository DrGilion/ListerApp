// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lister_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListerTag _$ListerTagFromJson(Map<String, dynamic> json) => ListerTag(
      json['id'] as int?,
      json['name'] as String,
      json['color'] as int,
    );

Map<String, dynamic> _$ListerTagToJson(ListerTag instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['name'] = instance.name;
  val['color'] = instance.color;
  return val;
}
