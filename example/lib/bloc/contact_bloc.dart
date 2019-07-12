import 'dart:async';
import 'package:flutter_plugin_example/model/contact.dart';
import 'package:flutter_plugin/flutter_plugin.dart';
import 'package:simple_permissions/simple_permissions.dart';

class ContactBloc {
  StreamController<List<Contact>> contactStreamController = StreamController();
  StreamController<String> showMsgController = StreamController();

  Stream<List<Contact>> getContactsStream() {
    return contactStreamController.stream;
  }

  Stream<String> getMsgStream(){
    return showMsgController.stream;
  }

  ContactBloc() {
    _checkPermission().then((isGranted) {
      if (isGranted) {
        _getContacts();
      } else {
        showMsgController.sink.add("Permission is required for contacts");
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
        await FlutterPlugin.getContentValue(
            "content://com.android.contacts/data/");

    List<Contact> contacts = List();

    contactMaps.forEach((contact) {
      print("contat is$contact");
      contacts.add(Contact(
          name: contact["display_name"], number: contact["data4"] ?? ""));
    });
    contactStreamController.sink.add(contacts);
  }

  void dispose() {
    contactStreamController.close();
    showMsgController.close();
  }
}
