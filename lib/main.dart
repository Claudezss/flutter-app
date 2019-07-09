import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'pages/addBlog.dart';
import 'assets/SMS.dart';

//import 'package:intl/intl.dart';
//import 'dart:convert';

void main() => runApp(MyApp());
var httpClient = new HttpClient();
final dummySnapshot = [
 {"name": "Filip", "votes": 15},
 {"name": "Abraham", "votes": 14},
 {"name": "Richard", "votes": 11},
 {"name": "Ike", "votes": 10},
 {"name": "Justin", "votes": 1},
];

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'Baby Names',
     home: MyHomePage(),
     theme: ThemeData(         
        primaryColor: Colors.blue,
      ),  
   );
 }
}

class MyHomePage extends StatefulWidget {
 @override
 _MyHomePageState createState() {
   return _MyHomePageState();
 }
}

class _MyHomePageState extends State<MyHomePage> {
  void _pushSaved() {
  Navigator.of(context).push(
    MaterialPageRoute<void>(   // Add 20 lines from here...
      builder: (BuildContext context) {
       return AddBlogForm();
      },
    ),                       // ... to here.
  );
}
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Claude's Blog"),
       actions: <Widget>[
         IconButton(
              icon: Icon(Icons.message),
              onPressed: postRequest,
            ),
       ],
     ),
     body: _buildBody(context),
     floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
     floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: _pushSaved,
    ),
    
     bottomNavigationBar: BottomNavigationBar(
      
       items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          title: Text('Business'),
          
          
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          title: Text('School'),
        ),
      ],
     ),
     
   );
 }
 Widget _card(BuildContext context) {
  return Center(
    child: Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          print('Card tapped.');
        },
        child: Container(
          width: 300,
          height: 100,
          child: Text('A card that can be tapped'),
        ),
      ),
    ),
  );
}

 Widget _buildBody(BuildContext context) {
 return StreamBuilder<QuerySnapshot>(
   stream: Firestore.instance.collection('blog').snapshots(),
   builder: (context, snapshot) {
     if (!snapshot.hasData) return LinearProgressIndicator();

     return _buildList(context, snapshot.data.documents);
   },
 );
}

 Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
   return ListView(
     padding: const EdgeInsets.only(top: 10.0),
     children: 
       snapshot.map((data) => _buildListItem(context, data)).toList(),
     
   );
 }

 Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
   final record = Blog.fromSnapshot(data);
    return Center(

      child: Card(
        margin:EdgeInsets.all(15.0),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.network(
              //record.img,
             record.img,
              height: 150,
              //width: BoxFit.fitWidth,
              fit:BoxFit.cover,
              ),
             ListTile(
              //isThreeLine: true,
              leading: Text(
                record.category.toUpperCase(),
                style: TextStyle(fontSize: 25.0),
              ),
              title: Text(record.title),
              subtitle: 
                Text('Author:'+record.author.toString()+'\n'+
                'Date:'+DateTime.fromMillisecondsSinceEpoch(record.created_date.millisecondsSinceEpoch).toString()
                ),
              contentPadding: EdgeInsets.all(10.0),
              onTap: () => Firestore.instance.runTransaction((transaction) async {
                final freshSnapshot = await transaction.get(record.reference);
                final fresh = Blog.fromSnapshot(freshSnapshot);
                await transaction
                    .update(record.reference, {'views': fresh.views + 1});
              }),
            ),
          
          ],
        ),
      ),
    );
   /*return Padding(
     key: ValueKey(record.name),
     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
     child: Container(
       decoration: BoxDecoration(
         border: Border.all(color: Colors.grey),
         borderRadius: BorderRadius.circular(5.0),
       ),
       child: ListTile(
         title: Text(record.name),
         trailing: Text(record.votes.toString()),
         onTap: () => Firestore.instance.runTransaction((transaction) async {
     final freshSnapshot = await transaction.get(record.reference);
     final fresh = Record.fromSnapshot(freshSnapshot);

     await transaction
         .update(record.reference, {'votes': fresh.votes + 1});
   }),
       ),
     ),
   );*/
 }
}

