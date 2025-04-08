import 'package:http/http.dart';
import 'dart:convert';

class Networkhelper{
  final String uri;
  Networkhelper(this.uri);

  Future<dynamic> getdata() async {
    try {
      Response response = await get(Uri.parse(uri));
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        String data = response.body;
        return jsonDecode(data);
      } else {
        print('Error: ${response.statusCode}');
        return null; // ✅ explicitly return null or an error object
      }
    } catch (e) {
      print('Exception caught: $e');
      return null; // ✅ catch and return something
    }
  }

}