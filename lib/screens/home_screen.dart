import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../navigation/routes.dart';
import '../viewmodels/pokemon_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PokemonViewModel>(context);
    final pokemons = viewModel.pokemons;

    for (var pokemon in pokemons) {
      debugPrint('🟡 Pokémon: ${pokemon.name}');
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.detail);
          },
          child: const Text('Ir a Detalle'),
        ),
      ),
    );
  }
}
