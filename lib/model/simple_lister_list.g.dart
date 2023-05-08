// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_lister_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimpleListerList _$SimpleListerListFromJson(Map<String, dynamic> json) =>
    SimpleListerList(
      json['id'] as int?,
      json['name'] as String,
      json['color'] as int,
    );

Map<String, dynamic> _$SimpleListerListToJson(SimpleListerList instance) {
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
