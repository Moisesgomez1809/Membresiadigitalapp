// lib/services/supabase_client.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientManager {
  // Cliente global que se usará en toda la app
  static final SupabaseClient client = Supabase.instance.client;
}
