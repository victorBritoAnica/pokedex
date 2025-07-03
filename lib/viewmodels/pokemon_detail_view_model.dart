import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../utils/result.dart';

class PokemonDetailViewModel extends ChangeNotifier {
  final PokemonService _pokemonService = PokemonService();
  Pokemon? pokemon;
  String? errorMessage;
  bool isLoading = false;

  /// Obtiene el detalle del Pokémon desde la api
  Future<void> loadPokemonDetail(int id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _pokemonService.getPokemonDetail(id);

    if (result is Success<Pokemon>) {
      pokemon = result.data;
    } else if (result is Failure) {
      errorMessage = result.message;
    }

    isLoading = false;
    notifyListeners();
  }
}
