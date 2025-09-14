// lib/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

class SupabaseService {
  final SupabaseClient supabase = SupabaseClientManager.client;

  /// Registrar usuario en la tabla `usuarios`
  Future<String> registrarUsuario({
    required String correo,
    required String contrasena,
    required String nombre,
    required String tipo,
    String? edad,
    String? escuela,
    required String domicilio,
    required String fechadenac,
  }) async {
    final now = DateTime.now();
    final mes = now.month.toString().padLeft(2, '0');
    final anio = now.year.toString();
    final uuid =
        "${nombre.substring(0, 2).toUpperCase()}${contrasena.substring(0, 3).toUpperCase()}SH$mes$anio";

    final response =
        await supabase
            //con el from seleccionamos la tabla
            .from('usuarios')
            //con insert, insertamos la informacion "columna": dato a guardar
            .insert({
              'nombre': nombre,
              'edad': edad,
              'escuela': escuela,
              'domicilio': domicilio,
              'email': correo,
              'password': contrasena,
              'tipo': tipo,
              'uuid': uuid,
              'fechadenac': fechadenac,
            })
            .select()
            .maybeSingle();

    if (response == null) {
      throw Exception("Error al registrar usuario en la base de datos");
    }

    return uuid;
  }

  /// Iniciar sesión
  Future<Map<String, dynamic>?> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    try {
      final response =
          await supabase
              .from('usuarios')
              .select('uuid, nombre, visitas')
              .eq('email', correo)
              .eq('password', contrasena)
              .maybeSingle();

      if (response == null) return null;

      return {
        'uuid': response['uuid'] as String,
        'nombre': response['nombre'] as String,
        'visitas': response['visitas'] as int? ?? 0,
      };
    } catch (e) {
      return null;
    }
  }

  /// Obtener usuario por UUID
  Future<Map<String, dynamic>?> obtenerUsuarioPorUuid(String uuid) async {
    final res =
        await supabase.from('usuarios').select().eq('uuid', uuid).maybeSingle();

    if (res == null) return null;
    return res as Map<String, dynamic>?;
  }

  /// Incrementar visitas (optimizado: 1 sola query)
  Future<void> incrementarVisitas(String uuid) async {
    final response =
        await supabase
            .from('usuarios')
            .update({
              'visitas': Supabase.instance.client.rpc(
                'incrementar_visitas',
                params: {'uuid': uuid},
              ),
            })
            .eq('uuid', uuid)
            .select();

    if (response.isEmpty) {
      throw Exception("No se pudo actualizar las visitas del usuario");
    }
  }
}
