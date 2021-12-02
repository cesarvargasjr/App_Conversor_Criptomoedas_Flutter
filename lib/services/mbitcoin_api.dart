import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/result_mbitcoin.dart';

class MBitcoinService {
  static Future<ResultApi> fetchCoin(String coin) async {
    final Uri uri =
        Uri.parse('https://www.mercadobitcoin.net/api/$coin/ticker/');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return ResultApi.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Requisição inválida!');
    }
  }
}
