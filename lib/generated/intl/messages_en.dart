// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(name) =>
      "Are you sure that you want to delete the item ${name} ?";

  static String m1(name) => "Could not retrieve items for list ${name}";

  static String m2(data) => "Could not create list ${data}!";

  static String m3(name) =>
      "Are you sure that you want to delete the list ${name} ?";

  static String m4(name) => "Could not rename list ${name}";

  static String m5(name) => "Could not create tag ${name}";

  static String m6(name) =>
      "Are you sure that you want to delete the tag ${name} ?";

  static String m7(url) => "No preview available for ${url}!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addItem": MessageLookupByLibrary.simpleMessage("Add new item"),
        "addItem_error":
            MessageLookupByLibrary.simpleMessage("Could not create item"),
        "asc": MessageLookupByLibrary.simpleMessage("Ascending"),
        "calendar": MessageLookupByLibrary.simpleMessage("Calendar"),
        "createdOn": MessageLookupByLibrary.simpleMessage("Creation time"),
        "deleteItem": MessageLookupByLibrary.simpleMessage("Delete item"),
        "deleteItem_confirm": m0,
        "deleteItem_error":
            MessageLookupByLibrary.simpleMessage("Could not delete item!"),
        "desc": MessageLookupByLibrary.simpleMessage("Descending"),
        "description": MessageLookupByLibrary.simpleMessage("Description"),
        "details": MessageLookupByLibrary.simpleMessage("Details"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "experienced": MessageLookupByLibrary.simpleMessage("Experienced"),
        "getItems_error": m1,
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "list": MessageLookupByLibrary.simpleMessage("List"),
        "list_add": MessageLookupByLibrary.simpleMessage("Add list"),
        "list_choose": MessageLookupByLibrary.simpleMessage("Choose list"),
        "list_create": MessageLookupByLibrary.simpleMessage("Create list"),
        "list_create_error": m2,
        "list_delete": MessageLookupByLibrary.simpleMessage("Delete list"),
        "list_delete_confirm": m3,
        "list_delete_error":
            MessageLookupByLibrary.simpleMessage("Could not delete list!"),
        "list_rename": MessageLookupByLibrary.simpleMessage("Rename list"),
        "list_rename_error": m4,
        "lists": MessageLookupByLibrary.simpleMessage("Lists"),
        "lists_error":
            MessageLookupByLibrary.simpleMessage("Could not retrieve lists!"),
        "modifiedOn": MessageLookupByLibrary.simpleMessage("Modification time"),
        "month": MessageLookupByLibrary.simpleMessage("Month"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "rating": MessageLookupByLibrary.simpleMessage("Rating"),
        "rename": MessageLookupByLibrary.simpleMessage("rename"),
        "reset": MessageLookupByLibrary.simpleMessage("Reset"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "settings_language":
            MessageLookupByLibrary.simpleMessage("Language & Text"),
        "settings_show": MessageLookupByLibrary.simpleMessage("Show settings"),
        "sortBy": MessageLookupByLibrary.simpleMessage("Sort by"),
        "tag_add": MessageLookupByLibrary.simpleMessage("Add tag"),
        "tags": MessageLookupByLibrary.simpleMessage("Tags"),
        "tags_create": MessageLookupByLibrary.simpleMessage("Create tag"),
        "tags_create_error": m5,
        "tags_delete": MessageLookupByLibrary.simpleMessage("Delete tag"),
        "tags_delete_confirm": m6,
        "tags_delete_error":
            MessageLookupByLibrary.simpleMessage("Could not delete tag!"),
        "tags_error":
            MessageLookupByLibrary.simpleMessage("Could not retrieve tags"),
        "tutorial_createList1": MessageLookupByLibrary.simpleMessage(
            "Click here to create a new list"),
        "tutorial_createList2": MessageLookupByLibrary.simpleMessage(
            "Or navigate to the drawer..."),
        "tutorial_createList3": MessageLookupByLibrary.simpleMessage(
            "Click here to create a new list"),
        "tutorial_show": MessageLookupByLibrary.simpleMessage("Show tutorial"),
        "update": MessageLookupByLibrary.simpleMessage("Update"),
        "updateItem_error":
            MessageLookupByLibrary.simpleMessage("Failed to update item!"),
        "url_preview_error": m7,
        "validation_chooseList":
            MessageLookupByLibrary.simpleMessage("You must choose a list!"),
        "validation_empty":
            MessageLookupByLibrary.simpleMessage("The text must not be empty!"),
        "voice_assistant":
            MessageLookupByLibrary.simpleMessage("Voice Assistant"),
        "voice_assistant_enable":
            MessageLookupByLibrary.simpleMessage("Enable Voice Assistant"),
        "voice_listen": MessageLookupByLibrary.simpleMessage("Listen"),
        "voice_listen_disabled":
            MessageLookupByLibrary.simpleMessage("Speech not available"),
        "voice_listen_start": MessageLookupByLibrary.simpleMessage(
            "Tap the microphone to start listening..."),
        "voice_listening": MessageLookupByLibrary.simpleMessage("Listening..."),
        "yes": MessageLookupByLibrary.simpleMessage("Yes")
      };
}
