import 'package:flutter/material.dart';
import 'package:appmemberdigital/services/supabase_service.dart';
import 'package:appmemberdigital/services/shared_preferences.dart';
import '../main_screen.dart';

class RegistroFase4 extends StatefulWidget {
  final String tipo;
  final String nombre;
  final String fechaNacimiento;
  final String edad;
  final String escuela;
  final String colonia;
  final String calles;
  final String telefono;
  final String correo;
  final String password;

  const RegistroFase4({
    super.key,
    required this.tipo,
    required this.nombre,
    required this.fechaNacimiento,
    required this.edad,
    required this.escuela,
    required this.colonia,
    required this.calles,
    required this.telefono,
    required this.correo,
    required this.password,
  });

  @override
  createState() => _RegistroFase4State();
}

class _RegistroFase4State extends State<RegistroFase4> {
  bool _aceptoTerminos = false;
  bool _esMayorEdad = false;
  bool _cargando = false;

  Future<void> _finalizarRegistro() async {
    if (!_aceptoTerminos || !_esMayorEdad) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Debes aceptar todos los términos"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _cargando = true);

    try {
      final SupabaseService supabaseService = SupabaseService();
      final String uuid = await supabaseService.registrarUsuario(
        correo: widget.correo,
        contrasena: widget.password,
        nombre: widget.nombre,
        tipo: widget.tipo,
        edad: widget.edad,
        escuela: widget.escuela,
        domicilio: "${widget.colonia}, ${widget.calles}",
        fechadenac: widget.fechaNacimiento,
      );

      // Guardar sesión
      await SesionManager.guardarSesion({
        'uuid': uuid,
        'nombre': widget.nombre,
        'visitas': 0,
      });

      if (mounted) {
        setState(() => _cargando = false);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 80,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "¡Registro Exitoso!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00AEFF),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Tu cuenta ha sido creada correctamente.",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00AEFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          // Navegar al home y limpiar stack
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder:
                                  (context) => MainScreen(
                                    uuid: uuid,
                                    nombre: widget.nombre,
                                    visitas: 0,
                                  ),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text(
                          "Comenzar",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _cargando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al registrar: $e"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _regresar() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background Elements
          Positioned(
            top: 200,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00AEFF).withValues(alpha: 0.1),
                    const Color(0xFF00AEFF).withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00AEFF).withValues(alpha: 0.12),
                    const Color(0xFF00AEFF).withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight - 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Hero(
                        tag: 'logo',
                        child: Image.asset('assets/logov.png', width: 220),
                      ),
                    ),
                    const SizedBox(height: 40),

                    _buildStepIndicator(4),
                    const SizedBox(height: 32),

                    _buildFormCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Resumen de Registro",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF00AEFF),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const Text(
                            "Verifica que todo sea correcto",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 24),

                          _buildSummaryTicket(),
                          const SizedBox(height: 24),

                          _buildCheckboxTile(
                            "Acepto los términos y condiciones de uso del sistema.",
                            _aceptoTerminos,
                            (v) => setState(() => _aceptoTerminos = v!),
                          ),
                          _buildCheckboxTile(
                            "Confirmo que soy mayor de edad.",
                            _esMayorEdad,
                            (v) => setState(() => _esMayorEdad = v!),
                          ),

                          const SizedBox(height: 32),

                          Row(
                            children: [
                              Expanded(
                                child: _buildSecondaryButton(
                                  text: "Anterior",
                                  onPressed: _regresar,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildPrimaryButton(
                                  text: "Finalizar",
                                  onPressed: _finalizarRegistro,
                                  loading: _cargando,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _buildFormCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1), width: 1),
      ),
      child: child,
    );
  }

  Widget _buildStepIndicator(int currentStep) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        bool isActive = index < currentStep;
        return Container(
          width: 40,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color:
                isActive
                    ? const Color(0xFF00AEFF)
                    : Colors.grey.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }

  Widget _buildSummaryTicket() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF00AEFF).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00AEFF).withValues(alpha: 0.12),
          width: 1.5,
        ),
        image: DecorationImage(
          image: const AssetImage('assets/watermark.png'), // Opcional si tienes
          opacity: 0.05,
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          _summaryRow("Nombre:", widget.nombre),
          _divider(),
          _summaryRow("Ocupación:", widget.tipo),
          _divider(),
          _summaryRow(
            "Fecha Nac:",
            widget.fechaNacimiento.contains('-')
                ? widget.fechaNacimiento.split('-').reversed.join('/')
                : widget.fechaNacimiento,
          ),
          _divider(),
          _summaryRow("Teléfono:", widget.telefono),
          _divider(),
          _summaryRow("Colonia:", widget.colonia),
          _divider(),
          _summaryRow("Correo:", widget.correo),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Color(0xFF0A415A),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: List.generate(
          40,
          (index) => Expanded(
            child: Container(
              color:
                  index % 2 == 0
                      ? Colors.transparent
                      : Colors.grey.withValues(alpha: 0.3),
              height: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxTile(
    String label,
    bool value,
    Function(bool?) onChanged,
  ) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Text(
        label,
        style: TextStyle(color: Colors.grey[700], fontSize: 13),
      ),
      activeColor: const Color(0xFF00AEFF),
      checkColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onPressed,
    bool loading = false,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF00AEFF), Color(0xFF0088FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00AEFF).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child:
            loading
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                : Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.1,
                  ),
                ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }
}
