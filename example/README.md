# content_provider_plugin example

Demonstrates how to use the content_provider plugin.

1)get contacts from android app in your flutter app.

i am using bloc pattern so below is the example of getting all contacts from android contact app.

 void _getContacts() async {

    //content://com.android.contacts/data/ :-is the uri of contact app database in android.
    List<Map<dynamic, dynamic>> contactMaps =
        await ContentProviderPlugin.getContentValue(
            "content://com.android.contacts/data/");

    List<Contact> contacts = List();

    contactMaps.forEach((contact) {
    //"display_name" is the database field of name of contact
    //"data4 is the database filed of number of contact.
      contacts.add(Contact(
          name: contact["display_name"], number: contact["data4"] ?? ""));
    });
    _contactStreamController.sink.add(contacts);
  }

