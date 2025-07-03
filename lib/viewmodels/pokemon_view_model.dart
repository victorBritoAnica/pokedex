import 'package:flutter/foundation.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../utils/result.dart';

/// Gestiona el estado de los Pokémon para la UI.
class PokemonViewModel extends ChangeNotifier {
  final PokemonService _pokemonService = PokemonService();
  List<Pokemon> pokemons = [];
  String? errorMessage;
  bool isLoading = false;

  /// Carga Pokémon paginados desde la API o caché.
  Future<void> loadPokemons({int offset = 0, int limit = 10}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    debugPrint('Cargando Pokémon desde ViewModel...');

    final result = await _pokemonService.getPokemons(offset, limit);

    if (result is Success<List<Pokemon>>) {
      //evita que se agreguen al estado del arreglo pokemons repetidos
      final newPokemons = result.data
          .where(
            (newP) => !pokemons.any((existingP) => existingP.id == newP.id),
          )
          .toList();
      pokemons.addAll(newPokemons);
    } else if (result is Failure) {
      errorMessage = result.message;
    }

    isLoading = false;
    notifyListeners();
  }
}
