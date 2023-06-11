// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class Translations {
  Translations();

  static Translations? _current;

  static Translations get current {
    assert(_current != null,
        'No instance of Translations was loaded. Try to initialize the Translations delegate before accessing Translations.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<Translations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = Translations();
      Translations._current = instance;

      return instance;
    });
  }

  static Translations of(BuildContext context) {
    final instance = Translations.maybeOf(context);
    assert(instance != null,
        'No instance of Translations present in the widget tree. Did you add Translations.delegate in localizationsDelegates?');
    return instance!;
  }

  static Translations? maybeOf(BuildContext context) {
    return Localizations.of<Translations>(context, Translations);
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Sort by`
  String get sortBy {
    return Intl.message(
      'Sort by',
      name: 'sortBy',
      desc: '',
      args: [],
    );
  }

  /// `Ascending`
  String get asc {
    return Intl.message(
      'Ascending',
      name: 'asc',
      desc: '',
      args: [],
    );
  }

  /// `Descending`
  String get desc {
    return Intl.message(
      'Descending',
      name: 'desc',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `rename`
  String get rename {
    return Intl.message(
      'rename',
      name: 'rename',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get month {
    return Intl.message(
      'Month',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `Creation time`
  String get createdOn {
    return Intl.message(
      'Creation time',
      name: 'createdOn',
      desc: '',
      args: [],
    );
  }

  /// `Modification time`
  String get modifiedOn {
    return Intl.message(
      'Modification time',
      name: 'modifiedOn',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Rating`
  String get rating {
    return Intl.message(
      'Rating',
      name: 'rating',
      desc: '',
      args: [],
    );
  }

  /// `List`
  String get list {
    return Intl.message(
      'List',
      name: 'list',
      desc: '',
      args: [],
    );
  }

  /// `Add list`
  String get list_add {
    return Intl.message(
      'Add list',
      name: 'list_add',
      desc: '',
      args: [],
    );
  }

  /// `Create list`
  String get list_create {
    return Intl.message(
      'Create list',
      name: 'list_create',
      desc: '',
      args: [],
    );
  }

  /// `Could not create list {data}!`
  String list_create_error(Object data) {
    return Intl.message(
      'Could not create list $data!',
      name: 'list_create_error',
      desc: '',
      args: [data],
    );
  }

  /// `Choose list`
  String get list_choose {
    return Intl.message(
      'Choose list',
      name: 'list_choose',
      desc: '',
      args: [],
    );
  }

  /// `Rename list`
  String get list_rename {
    return Intl.message(
      'Rename list',
      name: 'list_rename',
      desc: '',
      args: [],
    );
  }

  /// `Could not rename list {name}`
  String list_rename_error(Object name) {
    return Intl.message(
      'Could not rename list $name',
      name: 'list_rename_error',
      desc: '',
      args: [name],
    );
  }

  /// `Delete list`
  String get list_delete {
    return Intl.message(
      'Delete list',
      name: 'list_delete',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure that you want to delete the list {name} ?`
  String list_delete_confirm(Object name) {
    return Intl.message(
      'Are you sure that you want to delete the list $name ?',
      name: 'list_delete_confirm',
      desc: '',
      args: [name],
    );
  }

  /// `Could not delete list!`
  String get list_delete_error {
    return Intl.message(
      'Could not delete list!',
      name: 'list_delete_error',
      desc: '',
      args: [],
    );
  }

  /// `Lists`
  String get lists {
    return Intl.message(
      'Lists',
      name: 'lists',
      desc: '',
      args: [],
    );
  }

  /// `Could not retrieve lists!`
  String get lists_error {
    return Intl.message(
      'Could not retrieve lists!',
      name: 'lists_error',
      desc: '',
      args: [],
    );
  }

  /// `Add tag`
  String get tag_add {
    return Intl.message(
      'Add tag',
      name: 'tag_add',
      desc: '',
      args: [],
    );
  }

  /// `Tags`
  String get tags {
    return Intl.message(
      'Tags',
      name: 'tags',
      desc: '',
      args: [],
    );
  }

  /// `Could not retrieve tags`
  String get tags_error {
    return Intl.message(
      'Could not retrieve tags',
      name: 'tags_error',
      desc: '',
      args: [],
    );
  }

  /// `Create tag`
  String get tags_create {
    return Intl.message(
      'Create tag',
      name: 'tags_create',
      desc: '',
      args: [],
    );
  }

  /// `Could not create tag {name}`
  String tags_create_error(Object name) {
    return Intl.message(
      'Could not create tag $name',
      name: 'tags_create_error',
      desc: '',
      args: [name],
    );
  }

  /// `Delete tag`
  String get tags_delete {
    return Intl.message(
      'Delete tag',
      name: 'tags_delete',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure that you want to delete the tag {name} ?`
  String tags_delete_confirm(Object name) {
    return Intl.message(
      'Are you sure that you want to delete the tag $name ?',
      name: 'tags_delete_confirm',
      desc: '',
      args: [name],
    );
  }

  /// `Could not delete tag!`
  String get tags_delete_error {
    return Intl.message(
      'Could not delete tag!',
      name: 'tags_delete_error',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get calendar {
    return Intl.message(
      'Calendar',
      name: 'calendar',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Show settings`
  String get settings_show {
    return Intl.message(
      'Show settings',
      name: 'settings_show',
      desc: '',
      args: [],
    );
  }

  /// `Language & Text`
  String get settings_language {
    return Intl.message(
      'Language & Text',
      name: 'settings_language',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Voice Assistant`
  String get voice_assistant {
    return Intl.message(
      'Voice Assistant',
      name: 'voice_assistant',
      desc: '',
      args: [],
    );
  }

  /// `Enable Voice Assistant`
  String get voice_assistant_enable {
    return Intl.message(
      'Enable Voice Assistant',
      name: 'voice_assistant_enable',
      desc: '',
      args: [],
    );
  }

  /// `Listen`
  String get voice_listen {
    return Intl.message(
      'Listen',
      name: 'voice_listen',
      desc: '',
      args: [],
    );
  }

  /// `Listening...`
  String get voice_listening {
    return Intl.message(
      'Listening...',
      name: 'voice_listening',
      desc: '',
      args: [],
    );
  }

  /// `Tap the microphone to start listening...`
  String get voice_listen_start {
    return Intl.message(
      'Tap the microphone to start listening...',
      name: 'voice_listen_start',
      desc: '',
      args: [],
    );
  }

  /// `Speech not available`
  String get voice_listen_disabled {
    return Intl.message(
      'Speech not available',
      name: 'voice_listen_disabled',
      desc: '',
      args: [],
    );
  }

  /// `Could not retrieve items for list {name}`
  String getItems_error(Object name) {
    return Intl.message(
      'Could not retrieve items for list $name',
      name: 'getItems_error',
      desc: '',
      args: [name],
    );
  }

  /// `Add new item`
  String get addItem {
    return Intl.message(
      'Add new item',
      name: 'addItem',
      desc: '',
      args: [],
    );
  }

  /// `Could not create item`
  String get addItem_error {
    return Intl.message(
      'Could not create item',
      name: 'addItem_error',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update item!`
  String get updateItem_error {
    return Intl.message(
      'Failed to update item!',
      name: 'updateItem_error',
      desc: '',
      args: [],
    );
  }

  /// `Delete item`
  String get deleteItem {
    return Intl.message(
      'Delete item',
      name: 'deleteItem',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure that you want to delete the item {name} ?`
  String deleteItem_confirm(Object name) {
    return Intl.message(
      'Are you sure that you want to delete the item $name ?',
      name: 'deleteItem_confirm',
      desc: '',
      args: [name],
    );
  }

  /// `Could not delete item!`
  String get deleteItem_error {
    return Intl.message(
      'Could not delete item!',
      name: 'deleteItem_error',
      desc: '',
      args: [],
    );
  }

  /// `Experienced`
  String get experienced {
    return Intl.message(
      'Experienced',
      name: 'experienced',
      desc: '',
      args: [],
    );
  }

  /// `No preview available for {url}!`
  String url_preview_error(Object url) {
    return Intl.message(
      'No preview available for $url!',
      name: 'url_preview_error',
      desc: '',
      args: [url],
    );
  }

  /// `Show tutorial`
  String get tutorial_show {
    return Intl.message(
      'Show tutorial',
      name: 'tutorial_show',
      desc: '',
      args: [],
    );
  }

  /// `Click here to create a new list`
  String get tutorial_createList1 {
    return Intl.message(
      'Click here to create a new list',
      name: 'tutorial_createList1',
      desc: '',
      args: [],
    );
  }

  /// `Or navigate to the drawer...`
  String get tutorial_createList2 {
    return Intl.message(
      'Or navigate to the drawer...',
      name: 'tutorial_createList2',
      desc: '',
      args: [],
    );
  }

  /// `Click here to create a new list`
  String get tutorial_createList3 {
    return Intl.message(
      'Click here to create a new list',
      name: 'tutorial_createList3',
      desc: '',
      args: [],
    );
  }

  /// `The text must not be empty!`
  String get validation_empty {
    return Intl.message(
      'The text must not be empty!',
      name: 'validation_empty',
      desc: '',
      args: [],
    );
  }

  /// `You must choose a list!`
  String get validation_chooseList {
    return Intl.message(
      'You must choose a list!',
      name: 'validation_chooseList',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<Translations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<Translations> load(Locale locale) => Translations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
