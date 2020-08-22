import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Users.dart';

class Services {
  //CRUD Operations

  //update user details
  static Future<String> updateUser(
    String _id,
    String _name,
    String _email,
  ) async {
    try {
      var map = Map<String, dynamic>();
      map["id"] = _id;
      map["name"] = _name;
      map["email"] = _email;
      final data = json.encode(map);
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.post(
          'https://app.minor.li/php-jwt-example/api/update.php',
          headers: headers,
          body: data);
      //print('updateUser Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  //user login
  static Future<String> loginUser(
    String _email,
    String _password,
  ) async {
    try {
      var map = Map<String, dynamic>();
      map["email"] = _email;
      map["password"] = _password;
      final data = json.encode(map);
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.post('https://app.minor.li/php-jwt-example/api/login.php',
          headers: headers,
          body: data);

      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  //get the user details and it return to Users Profile
  static Future<List<User>> getUserDetails(String jwt)
  async {
    try {
      var map = Map<String, dynamic>();
      map["active"] = 1;
      final data = json.encode(map);
      print(data);
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http
          .post("https://app.minor.li/php-jwt-example/api/users.php", headers: headers, body: data);
      if (200 == response.statusCode) {
        print(response.body);
        List<User> list = parseResponse(response.body);
        return list;
      } else {
        return List<User>();
      }
    } catch (e) {
      return List<User>(); // return an empty list on exception/error
    }
  }

  //get all user details of user details table
  static Future<List<User>> getUsers() async {
    try {
      var map = Map<String, dynamic>();
      map["active"] = 1;
      final data = json.encode(map);
      print(data);
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http
          .post("https://app.minor.li/php-jwt-example/api/users.php", headers: headers, body: data);
      if (200 == response.statusCode) {
        List<User> list = parseResponse(response.body);
        return list;
      } else {
        return List<User>();
      }
    } catch (e) {
      return List<User>(); // return an empty list on exception/error
    }
  }
   static List<User> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }
//delete the user from the table
  static Future<String> deleteUser(String id)
  async {
    try {
      var map = Map<String, dynamic>();
      map["id"] = id;
      final data = json.encode(map);
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.post(
          'https://app.minor.li/php-jwt-example/api/delete.php',
          headers: headers,
          body: data);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // returning just an "error" string to keep this simple...
    }
  }

  //Add a new user
  static Future<String> addUser(
    String _name,
    String _email,
    String _password,
  ) async {
    try {
      var map = Map<String, dynamic>();
      map["name"] = _name;
      map["email"] = _email;
      map["password"] = _password;
      final data = json.encode(map);
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.post(
          'https://app.minor.li/php-jwt-example/api/register.php',
          headers: headers,
          body: data);
      //print('addUser Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }
}
