import 'dart:convert';
import 'package:http/http.dart' as http;

final regulusVercelURL = 'https://regulus-store.vercel.app/api/';

Future<Map<String, dynamic>> fetchFromRegulusVercel(String route) async {
  final url = '$regulusVercelURL$route';
  final headers = {'Content-Type': 'application/json'};
  final response = await http.get(
    Uri.parse(url),
    headers: headers,
  );
  if (response.statusCode == 200) {
    return json.decode(response.body) as Map<String, dynamic>;
  } else {
    //print('${response.statusCode} ${response.reasonPhrase}');
    return {'error': true, 'code': response.statusCode, 'text': response.reasonPhrase};
  }
}
