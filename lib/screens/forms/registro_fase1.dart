import 'dart:ui';
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
    // Establecer el tipo preseleccionado
    tipo = widget.tipoPreseleccionado;
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        fechaNacimiento = "${picked.day}/${picked.month}/${picked.year}";
        _fechaController.text = fechaNacimiento;

        // Calcular edad automáticamente
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
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Círculo de fondo
          Positioned(
            bottom: -250,
            left: -200,
            right: -200,
            child: Container(
              width: 800,
              height: 800,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 0, 204, 255),
                    Color.fromARGB(255, 2, 77, 175),
                  ],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Center(
                        child: Image.asset('assets/logov.png', width: 320),
                      ),
                      SizedBox(height: 20),

                      // Indicador de progreso
                      _buildProgressIndicator(1),
                      SizedBox(height: 20),

                      // Formulario
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              // ignore: deprecated_member_use
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                // ignore: deprecated_member_use
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Text(
                                    "Datos Personales",
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 255, 81, 0),
                                    ),
                                  ),
                                  SizedBox(height: 20),

                                  // Mostrar ocupación seleccionada (no editable)
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(
                                        255,
                                        0,
                                        174,
                                        255,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Color.fromARGB(
                                          255,
                                          250,
                                          250,
                                          250,
                                        ).withOpacity(0.3),
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: Color.fromARGB(
                                            255,
                                            248,
                                            248,
                                            248,
                                          ),
                                          size: 24,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "Ocupación: $tipo",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                              255,
                                              255,
                                              255,
                                              255,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),

                                  _buildField(
                                    "Nombre completo",
                                    onSaved: (v) => nombre = v!,
                                  ),

                                  GestureDetector(
                                    onTap: _seleccionarFecha,
                                    child: AbsorbPointer(
                                      child: _buildFieldWithController(
                                        "Fecha de nacimiento",
                                        _fechaController,
                                        suffixIcon: Icons.calendar_today,
                                        onSaved: (v) => fechaNacimiento = v!,
                                      ),
                                    ),
                                  ),

                                  if (edad.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(
                                            60,
                                          ),
                                        ),
                                        child: Text(
                                          "Edad: $edad años",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                              255,
                                              10,
                                              65,
                                              90,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                  if (tipo != "Padre" && tipo != "Empresa")
                                    _buildField(
                                      "Escuela",
                                      onSaved: (v) => escuela = v!,
                                    ),

                                  SizedBox(height: 20),

                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        255,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 50,
                                        vertical: 15,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: _continuar,
                                    child: Text(
                                      "Continuar",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color.fromARGB(255, 255, 81, 0),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(int currentStep) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          width: 40,
          height: 8,
          decoration: BoxDecoration(
            color:
                index < currentStep
                    ? Color.fromARGB(255, 255, 81, 0)
                    : Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildField(
    String label, {
    bool isPassword = false,
    bool isNumber = false,
    int? maxLength,
    required Function(String?) onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLength: maxLength,
        obscureText: isPassword,
        decoration: InputDecoration(
          counterText: "",
          labelText: label,
          floatingLabelStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Color.fromARGB(255, 10, 65, 90),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es requerido';
          }
          return null;
        },
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildFieldWithController(
    String label,
    TextEditingController controller, {
    IconData? suffixIcon,
    required Function(String?) onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
          floatingLabelStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Color.fromARGB(255, 10, 65, 90),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es requerido';
          }
          return null;
        },
        onSaved: onSaved,
      ),
    );
  }
}
