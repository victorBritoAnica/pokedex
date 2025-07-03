import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pokemon.dart';
import '../viewmodels/pokemon_view_model.dart';

class DetailScreen extends StatelessWidget {
  final int pokemonId;

  const DetailScreen({super.key, required this.pokemonId});

  @override
  Widget build(BuildContext context) {
    return Consumer<PokemonViewModel>(
      builder: (context, viewModel, _) {
        final pokemon = viewModel.pokemons.firstWhere(
          (p) => p.id == pokemonId,
          orElse: () => Pokemon(
            id: 0,
            name: 'Desconocido',
            imageUrl: '',
            description: 'No encontrado',
          ),
        );

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              pokemon.name.toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xFFb71c1c),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: viewModel.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : viewModel.errorMessage != null
              ? Center(
                  child: Text(
                    viewModel.errorMessage!,
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              : pokemon.id == 0
              ? const Center(
                  child: Text(
                    'Pokémon no encontrado',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 260,
                        width: 260,
                        decoration: BoxDecoration(
                          color: Colors.red.shade900.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.6),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Center(
                            child: Image.network(
                              pokemon.imageUrl,
                              fit: BoxFit.contain,
                              height: 240,
                              width: 240,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.error,
                                  size: 80,
                                  color: Colors.white,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        pokemon.description ?? 'Sin descripción disponible',
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
