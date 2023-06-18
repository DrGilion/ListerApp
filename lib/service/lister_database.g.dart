// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lister_database.dart';

// ignore_for_file: type=lint
class $ListerListTableTable extends ListerListTable
    with TableInfo<$ListerListTableTable, ListerList> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListerListTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumnWithTypeConverter<Color, int> color =
      GeneratedColumn<int>('color', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<Color>($ListerListTableTable.$convertercolor);
  @override
  List<GeneratedColumn> get $columns => [id, name, color];
  @override
  String get aliasedName => _alias ?? 'lister_list_table';
  @override
  String get actualTableName => 'lister_list_table';
  @override
  VerificationContext validateIntegrity(Insertable<ListerList> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    context.handle(_colorMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ListerList map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListerList(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      color: $ListerListTableTable.$convertercolor.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!),
    );
  }

  @override
  $ListerListTableTable createAlias(String alias) {
    return $ListerListTableTable(attachedDatabase, alias);
  }

  static TypeConverter<Color, int> $convertercolor = const ColorConverter();
}

class ListerList extends DataClass implements Insertable<ListerList> {
  final int id;
  final String name;
  final Color color;
  const ListerList({required this.id, required this.name, required this.color});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      final converter = $ListerListTableTable.$convertercolor;
      map['color'] = Variable<int>(converter.toSql(color));
    }
    return map;
  }

  ListerListTableCompanion toCompanion(bool nullToAbsent) {
    return ListerListTableCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
    );
  }

  factory ListerList.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListerList(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<Color>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<Color>(color),
    };
  }

  ListerList copyWith({int? id, String? name, Color? color}) => ListerList(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
      );
  @override
  String toString() {
    return (StringBuffer('ListerList(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListerList &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color);
}

class ListerListTableCompanion extends UpdateCompanion<ListerList> {
  final Value<int> id;
  final Value<String> name;
  final Value<Color> color;
  const ListerListTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
  });
  ListerListTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required Color color,
  })  : name = Value(name),
        color = Value(color);
  static Insertable<ListerList> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
    });
  }

  ListerListTableCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<Color>? color}) {
    return ListerListTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      final converter = $ListerListTableTable.$convertercolor;
      map['color'] = Variable<int>(converter.toSql(color.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListerListTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $ListerItemTableTable extends ListerItemTable
    with TableInfo<$ListerItemTableTable, ListerItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListerItemTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<int> listId = GeneratedColumn<int>(
      'list_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES lister_list_table (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
      'rating', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _experiencedMeta =
      const VerificationMeta('experienced');
  @override
  late final GeneratedColumn<bool> experienced =
      GeneratedColumn<bool>('experienced', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("experienced" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _createdOnMeta =
      const VerificationMeta('createdOn');
  @override
  late final GeneratedColumn<DateTime> createdOn = GeneratedColumn<DateTime>(
      'created_on', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _modifiedOnMeta =
      const VerificationMeta('modifiedOn');
  @override
  late final GeneratedColumn<DateTime> modifiedOn = GeneratedColumn<DateTime>(
      'modified_on', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        listId,
        name,
        description,
        rating,
        experienced,
        createdOn,
        modifiedOn
      ];
  @override
  String get aliasedName => _alias ?? 'lister_item_table';
  @override
  String get actualTableName => 'lister_item_table';
  @override
  VerificationContext validateIntegrity(Insertable<ListerItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('list_id')) {
      context.handle(_listIdMeta,
          listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta));
    } else if (isInserting) {
      context.missing(_listIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('rating')) {
      context.handle(_ratingMeta,
          rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta));
    }
    if (data.containsKey('experienced')) {
      context.handle(
          _experiencedMeta,
          experienced.isAcceptableOrUnknown(
              data['experienced']!, _experiencedMeta));
    }
    if (data.containsKey('created_on')) {
      context.handle(_createdOnMeta,
          createdOn.isAcceptableOrUnknown(data['created_on']!, _createdOnMeta));
    } else if (isInserting) {
      context.missing(_createdOnMeta);
    }
    if (data.containsKey('modified_on')) {
      context.handle(
          _modifiedOnMeta,
          modifiedOn.isAcceptableOrUnknown(
              data['modified_on']!, _modifiedOnMeta));
    } else if (isInserting) {
      context.missing(_modifiedOnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ListerItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListerItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      listId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}list_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      rating: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rating'])!,
      experienced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}experienced'])!,
      createdOn: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_on'])!,
      modifiedOn: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}modified_on'])!,
    );
  }

  @override
  $ListerItemTableTable createAlias(String alias) {
    return $ListerItemTableTable(attachedDatabase, alias);
  }
}

class ListerItem extends DataClass implements Insertable<ListerItem> {
  final int id;
  final int listId;
  final String name;
  final String description;
  final int rating;
  final bool experienced;
  final DateTime createdOn;
  final DateTime modifiedOn;
  const ListerItem(
      {required this.id,
      required this.listId,
      required this.name,
      required this.description,
      required this.rating,
      required this.experienced,
      required this.createdOn,
      required this.modifiedOn});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['list_id'] = Variable<int>(listId);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['rating'] = Variable<int>(rating);
    map['experienced'] = Variable<bool>(experienced);
    map['created_on'] = Variable<DateTime>(createdOn);
    map['modified_on'] = Variable<DateTime>(modifiedOn);
    return map;
  }

  ListerItemTableCompanion toCompanion(bool nullToAbsent) {
    return ListerItemTableCompanion(
      id: Value(id),
      listId: Value(listId),
      name: Value(name),
      description: Value(description),
      rating: Value(rating),
      experienced: Value(experienced),
      createdOn: Value(createdOn),
      modifiedOn: Value(modifiedOn),
    );
  }

  factory ListerItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListerItem(
      id: serializer.fromJson<int>(json['id']),
      listId: serializer.fromJson<int>(json['listId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      rating: serializer.fromJson<int>(json['rating']),
      experienced: serializer.fromJson<bool>(json['experienced']),
      createdOn: serializer.fromJson<DateTime>(json['createdOn']),
      modifiedOn: serializer.fromJson<DateTime>(json['modifiedOn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'listId': serializer.toJson<int>(listId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'rating': serializer.toJson<int>(rating),
      'experienced': serializer.toJson<bool>(experienced),
      'createdOn': serializer.toJson<DateTime>(createdOn),
      'modifiedOn': serializer.toJson<DateTime>(modifiedOn),
    };
  }

  ListerItem copyWith(
          {int? id,
          int? listId,
          String? name,
          String? description,
          int? rating,
          bool? experienced,
          DateTime? createdOn,
          DateTime? modifiedOn}) =>
      ListerItem(
        id: id ?? this.id,
        listId: listId ?? this.listId,
        name: name ?? this.name,
        description: description ?? this.description,
        rating: rating ?? this.rating,
        experienced: experienced ?? this.experienced,
        createdOn: createdOn ?? this.createdOn,
        modifiedOn: modifiedOn ?? this.modifiedOn,
      );
  @override
  String toString() {
    return (StringBuffer('ListerItem(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('rating: $rating, ')
          ..write('experienced: $experienced, ')
          ..write('createdOn: $createdOn, ')
          ..write('modifiedOn: $modifiedOn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, listId, name, description, rating,
      experienced, createdOn, modifiedOn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListerItem &&
          other.id == this.id &&
          other.listId == this.listId &&
          other.name == this.name &&
          other.description == this.description &&
          other.rating == this.rating &&
          other.experienced == this.experienced &&
          other.createdOn == this.createdOn &&
          other.modifiedOn == this.modifiedOn);
}

class ListerItemTableCompanion extends UpdateCompanion<ListerItem> {
  final Value<int> id;
  final Value<int> listId;
  final Value<String> name;
  final Value<String> description;
  final Value<int> rating;
  final Value<bool> experienced;
  final Value<DateTime> createdOn;
  final Value<DateTime> modifiedOn;
  const ListerItemTableCompanion({
    this.id = const Value.absent(),
    this.listId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.rating = const Value.absent(),
    this.experienced = const Value.absent(),
    this.createdOn = const Value.absent(),
    this.modifiedOn = const Value.absent(),
  });
  ListerItemTableCompanion.insert({
    this.id = const Value.absent(),
    required int listId,
    required String name,
    this.description = const Value.absent(),
    this.rating = const Value.absent(),
    this.experienced = const Value.absent(),
    required DateTime createdOn,
    required DateTime modifiedOn,
  })  : listId = Value(listId),
        name = Value(name),
        createdOn = Value(createdOn),
        modifiedOn = Value(modifiedOn);
  static Insertable<ListerItem> custom({
    Expression<int>? id,
    Expression<int>? listId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? rating,
    Expression<bool>? experienced,
    Expression<DateTime>? createdOn,
    Expression<DateTime>? modifiedOn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (listId != null) 'list_id': listId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (rating != null) 'rating': rating,
      if (experienced != null) 'experienced': experienced,
      if (createdOn != null) 'created_on': createdOn,
      if (modifiedOn != null) 'modified_on': modifiedOn,
    });
  }

  ListerItemTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? listId,
      Value<String>? name,
      Value<String>? description,
      Value<int>? rating,
      Value<bool>? experienced,
      Value<DateTime>? createdOn,
      Value<DateTime>? modifiedOn}) {
    return ListerItemTableCompanion(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      name: name ?? this.name,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      experienced: experienced ?? this.experienced,
      createdOn: createdOn ?? this.createdOn,
      modifiedOn: modifiedOn ?? this.modifiedOn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<int>(listId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (experienced.present) {
      map['experienced'] = Variable<bool>(experienced.value);
    }
    if (createdOn.present) {
      map['created_on'] = Variable<DateTime>(createdOn.value);
    }
    if (modifiedOn.present) {
      map['modified_on'] = Variable<DateTime>(modifiedOn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListerItemTableCompanion(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('rating: $rating, ')
          ..write('experienced: $experienced, ')
          ..write('createdOn: $createdOn, ')
          ..write('modifiedOn: $modifiedOn')
          ..write(')'))
        .toString();
  }
}

class $ListerTagTableTable extends ListerTagTable
    with TableInfo<$ListerTagTableTable, ListerTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListerTagTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumnWithTypeConverter<Color, int> color =
      GeneratedColumn<int>('color', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<Color>($ListerTagTableTable.$convertercolor);
  @override
  List<GeneratedColumn> get $columns => [id, name, color];
  @override
  String get aliasedName => _alias ?? 'lister_tag_table';
  @override
  String get actualTableName => 'lister_tag_table';
  @override
  VerificationContext validateIntegrity(Insertable<ListerTag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    context.handle(_colorMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ListerTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListerTag(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      color: $ListerTagTableTable.$convertercolor.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!),
    );
  }

  @override
  $ListerTagTableTable createAlias(String alias) {
    return $ListerTagTableTable(attachedDatabase, alias);
  }

  static TypeConverter<Color, int> $convertercolor = const ColorConverter();
}

class ListerTag extends DataClass implements Insertable<ListerTag> {
  final int id;
  final String name;
  final Color color;
  const ListerTag({required this.id, required this.name, required this.color});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      final converter = $ListerTagTableTable.$convertercolor;
      map['color'] = Variable<int>(converter.toSql(color));
    }
    return map;
  }

  ListerTagTableCompanion toCompanion(bool nullToAbsent) {
    return ListerTagTableCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
    );
  }

  factory ListerTag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListerTag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<Color>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<Color>(color),
    };
  }

  ListerTag copyWith({int? id, String? name, Color? color}) => ListerTag(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
      );
  @override
  String toString() {
    return (StringBuffer('ListerTag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListerTag &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color);
}

class ListerTagTableCompanion extends UpdateCompanion<ListerTag> {
  final Value<int> id;
  final Value<String> name;
  final Value<Color> color;
  const ListerTagTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
  });
  ListerTagTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required Color color,
  })  : name = Value(name),
        color = Value(color);
  static Insertable<ListerTag> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
    });
  }

  ListerTagTableCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<Color>? color}) {
    return ListerTagTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      final converter = $ListerTagTableTable.$convertercolor;
      map['color'] = Variable<int>(converter.toSql(color.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListerTagTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

abstract class _$ListerDatabase extends GeneratedDatabase {
  _$ListerDatabase(QueryExecutor e) : super(e);
  late final $ListerListTableTable listerListTable =
      $ListerListTableTable(this);
  late final $ListerItemTableTable listerItemTable =
      $ListerItemTableTable(this);
  late final $ListerTagTableTable listerTagTable = $ListerTagTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [listerListTable, listerItemTable, listerTagTable];
}
