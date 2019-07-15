import 'dart:async';
import 'package:flutter_plugin_example/model/contact.dart';
import 'package:content_provider/content_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';

class ContactBloc {
  StreamController<List<Contact>> _contactStreamController = StreamController();
  StreamController<String> _showMsgController = StreamController();

  Stream<List<Contact>> getContactsStream() {
    return _contactStreamController.stream;
  }

  Stream<String> getMsgStream(){
    return _showMsgController.stream;
  }

  ContactBloc() {
    _checkPermission().then((isGranted) {
      if (isGranted) {
        _getContacts();
      } else {
        _showMsgController.sink.add("Permission is required for contacts");
      }
    });
  }

  Future<bool> _checkPermission() async {
    var isGranted =
        await SimplePermissions.checkPermission(Permission.ReadContacts);
    if (!isGranted) {
      var result =
          await SimplePermissions.requestPermission(Permission.ReadContacts);
      return result == PermissionStatus.authorized;
    } else {
      return true;
    }
  }

  void _getContacts() async {
    List<Map<dynamic, dynamic>> contactMaps =
        await ContentProviderPlugin.getContentValue(
            "content://com.android.contacts/data/");

    List<Contact> contacts = List();

    contactMaps.forEach((contact) {
      print("contat is$contact");
      contacts.add(Contact(
          name: contact["display_name"], number: contact["data4"] ?? ""));
    });
    _contactStreamController.sink.add(contacts);
  }

  void dispose() {
    _contactStreamController.close();
    _showMsgController.close();
  }
}
