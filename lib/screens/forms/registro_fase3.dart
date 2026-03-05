import 'package:flutter/material.dart';
import 'registro_fase4.dart';

class RegistroFase3 extends StatefulWidget {
  final String tipo;
  final String nombre;
  final String fechaNacimiento;
  final String edad;
  final String escuela;
  final String colonia;
  final String calles;
  final String telefono;

  const RegistroFase3({
    super.key,
    required this.tipo,
    required this.nombre,
    required this.fechaNacimiento,
    required this.edad,
    required this.escuela,
    required this.colonia,
    required this.calles,
    required this.telefono,
  });

  @override
  createState() => _RegistroFase3State();
}

class _RegistroFase3State extends State<RegistroFase3> {
  final _formKey = GlobalKey<FormState>();
  String correo = "";
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _mostrarContrasena = false;
  bool _mostrarConfirmacion = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _continuar() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => RegistroFase4(
                tipo: widget.tipo,
                nombre: widget.nombre,
                fechaNacimiento: widget.fechaNacimiento,
                edad: widget.edad,
                escuela: widget.escuela,
                colonia: widget.colonia,
                calles: widget.calles,
                telefono: widget.telefono,
                correo: correo,
                password: _passwordController.text.trim(),
              ),
        ),
      );
    }
  }

  void _regresar() => Navigator.pop(context);

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';
    if (value.length < 8) return 'Mínimo 8 caracteres';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Falta una mayúscula';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Falta un número';
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value))
      return 'Falta un carácter especial';
    return null;
  }

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
            top: -100,
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
            bottom: 200,
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

                    _buildStepIndicator(3),
                    const SizedBox(height: 32),

                    _buildFormCard(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Datos de Cuenta",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF00AEFF),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const Text(
                              "Para tu acceso al sistema",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 24),

                            _buildField(
                              label: "Correo electrónico",
                              icon: Icons.alternate_email_outlined,
                              onSaved: (v) => correo = v!,
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Campo requerido';
                                if (!RegExp(
                                  r'^[\w\.-]+@[a-zA-Z\d-]+\.[a-zA-Z]{2,4}$',
                                ).hasMatch(v)) {
                                  return 'Ingrese un correo válido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            _buildPasswordField(
                              label: "Contraseña",
                              controller: _passwordController,
                              showPassword: _mostrarContrasena,
                              onToggle:
                                  (v) => setState(() => _mostrarContrasena = v),
                              validator: _validatePassword,
                            ),
                            const SizedBox(height: 16),

                            _buildPasswordField(
                              label: "Confirmar contraseña",
                              controller: _confirmPasswordController,
                              showPassword: _mostrarConfirmacion,
                              onToggle:
                                  (v) =>
                                      setState(() => _mostrarConfirmacion = v),
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Campo requerido';
                                if (v != _passwordController.text)
                                  return 'Las contraseñas no coinciden';
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),
                            _buildRequirementBox(),

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
                                    text: "Continuar",
                                    onPressed: _continuar,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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

  Widget _buildField({
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    Function(String?)? onSaved,
  }) {
    return TextFormField(
      onSaved: onSaved,
      validator: validator,
      style: const TextStyle(color: Color(0xFF0A415A), fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        floatingLabelStyle: const TextStyle(
          color: Color(0xFF00AEFF),
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(icon, color: Colors.grey[400], size: 22),
        filled: true,
        fillColor: Colors.grey.withValues(alpha: 0.05),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF00AEFF), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool showPassword,
    required Function(bool) onToggle,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !showPassword,
      validator: validator,
      style: const TextStyle(color: Color(0xFF0A415A), fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        floatingLabelStyle: const TextStyle(
          color: Color(0xFF00AEFF),
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400], size: 22),
        suffixIcon: IconButton(
          icon: Icon(
            showPassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.grey[400],
            size: 20,
          ),
          onPressed: () => onToggle(!showPassword),
        ),
        filled: true,
        fillColor: Colors.grey.withValues(alpha: 0.05),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF00AEFF), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
    );
  }

  Widget _buildRequirementBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF00AEFF).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00AEFF).withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF00AEFF), size: 18),
              SizedBox(width: 8),
              Text(
                "Seguridad de tu contraseña:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00AEFF),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _requirementItem("Mínimo 8 caracteres"),
          _requirementItem("Al menos una mayúscula y un número"),
          _requirementItem("Al menos un carácter especial"),
        ],
      ),
    );
  }

  Widget _requirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Color(0xFF00AEFF),
            size: 14,
          ),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onPressed,
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
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
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
