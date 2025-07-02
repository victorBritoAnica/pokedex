import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../navigation/routes.dart';
import '../viewmodels/pokemon_view_model.dart';
import '../models/pokemon.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/search_bar.dart';
import '../widgets/pokemon_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  int _offset = 0; // Controla desde dónde pedir datos (paginación)
  final int _limit = 20; // Cuántos elementos cargar por página
  String _searchQuery = ''; // Texto de búsqueda actual
  bool _hasLoadedInitialData = false; // Para evitar múltiples cargas iniciales

  @override
  void initState() {
    super.initState();

    // Ejecuta después del primer frame (ideal para llamadas iniciales)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasLoadedInitialData) {
        final viewModel = Provider.of<PokemonViewModel>(context, listen: false);
        viewModel.loadPokemons(offset: _offset, limit: _limit);
        _hasLoadedInitialData = true;
      }

      // Listener que detecta si el usuario hace scroll hasta el fondo
      _scrollController.addListener(() {
        final viewModel = Provider.of<PokemonViewModel>(context, listen: false);
        final isNearBottom =
            _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200;

        if (isNearBottom && !viewModel.isLoading) {
          _offset += _limit; // Aumenta el offset para siguiente página
          viewModel.loadPokemons(offset: _offset, limit: _limit);
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PokemonViewModel>(context);

    // Filtra la lista si hay texto en la búsqueda
    final List<Pokemon> pokemons = _searchQuery.isEmpty
        ? viewModel.pokemons
        : viewModel.pokemons
              .where(
                (p) =>
                    p.name.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          SearchBarWidget(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: pokemons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final pokemon = pokemons[index];
                return PokemonCard(
                  pokemon: pokemon,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.detail,
                      arguments: pokemon,
                    );
                  },
                );
              },
            ),
          ),
          if (viewModel.isLoading)
            const Padding(
              padding: EdgeInsets.all(10),
              child: LoadingIndicator(),
            ),
        ],
      ),
    );
  }
}