class Record {
 final String name;
 final int votes;
 final String img;

 final DocumentReference reference;

 Record.fromMap(Map<String, dynamic> map, {this.reference})
     : assert(map['name'] != null),
       assert(map['votes'] != null),
        assert(map['img'] != null),
       name = map['name'],
       votes = map['votes'],
       img = map['img'];

 Record.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);

 @override
 String toString() => "Record<$name:$votes>";
}

class Blog {
  final String author;
  final String body;
  final String category;
  final String img;
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
        assert(map['img'] != null),
       author = map['author'],
       body = map['body'],
       title = map['title'],
       category = map['category'],
       created_date = map['created_date'],
       views = map['views'],
       img = map['img'];
 Blog.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);

 @override
 String toString() => "Record<$title:$author>";


}
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(ClaudeLife());

class ClaudeLife extends StatelessWidget {
  @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: "Claude's Blog",
     home: Scaffold(
       appBar:AppBar(
         title: Text("Claude's Blog"),
       ),
       body: Column(
         children: <Widget>[
           _cardBody(context),

         ],
       ),
       bottomNavigationBar: BottomNavigationBar(
       items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          title: Text('Business'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          title: Text('School'),
        ),
      ],
     ),
     ),
     theme: ThemeData(         
        primaryColor: Colors.blue,
      ),  
   );
 }
Widget _cardBody(BuildContext context) {
 return StreamBuilder<QuerySnapshot>(
   stream: Firestore.instance.collection('baby').snapshots(),
   builder: (context, snapshot) {
     if (!snapshot.hasData) return LinearProgressIndicator();

     return _cardList(context, snapshot.data.documents);
   },
 );
}

Widget _cardList(BuildContext context, List<DocumentSnapshot> snapshot) {
  
   return ListView(
     padding: const EdgeInsets.only(top: 20.0),
     children: 
       snapshot.map((data) => _cardListItem(context, data)).toList(),
     
   );
 }
Widget _cardListItem(BuildContext context, DocumentSnapshot data) {
   final record = Record.fromSnapshot(data);

   return Padding(
     key: ValueKey(record.name),
     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
     child: Container(
       decoration: BoxDecoration(
         border: Border.all(color: Colors.grey),
         borderRadius: BorderRadius.circular(5.0),
       ),
       child: ListTile(
         title: Text(record.name),
         trailing: Text(record.votes.toString()),
         onTap: () => Firestore.instance.runTransaction((transaction) async {
     final freshSnapshot = await transaction.get(record.reference);
     final fresh = Record.fromSnapshot(freshSnapshot);

     await transaction
         .update(record.reference, {'votes': fresh.votes + 1});
   }),
       ),
     ),
   );
 }

}


class NewsCardWidget extends StatefulWidget{
   @override
  _NewsCardWidgetState createState() => _NewsCardWidgetState();
}

class _NewsCardWidgetState extends State<NewsCardWidget>{
  Widget build(BuildContext context) {
    return Center(
    
      child: Card(
        margin:EdgeInsets.all(15.0),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'images/lake.jpg',
              height: 150,
              //width: BoxFit.fitWidth,
              fit:BoxFit.cover,
              ),
            const ListTile(
              leading: Icon(Icons.album),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
              contentPadding: EdgeInsets.all(10.0),
            ),
            ButtonTheme.bar(
              // make buttons use the appropriate styles for cards
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('BUY TICKETS'),
                    onPressed: () {
                      /* ... */},
                  ),
                  FlatButton(
                    child: const Text('LISTEN'),
                    onPressed: () {/* ... */},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class Record {
 final String name;
 final int votes;
 final DocumentReference reference;

 Record.fromMap(Map<String, dynamic> map, {this.reference})
     : assert(map['name'] != null),
       assert(map['votes'] != null),
       name = map['name'],
       votes = map['votes'];

 Record.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);

 @override
 String toString() => "Record<$name:$votes>";
}*/

class MyHomePage2 extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

