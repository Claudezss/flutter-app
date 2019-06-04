import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AddBlogForm extends StatefulWidget {
  @override
  AddBlogFormState createState() {
    return AddBlogFormState();
  }
}

// Define a corresponding State class. This class will hold the data related to
// the form.
class AddBlogFormState extends State<AddBlogForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a `GlobalKey<FormState>`, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  
  String _title = '';
  String _body = '';
  String _uploadButtonText='Upload';
  bool _uploadButtonDiabled=false;
  var documentRef = Firestore.instance.collection('blog').document();
  File _image;
  String _downloadURL='none';

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    
    setState(() {
      _image = image;
    });

    //return downloadURL.toString();
     
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
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
                      'img':_downloadURL=='none'?'http://www.agwestdist.com/storage/img/noimg.png':_downloadURL,
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
          child: ListView(
            //mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _image==null?
              FloatingActionButton(
                  onPressed: getImage,
                  tooltip: 'Pick Image',
                  child: Icon(Icons.add_a_photo),
                ):upload(),
              
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
              ),
            
            ],
          ),
        ),
      ),
    ),
  );
  }

  Widget upload(){
    return Container(
      child: Column(
        children: <Widget>[
          Image.file(
            _image
          ),
          RaisedButton(
            child:_uploadButtonText=='Uploading'?CircularProgressIndicator():Text(_uploadButtonText),
            onPressed:_uploadButtonDiabled?null: ()async{
              setState(() {
                _uploadButtonText='Uploading';
              }); 
              FirebaseStorage _storage = FirebaseStorage.instance;
              StorageReference reference = _storage.ref().child(DateTime.now().toString());
              StorageUploadTask uploadTask = reference.putFile(_image);
              final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
              final String url = (await downloadUrl.ref.getDownloadURL());
              setState(() {
                _downloadURL=url; 
                _uploadButtonText='Uploaded';
                _uploadButtonDiabled=true;
              }); 
            },
          ),
    ]
      ),
    );

  }
}
