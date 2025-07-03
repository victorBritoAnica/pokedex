import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';
import '../utils/result.dart';

class ApiService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2';

  /// Obtiene lista paginada de Pokémon básicos
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

  /// Obtiene el detalle completo de un Pokémon, incluyendo descripción
  Future<Result<Pokemon>> fetchPokemonDetail(int id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/pokemon/$id'));
      debugPrint('$_baseUrl/pokemon/$id');
      if (response.statusCode != 200) {
        return Failure('Error ${response.statusCode}');
      }

      final data = json.decode(response.body);

      // Obtener URL del species para sacar la descripción
      final speciesUrl = data['species']['url'];
      final speciesResponse = await http.get(Uri.parse(speciesUrl));
      debugPrint(speciesUrl);
      String description = '';
      if (speciesResponse.statusCode == 200) {
        final speciesData = json.decode(speciesResponse.body);
        final flavorEntry = (speciesData['flavor_text_entries'] as List)
            .firstWhere(
              (entry) => entry['language']['name'] == 'es',
              orElse: () => {'flavor_text': 'Sin descripción disponible'},
            );
        description = flavorEntry['flavor_text'];
      }

      final pokemon = Pokemon.fromFullJson(data, description);
      return Success(pokemon);
    } catch (e) {
      return Failure('Error al obtener detalle: $e');
    }
  }
}
