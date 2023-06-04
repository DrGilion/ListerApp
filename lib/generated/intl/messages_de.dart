// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
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
  String get localeName => 'de';

  static String m0(name) =>
      "Bist du sicher, dass der Eintrag ${name} gelöscht werden soll?";

  static String m1(name) =>
      "Einträge für Liste ${name} konnten nicht geladen werden";

  static String m2(data) => "Liste ${data} konnte nicht erstellt werden!";

  static String m3(name) =>
      "Bist du sicher, dass die Liste ${name} gelöscht werden soll?";

  static String m4(name) => "Konnte Liste ${name} nicht umbenennen";

  static String m5(url) => "Keine Vorschau vorhanden für ${url}!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addItem":
            MessageLookupByLibrary.simpleMessage("Neuen Eintrag hinzufügen"),
        "addItem_error": MessageLookupByLibrary.simpleMessage(
            "Eintrag konnte nicht erstellt werden"),
        "asc": MessageLookupByLibrary.simpleMessage("Aufsteigend"),
        "calendar": MessageLookupByLibrary.simpleMessage("Kalender"),
        "createdOn": MessageLookupByLibrary.simpleMessage("Erstellt am"),
        "deleteItem": MessageLookupByLibrary.simpleMessage("Eintrag löschen"),
        "deleteItem_confirm": m0,
        "deleteItem_error": MessageLookupByLibrary.simpleMessage(
            "Eintrag konnte nicht gelöscht werden!"),
        "desc": MessageLookupByLibrary.simpleMessage("Absteigend"),
        "description": MessageLookupByLibrary.simpleMessage("Beschreibung"),
        "details": MessageLookupByLibrary.simpleMessage("Details"),
        "edit": MessageLookupByLibrary.simpleMessage("Bearbeiten"),
        "experienced": MessageLookupByLibrary.simpleMessage("Erledigt"),
        "getItems_error": m1,
        "language": MessageLookupByLibrary.simpleMessage("Sprache"),
        "list": MessageLookupByLibrary.simpleMessage("Liste"),
        "list_add": MessageLookupByLibrary.simpleMessage("Liste hinzufügen"),
        "list_choose": MessageLookupByLibrary.simpleMessage("Liste auswählen"),
        "list_create": MessageLookupByLibrary.simpleMessage("Liste erstellen"),
        "list_create_error": m2,
        "list_delete": MessageLookupByLibrary.simpleMessage("List löschen"),
        "list_delete_confirm": m3,
        "list_delete_error": MessageLookupByLibrary.simpleMessage(
            "Liste konnte nicht gelöscht werden!"),
        "list_rename": MessageLookupByLibrary.simpleMessage("Liste umbenennen"),
        "list_rename_error": m4,
        "lists": MessageLookupByLibrary.simpleMessage("Listen"),
        "lists_error": MessageLookupByLibrary.simpleMessage(
            "Listen konnten nicht geladen werden!"),
        "modifiedOn":
            MessageLookupByLibrary.simpleMessage("Zuletzt bearbeitet am"),
        "month": MessageLookupByLibrary.simpleMessage("Monat"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "no": MessageLookupByLibrary.simpleMessage("Nein"),
        "rating": MessageLookupByLibrary.simpleMessage("Bewertung"),
        "rename": MessageLookupByLibrary.simpleMessage("Umbenennen"),
        "reset": MessageLookupByLibrary.simpleMessage("Zurücksetzen"),
        "settings": MessageLookupByLibrary.simpleMessage("Einstellungen"),
        "settings_language":
            MessageLookupByLibrary.simpleMessage("Sprache & Text"),
        "settings_show":
            MessageLookupByLibrary.simpleMessage("Einstellungen zeigen"),
        "sortBy": MessageLookupByLibrary.simpleMessage("Sortieren nach"),
        "tutorial_createList1": MessageLookupByLibrary.simpleMessage(
            "Klicke hier, um eine neue Liste zu erstellen"),
        "tutorial_createList2": MessageLookupByLibrary.simpleMessage(
            "Oder navigiere in dieses Menü..."),
        "tutorial_createList3": MessageLookupByLibrary.simpleMessage(
            "Klicke hier, um eine neue Liste zu erstellen"),
        "tutorial_show":
            MessageLookupByLibrary.simpleMessage("Tutorial zeigen"),
        "updateItem_error": MessageLookupByLibrary.simpleMessage(
            "Eintrag-Aktualisierung fehlgeschlagen!"),
        "url_preview_error": m5,
        "validation_chooseList": MessageLookupByLibrary.simpleMessage(
            "Du musst eine Liste auswählen!"),
        "validation_empty": MessageLookupByLibrary.simpleMessage(
            "Der Text darf nicht leer sein!"),
        "voice_assistant":
            MessageLookupByLibrary.simpleMessage("Sprach-Assistent"),
        "voice_assistant_enable":
            MessageLookupByLibrary.simpleMessage("Sprach-Assistent aktivieren"),
        "voice_listen": MessageLookupByLibrary.simpleMessage("Aufnehmen"),
        "voice_listen_disabled":
            MessageLookupByLibrary.simpleMessage("Aufnahme nicht möglich"),
        "voice_listen_start": MessageLookupByLibrary.simpleMessage(
            "Klicke den Knopf, um die Aufnahme zu starten..."),
        "voice_listening": MessageLookupByLibrary.simpleMessage("Aufnehmen..."),
        "yes": MessageLookupByLibrary.simpleMessage("Ja")
      };
}
