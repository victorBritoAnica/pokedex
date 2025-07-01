import '../models/pokemon.dart';
import 'api_service.dart';
import 'database_service.dart';
import '../utils/result.dart';

class PokemonService {
  final ApiService apiService = ApiService();
  final DatabaseService dbService = DatabaseService.instance;

  Future<Result<List<Pokemon>>> getPokemons(int offset, int limit) async {
    try {
      // Primero intenta obtener de la base de datos local
      final localPokemons = await dbService.getPokemons(offset, limit);
      if (localPokemons.isNotEmpty) {
        return Success(localPokemons);
      }

      // Si no hay datos locales, obtiene de la API
      final result = await apiService.fetchPokemons(offset, limit);

      if (result is Success<List<Pokemon>>) {
        final pokemons = result.data;

        // Guarda en la base de datos local
        for (final pokemon in pokemons) {
          await dbService.insertOrUpdatePokemon(pokemon);
        }

        return Success(pokemons);
      } else if (result is Failure) {
        return result; // Propaga el error
      }

      return Failure('Respuesta desconocida al obtener los Pokémon');
    } catch (e) {
      return Failure('Error al obtener Pokémon: $e');
    }
  }

  Future<Result<List<Pokemon>>> searchPokemons(String query) async {
    try {
      final localResults = await dbService.searchPokemons(query);
      if (localResults.isNotEmpty) {
        return Success(localResults);
      }

      // Si no hay resultados locales, puedes hacer una búsqueda en API (opcional)
      return Success([]);
    } catch (e) {
      return Failure('Error al buscar Pokémon: $e');
    }
  }
}
