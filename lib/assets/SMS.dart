import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<http.Response> postRequest () async {
  print("tabed");
  var url ='https://api.claudezhang.ca/sendsms/';

  Map data = {
    'cell': '+14379868820',//
    'body':'老公已到---from Claude'
  };
  //encode Map to JSON
  var body = json.encode(data);

  var response = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body
  );
  
  return response;
  
}