import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../navigation/routes.dart';
import '../viewmodels/pokemon_view_model.dart';
import '../widgets/loading_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      _loadData();
    });
  }

  /// Llama al ViewModel para cargar los Pokémon y navega hacia home
  Future<void> _loadData() async {
    final viewModel = Provider.of<PokemonViewModel>(context, listen: false);
    await viewModel.loadPokemons();

    // Este tipo de navegación borra el screen de la pila
    Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFb71c1c), Color(0xFF000000)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 7,
              child: Center(
                child: Image.asset(
                  'assets/images/pokedex.png',
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const LoadingIndicator(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
