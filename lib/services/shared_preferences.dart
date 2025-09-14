import 'package:appmemberdigital/screens/start.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appmemberdigital/screens/home_screen.dart';
import 'package:flutter/material.dart';

class SesionManager {
  // Guardar sesión después de login/registro
  static Future<void> guardarSesion(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uuid', userData['uuid']);
    await prefs.setString('nombre', userData['nombre']);
    await prefs.setInt('visitas', userData['visitas'] ?? 0);
    await prefs.setBool('isLoggedIn', true);
  }

  // Verificar sesión al abrir la app
  static Future<Widget> verificarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      final uuid = prefs.getString('uuid')!;
      final nombre = prefs.getString('nombre')!;
      final visitas = prefs.getInt('visitas') ?? 0;
      return HomeScreen(uuid: uuid, nombre: nombre, visitas: visitas);
    } else {
      return const StartScreen();
    }
  }

  // Cerrar sesión
  static Future<void> cerrarSesion(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const StartScreen()),
      (route) => false,
    );
  }
}
