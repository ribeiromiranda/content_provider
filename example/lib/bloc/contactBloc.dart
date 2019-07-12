import 'dart:async';
import 'package:flutter_plugin_example/model/contact.dart';
import 'package:flutter_plugin/flutter_plugin.dart';

class ContactBloc {
  StreamController<List<Contact>> contactStreamController = StreamController();

  Stream<List<Contact>> getContactsStream() {
    return contactStreamController.stream;
  }

  ContactBloc() {
    _getContacts();
  }

  void _getContacts() async {
    List<Map<dynamic, dynamic>> contactMaps =
        await FlutterPlugin.getContentValue(
            "content://com.android.contacts/data/");

    List<Contact> contacts = List();

    contactMaps.forEach((contact) {
      print("contat is$contact");

      if (contact["data4"] != null) {
        contacts.add(Contact(
            name: contact["display_name"], number: contact["data4"] ?? ""));
      }
    });
    contactStreamController.sink.add(contacts);
  }

  void dispose() {
    contactStreamController.close();
  }
}
