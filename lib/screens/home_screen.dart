import 'package:flutter/material.dart';
import '../navigation/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // este tipo de navegación agrega la siguiente pantalla a la pila de navegación
            Navigator.pushNamed(context, Routes.detail);
          },
          child: Text('Ir a Detalle'),
        ),
      ),
    );
  }
}
