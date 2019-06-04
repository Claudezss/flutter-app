import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


  String _title = '';
  String _body = '';
  final _formKey = GlobalKey<FormState>();
  
 
  Widget newBlog(BuildContext context) {
  var documentRef = Firestore.instance.collection('blog').document();
  
  return Scaffold(
    appBar: new AppBar(
      title: new Text('New Blog'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  print('dasda');
                    // If the form is valid, display a snackbar. In the real world, you'd
                    // often want to call a server or save the information in a database
                  
                    Firestore.instance.runTransaction((transaction) async{
                      await transaction
                    .set(documentRef, 
                    {
                      'author':'Claude',
                      'title':_title,
                      'body':_body,
                      'created_date':DateTime.now(),
                      'category':'test',
                      'views':0,
                    }
                    );
              });

                    }
                  },
                
          child: Text(
            "Save",
          
          ),
        )
      ],
    ),
    body: Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key:_formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TextFormField(
                validator: (value){
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                },
                onSaved: (value){
                    _title=value;
                },
                decoration: InputDecoration(
                  labelText: 'Title'
                ),
              ),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Body'
                ),
                onSaved: (value){
                  
                    _body=value;
                 
                },
              )
            ],
          ),
        ),
      ),
    ),
  );
}
 




class Blog {
  final String author;
  final String body;
  final String category;
  final Timestamp created_date;
  final int views;
  //final String updated_time;
  final String title;
  final DocumentReference reference;

  Blog.fromMap(Map<String, dynamic> map, {this.reference})
     : assert(map['author'] != null),
       assert(map['body'] != null),
       assert(map['category'] != null),
       assert(map['title'] != null),
       assert(map['created_date'] != null),
       assert(map['views'] != null),
       author = map['author'],
       body = map['body'],
       title = map['title'],
       category = map['category'],
       created_date = map['created_date'],
       views = map['views'];
 Blog.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);

 @override
 String toString() => "Record<$title:$author>";


}
