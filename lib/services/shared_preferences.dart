import 'package:appmemberdigital/screens/main_screen.dart';
import 'package:appmemberdigital/screens/start.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:appmemberdigital/services/supabase_service.dart'; // 👈 Importar tu servicio

class SesionManager {
  // Instancia del servicio de Supabase
  static final SupabaseService _supabaseService = SupabaseService();

  // Guardar sesión después de login/registro
  static Future<void> guardarSesion(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uuid', userData['uuid']);
    await prefs.setString('nombre', userData['nombre']);
    await prefs.setInt('visitas', userData['visitas'] ?? 0);
    await prefs.setBool('isLoggedIn', true);
    // Establecer el tiempo inicial para el throttle de 15 min
    await prefs.setInt('lastUpdate', DateTime.now().millisecondsSinceEpoch);
  }

  // 🔥 VERIFICAR SESIÓN CON ACTUALIZACIÓN AUTOMÁTICA DE VISITAS
  static Future<Widget> verificarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      final uuid = prefs.getString('uuid')!;
      final nombre = prefs.getString('nombre')!;
      int visitasLocales = prefs.getInt('visitas') ?? 0;

      // 🚀 Actualizar visitas solo si han pasado más de 15 minutos (opcional para reducir carga)
      try {
        final lastUpdate = prefs.getInt('lastUpdate') ?? 0;
        final now = DateTime.now().millisecondsSinceEpoch;

        if (now - lastUpdate > 900000) {
          // 900,000 ms = 15 minutos
          final visitasActualizadas = await _supabaseService.obtenerVisitas(
            uuid,
          );

          if (visitasActualizadas != null &&
              visitasActualizadas != visitasLocales) {
            await prefs.setInt('visitas', visitasActualizadas);
            await prefs.setInt('lastUpdate', now);
            visitasLocales = visitasActualizadas;
          } else if (visitasActualizadas != null) {
            await prefs.setInt('lastUpdate', now);
          }
        }
      } catch (e) {
        debugPrint('⚠️ Error actualizando visitas (usando datos locales): $e');
      }

      return MainScreen(uuid: uuid, nombre: nombre, visitas: visitasLocales);
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

  // 🆕 MÉTODO BONUS: Para actualizar visitas manualmente (opcional)
  static Future<bool> actualizarVisitas(String uuid) async {
    try {
      final visitasNuevas = await _supabaseService.obtenerVisitas(uuid);
      if (visitasNuevas != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('visitas', visitasNuevas);
        await prefs.setInt('lastUpdate', DateTime.now().millisecondsSinceEpoch);
        return true;
      }
      return false;
    } catch (e) {
      //print('Error actualizando visitas manualmente: $e');
      return false;
    }
  }
}
