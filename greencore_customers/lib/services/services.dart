import 'dart:convert';
import 'package:greencore_1/models/plant.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:http/http.dart' as http;

class TrefleService {
  static const String _baseUrl = 'https://perenual.com';
  static const String _apiKey = 'sk-xor7660700d01b9954901';

  static Future<List<Plant>> fetchPlants(int pageCount) async {
    List<Plant> allPlants = [];
    for (int page = 1; page <= pageCount; page++) {
      final apiUrl =
          '$_baseUrl/api/species-list?key=$_apiKey&page=$page&q=&edible=&poisonous=&cycle=&watering=&sunlight=&indoor=&hardiness=';
      final response = await http.get(Uri.parse(apiUrl));
      // print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        List<Plant> plants = data.map((json) => Plant.fromJson(json)).toList();
        allPlants.addAll(plants);
      } else {
        throw Exception('Failed to load plants from page $page');
      }
    }
    return allPlants;
  }
}
