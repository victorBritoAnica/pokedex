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
  final int _limit = 10; // Cuántos elementos cargar por página
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

      _scrollController.addListener(() {
        // 1. Obtener el ViewModel (gestor de estado)
        final viewModel = Provider.of<PokemonViewModel>(context, listen: false);

        // 2. Calcular si el scroll está cerca del final
        final isNearBottom =
            _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200;

        // 3. Si está cerca del final y no hay una carga en curso...
        if (isNearBottom && !viewModel.isLoading) {
          // 4. Aumentar el offset y cargar más datos
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
                (
                  p,
                ) => // hace la busqueda en tiempo real dentro del estado de pokemons guardados.
                    p.name.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Pokédex', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFb71c1c),
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFb71c1c), Color(0xFF000000)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
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
                        arguments: pokemon.id,
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
      ),
    );
  }
}
