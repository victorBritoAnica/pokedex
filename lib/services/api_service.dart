import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';
import '../utils/result.dart';

class ApiService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2';

  Future<Result<List<Pokemon>>> fetchPokemons(int offset, int limit) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/pokemon?offset=$offset&limit=$limit'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        final pokemons = results.asMap().entries.map((entry) {
          final index = entry.key + offset + 1;
          return Pokemon.fromJson(entry.value, index);
        }).toList();
        return Success(pokemons);
      } else {
        return Failure(
          'Error ${response.statusCode}: No se pudieron cargar los Pokémon',
        );
      }
    } catch (e) {
      return Failure('Ocurrió un error inesperado: $e');
    }
  }
}
