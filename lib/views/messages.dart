import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatefulWidget {
  @override
  MessagePage createState() => MessagePage();
}

class MessagePage extends State<Messages> {
  String _to, _message;

  final _formKeyMessage = GlobalKey<FormState>();

  void sendMessages() async {
    final formState = _formKeyMessage.currentState;
    if (formState.validate()) {
      formState.save();
      Firestore.instance.runTransaction((Transaction transaction) async {
        CollectionReference reference =
            Firestore.instance.collection('messages');
        await reference
            .add({"name": _to, "time": '1 minute', "description": _message});
        formState.reset();
        _dismiss();
      });
    }
  }

  void _dismiss() {
    Navigator.pop(context);
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Message Sent', textAlign: TextAlign.center)));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: _buildMessages(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Form(
                    key: _formKeyMessage,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty)
                                return 'This field is required';
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'To:'),
                            onSaved: (value) => _to = value,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty)
                                return 'This field is required';
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'Message:'),
                            onSaved: (value) => _message = value,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                            textColor: Colors.white,
                            child: Text("Send"),
                            onPressed: () {
                              sendMessages();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        },
        child: Icon(Icons.message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  Widget _buildMessages() {
    return StreamBuilder(
      stream: Firestore.instance.collection('messages').snapshots(),
      builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        return new MessageList(document: snapshot.data.documents);
      },
    );
  }
}

class MessageList extends StatelessWidget {
  MessageList({this.document});
  final List<DocumentSnapshot> document;
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: document.length,
      itemBuilder: (BuildContext ctx, int i) {
        String name = document[i].data['name'].toString();
        String time = document[i].data['time'].toString();
        String description = document[i].data['description'].toString();

        return Dismissible(
            key: Key(document[i].documentID),
            onDismissed: (direction) {
              Firestore.instance.runTransaction((transaction) async {
                DocumentSnapshot snapshot =
                    await transaction.get(document[i].reference);
                await transaction.delete(snapshot.reference);
              });

              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('Message Deleted', textAlign: TextAlign.center)));
            },
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text(name),
                    subtitle: Text(description),
                    trailing: Text(time),
                  ),
                  Divider(),
                ],
              ),
            ));
      },
    );
  }
}
