import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pharmacy_flutter/constants/environment.dart';

class MedicineService {
  Future<dynamic> getAllMedicines(String token) async {
    final url = Uri.parse('$apiUrl/medicines');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load medicines');
    }
  }

  Future<dynamic> generateQrCodeDataUrl(dynamic data, String token) async {
    final url = Uri.parse('$apiUrl/medicines/qrcode');

    print("--incoming data : $data");

    final response = await http.post(url, body: data, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to generate qr code data url');
    }
  }
}
