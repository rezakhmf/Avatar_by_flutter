import 'dart:convert';
import 'package:flutter_bloc_http_get/model/user_model.dart';
import 'package:http/http.dart';

class UserRepository {
  String endPoint = 'https://reqres.in/api/users?page=2';

 Future<List<UserModel>> getUsers() async {
    Response response = await get(Uri.parse(endPoint));
    if(response.statusCode == 200) {
      final List result = jsonDecode(response.body)['data'];
      return result.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}