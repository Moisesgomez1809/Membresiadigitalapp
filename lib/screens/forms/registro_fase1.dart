import 'package:flutter/material.dart';
import 'registro_fase2.dart';

class RegistroFase1 extends StatefulWidget {
  final String tipoPreseleccionado;

  const RegistroFase1({super.key, required this.tipoPreseleccionado});

  @override
  createState() => _RegistroFase1State();
}

class _RegistroFase1State extends State<RegistroFase1> {
  final _formKey = GlobalKey<FormState>();
  String tipo = "";
  String nombre = "";
  String fechaNacimiento = "";
  String edad = "";
  String escuela = "";

  final TextEditingController _fechaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tipo = widget.tipoPreseleccionado;
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00AEFF),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0A415A),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        // Formato para la Base de Datos (ISO: YYYY-MM-DD)
        fechaNacimiento =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        // Formato para que el usuario lo vea (DD/MM/YYYY)
        _fechaController.text = "${picked.day}/${picked.month}/${picked.year}";

        final now = DateTime.now();
        int calculatedAge = now.year - picked.year;
        if (now.month < picked.month ||
            (now.month == picked.month && now.day < picked.day)) {
          calculatedAge--;
        }
        edad = calculatedAge.toString();
      });
    }
  }

  void _continuar() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => RegistroFase2(
                tipo: tipo,
                nombre: nombre,
                fechaNacimiento: fechaNacimiento,
                edad: edad,
                escuela: escuela,
              ),
        ),
      );
    }
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
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00AEFF).withValues(alpha: 0.08),
                    const Color(0xFF00AEFF).withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -100,
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

                    _buildStepIndicator(1),
                    const SizedBox(height: 32),

                    _buildFormCard(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Datos Personales",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF00AEFF),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const Text(
                              "Cuéntanos un poco sobre ti",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 24),

                            _buildInfoChip(
                              Icons.person_outline,
                              "Ocupación: $tipo",
                            ),
                            const SizedBox(height: 20),

                            _buildField(
                              label: "Nombre completo",
                              icon: Icons.person_outline,
                              onSaved: (v) => nombre = v!,
                            ),
                            const SizedBox(height: 16),

                            GestureDetector(
                              onTap: _seleccionarFecha,
                              child: AbsorbPointer(
                                child: _buildField(
                                  label: "Fecha de nacimiento",
                                  icon: Icons.calendar_month_outlined,
                                  controller: _fechaController,
                                  onSaved: (v) => fechaNacimiento = v!,
                                ),
                              ),
                            ),

                            if (edad.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              _buildInfoChip(
                                Icons.cake_outlined,
                                "Edad: $edad años",
                              ),
                            ],

                            if (tipo != "Padre" && tipo != "Empresa") ...[
                              const SizedBox(height: 16),
                              _buildField(
                                label: "Escuela",
                                icon: Icons.school_outlined,
                                onSaved: (v) => escuela = v!,
                              ),
                            ],

                            const SizedBox(height: 32),

                            _buildPrimaryButton(
                              text: "Continuar",
                              onPressed: _continuar,
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

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF00AEFF).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00AEFF).withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF00AEFF), size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF00AEFF),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required IconData icon,
    TextEditingController? controller,
    Function(String?)? onSaved,
  }) {
    return TextFormField(
      controller: controller,
      onSaved: onSaved,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
      validator: (v) => v == null || v.isEmpty ? "Campo obligatorio" : null,
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF00AEFF), Color(0xFF0088FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00AEFF).withValues(alpha: 0.3),
            blurRadius: 12,
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
}
