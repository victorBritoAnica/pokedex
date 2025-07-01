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
  Future<void> loadPokemons({int offset = 0, int limit = 20}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _pokemonService.getPokemons(offset, limit);

    if (result is Success<List<Pokemon>>) {
      pokemons = result.data;
    } else if (result is Failure) {
      errorMessage = result.message;
    }

    isLoading = false;
    notifyListeners();
  }
}
