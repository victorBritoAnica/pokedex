import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../navigation/routes.dart';
import '../viewmodels/pokemon_view_model.dart';
import '../models/pokemon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  int _offset = 0;
  final int _limit = 20;
  String _searchQuery = '';
  bool _hasLoadedInitialData = false;

  @override
  void initState() {
    super.initState();

    // Función similar a la corrutina viewModelScope.launch {}, ejecuta después del primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasLoadedInitialData) {
        final viewModel = Provider.of<PokemonViewModel>(context, listen: false);
        viewModel.loadPokemons(offset: _offset, limit: _limit);
        _hasLoadedInitialData = true;
      }

      _scrollController.addListener(() {
        final viewModel = Provider.of<PokemonViewModel>(context, listen: false);

        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 200 &&
            !viewModel.isLoading) {
          _offset += _limit;
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
    final List<Pokemon> pokemons = _searchQuery.isEmpty
        ? viewModel.pokemons
        : viewModel.pokemons
              .where(
                (p) =>
                    p.name.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex'), backgroundColor: Colors.red),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar Pokémon',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
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
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.detail,
                      arguments: pokemon,
                    );
                  },
                  child: Card(
                    color: Colors.red[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          imageUrl: pokemon.imageUrl,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          height: 100,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '#${pokemon.id}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          pokemon.name.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (viewModel.isLoading)
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: CircularProgressIndicator(color: Colors.red),
            ),
        ],
      ),
    );
  }
}
