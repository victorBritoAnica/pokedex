import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';
import '../utils/result.dart';

class ApiService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2';

  /// Obtiene lista paginada de Pokémon completos (con descripción)
  Future<Result<List<Pokemon>>> fetchPokemons(int offset, int limit) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/pokemon?offset=$offset&limit=$limit'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        // Ejecuta todas las llamadas de detalle en paralelo
        final futures = <Future<Pokemon>>[];

        for (int i = 0; i < results.length; i++) {
          final id = offset + i + 1;
          futures.add(_fetchPokemonDetail(id));
        }

        final pokemons = await Future.wait(futures);

        return Success(pokemons);
      }

      return Failure('Error al obtener pokemons');
    } catch (e) {
      return Failure('Excepción al obtener pokemons: $e');
    }
  }

  /// Obtiene el detalle de un Pokémon (incluye nombre, imagen y descripción)
  Future<Pokemon> _fetchPokemonDetail(int id) async {
    final detailRes = await http.get(Uri.parse('$_baseUrl/pokemon/$id'));
    final speciesRes = await http.get(
      Uri.parse('$_baseUrl/pokemon-species/$id'),
    );

    if (detailRes.statusCode == 200 && speciesRes.statusCode == 200) {
      final detailJson = json.decode(detailRes.body);
      final speciesJson = json.decode(speciesRes.body);

      final flavorTextEntry = (speciesJson['flavor_text_entries'] as List)
          .cast<Map<String, dynamic>>()
          .firstWhere(
            (entry) => entry['language']['name'] == 'es',
            orElse: () => {'flavor_text': 'Sin descripción disponible'},
          );

      final description = flavorTextEntry['flavor_text']
          .replaceAll('\n', ' ')
          .replaceAll('\f', ' ');

      return Pokemon.fromFullJson(detailJson, description);
    } else {
      throw Exception('Error al obtener detalles del Pokémon $id');
    }
  }
}
