// screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'services/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navegar();
  }

  void _navegar() async {
    // Espera 2 segundos para mostrar el splash screen
    await Future.delayed(const Duration(seconds: 2));

    // Verifica si ya se inicio anteriormente sesion
    final destino = await SesionManager.verificarSesion();

    // Navega y reemplaza la pantalla actual
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destino),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo blanco
          Container(decoration: const BoxDecoration(color: Colors.white)),

          // Contenido principal (logo centrado)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logov.png', width: 300),
                const SizedBox(height: 20),
                const CircularProgressIndicator(
                  color: Colors.deepOrange,
                ), // opcional
              ],
            ),
          ),
        ],
      ),
    );
  }
}
