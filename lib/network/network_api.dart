import 'package:flutter_intermediate/model/auth_model.dart';
import 'package:http/http.dart' as http;

class Network {
  static String _host = "udakita.com";

  Future<ModelAuth?> registerUser(
      String? email, String? password, String? nama, String? phone) async {
    final endpoint = Uri.http(_host, "servernotif/api/daftar");
    final response = await http.post(endpoint, body: {
      "email": email,
      "password": password,
      "nama": nama,
      "phone": phone
    });
  }

  Future<ModelAuth?> loginUser(
      String? email, String? password, String? device) async {
    final endpoint = Uri.http(_host, "servernotif/api/login");
    final response = await http.post(endpoint,
        body: {"f_email": email, "f_password": password, "device": device});
  }


}
