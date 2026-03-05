import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'registro_fase3.dart';

class RegistroFase2 extends StatefulWidget {
  final String tipo;
  final String nombre;
  final String fechaNacimiento;
  final String edad;
  final String escuela;

  const RegistroFase2({
    super.key,
    required this.tipo,
    required this.nombre,
    required this.fechaNacimiento,
    required this.edad,
    required this.escuela,
  });

  @override
  createState() => _RegistroFase2State();
}

class _RegistroFase2State extends State<RegistroFase2> {
  final _formKey = GlobalKey<FormState>();
  String colonia = "";
  String calles = "";
  String telefono = "";
  bool isOtraColonia = false;
  List<String> _coloniasJson = [];
  bool _cargandoColonias = true;

  @override
  void initState() {
    super.initState();
    _cargarColonias();
  }

  Future<void> _cargarColonias() async {
    try {
      final String response = await rootBundle.loadString('assets/col.json');
      final data = await json.decode(response);
      setState(() {
        _coloniasJson = List<String>.from(data['colonias']);
        _coloniasJson.sort((a, b) => a.compareTo(b));
        _cargandoColonias = false;
      });
    } catch (e) {
      debugPrint("Error cargando colonias: $e");
      setState(() {
        _coloniasJson = ["Centro"]; // Fallback básico
        _cargandoColonias = false;
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
              (context) => RegistroFase3(
                tipo: widget.tipo,
                nombre: widget.nombre,
                fechaNacimiento: widget.fechaNacimiento,
                edad: widget.edad,
                escuela: widget.escuela,
                colonia: colonia,
                calles: calles,
                telefono: telefono,
              ),
        ),
      );
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
            bottom: -150,
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

                    _buildStepIndicator(2),
                    const SizedBox(height: 32),

                    _buildFormCard(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Domicilio y Contacto",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF00AEFF),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const Text(
                              "¿Dónde te podemos encontrar?",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 24),

                            _buildColoniaDropdown(),
                            if (isOtraColonia) ...[
                              const SizedBox(height: 16),
                              _buildField(
                                label: "Escribe tu colonia",
                                icon: Icons.location_city_outlined,
                                onSaved: (v) => colonia = v!,
                                onChanged: (v) => colonia = v,
                              ),
                            ],
                            const SizedBox(height: 16),

                            _buildField(
                              label: "Calle(s) y número",
                              icon: Icons.map_outlined,
                              maxLines: 2,
                              onSaved: (v) => calles = v!,
                            ),
                            const SizedBox(height: 16),

                            _buildField(
                              label: "Número de teléfono",
                              icon: Icons.phone_android_outlined,
                              isNumber: true,
                              maxLength: 10,
                              onSaved: (v) => telefono = v!,
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

  Widget _buildColoniaDropdown() {
    if (_cargandoColonias) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF00AEFF),
              ),
            ),
            SizedBox(width: 15),
            Text("Cargando colonias...", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return DropdownButtonFormField<String>(
      isExpanded: true,
      dropdownColor: Colors.white,
      style: const TextStyle(color: Color(0xFF0A415A), fontSize: 16),
      decoration: InputDecoration(
        labelText: "Colonia",
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        floatingLabelStyle: const TextStyle(
          color: Color(0xFF00AEFF),
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(
          Icons.business_outlined,
          color: Colors.grey[400],
          size: 22,
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
      items: [
        ..._coloniasJson.map(
          (col) => DropdownMenuItem(
            value: col,
            child: Text(col, overflow: TextOverflow.ellipsis),
          ),
        ),
        const DropdownMenuItem(value: "Otra...", child: Text("Otra...")),
      ],
      onChanged: (value) {
        setState(() {
          if (value == "Otra...") {
            isOtraColonia = true;
            colonia = "";
          } else {
            isOtraColonia = false;
            colonia = value!;
          }
        });
      },
      onSaved: (value) {
        if (!isOtraColonia) colonia = value ?? "";
      },
      validator: (v) {
        if ((v == null || v.isEmpty) && !isOtraColonia)
          return 'Seleccione una colonia';
        if (isOtraColonia && (colonia.isEmpty)) return 'Ingrese la colonia';
        return null;
      },
    );
  }

  Widget _buildField({
    required String label,
    required IconData icon,
    int maxLines = 1,
    int? maxLength,
    bool isNumber = false,
    Function(String?)? onSaved,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      onSaved: onSaved,
      onChanged: onChanged,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Color(0xFF0A415A), fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        counterText: "",
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
      validator: (v) {
        if (v == null || v.isEmpty) return "Campo obligatorio";
        if (isNumber && v.length != 10) return "Debe tener 10 dígitos";
        return null;
      },
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
