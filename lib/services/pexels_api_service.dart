import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:photos_app/models/photo_model.dart';

class PixelsApiService {
  Future<List<dynamic>> getPhotosData() async {
    var data;

    final response = await http.get(
        Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
        headers: {
          'Authorization':
              '563492ad6f917000010000018b31ba9eabe941bdb522ae8c4742c12e'
        });
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Error Occured');
    }
  }
}
