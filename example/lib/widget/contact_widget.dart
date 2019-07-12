import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_plugin_example/bloc/contact_bloc.dart';
import 'package:flutter_plugin_example/model/contact.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Contacts"),
        ),
        body: Provider<ContactBloc>(
            builder: (context) => ContactBloc(),
            dispose: (context, bloc) => bloc.dispose(),
            child: GroupWidget()),
      ),
    );
  }
}

class GroupWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[ContactListWidget(), EmptyWidget()],
    );
  }
}

class ContactListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ContactBloc contactBloc = Provider.of<ContactBloc>(context);
    return StreamBuilder<List<Contact>>(
      stream: contactBloc.getContactsStream(),
      builder: (context, contacts) {
        if (contacts.hasData) {
          if (contacts.data.isNotEmpty) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: contacts.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(contacts.data[index].name),
                    subtitle: Text(contacts.data[index].number),
                  );
                });
          } else {
            return Center(
              child: Text("No contact found"),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class EmptyWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EmptyState();
  }
}

class EmptyState extends State<EmptyWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ContactBloc contactBloc = Provider.of<ContactBloc>(context);
    contactBloc.getMsgStream().listen((msg) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
