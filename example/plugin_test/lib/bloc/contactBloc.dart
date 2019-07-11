import 'dart:async';
import 'package:plugin_test/model/contact.dart';
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
    List<Map<String, dynamic>> contactMaps =
        await FlutterPlugin.getContentValue(
            "content://com.android.contacts/data/");

    List<Contact> contacts = List();

    contactMaps.forEach((contact) {
      contacts.add(Contact(name: contact['data1'], number: contact['data4']));
    });
    contactStreamController.sink.add(contacts);
  }

  void dispose() {
    contactStreamController.close();
  }
}
