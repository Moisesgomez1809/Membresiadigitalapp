import 'dart:ui';
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
  String contrasena = "";
  String confirmarContrasena = "";
  bool _mostrarContrasena = false;
  bool _mostrarConfirmacion = false;

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
                contrasena: contrasena,
              ),
        ),
      );
    }
  }

  void _regresar() {
    Navigator.pop(context);
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
                      _buildProgressIndicator(3),
                      SizedBox(height: 20),

                      // Formulario
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Text(
                                    "Datos de Cuenta",
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 255, 81, 0),
                                    ),
                                  ),
                                  SizedBox(height: 20),

                                  _buildEmailField(),

                                  _buildPasswordField(
                                    "Contraseña",
                                    _mostrarContrasena,
                                    (value) => _mostrarContrasena = value,
                                    onSaved: (v) => contrasena = v!,
                                    validator: _validatePassword,
                                  ),

                                  _buildPasswordField(
                                    "Confirmar contraseña",
                                    _mostrarConfirmacion,
                                    (value) => _mostrarConfirmacion = value,
                                    onSaved: (v) => confirmarContrasena = v!,
                                    validator: _validateConfirmPassword,
                                  ),

                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50]?.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.blue[200]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Requisitos de contraseña:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[800],
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "• Mínimo 8 caracteres\n• Al menos una mayúscula\n• Al menos un número\n• Al menos un carácter especial",
                                          style: TextStyle(
                                            color: Colors.blue[700],
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 20),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey[300],
                                            padding: EdgeInsets.symmetric(
                                              vertical: 15,
                                              horizontal:
                                                  8, // menos padding horizontal para móviles pequeños
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                          onPressed: _regresar,
                                          child: FittedBox(
                                            fit:
                                                BoxFit
                                                    .scaleDown, // ajusta el texto al ancho
                                            child: Text(
                                              "Anterior",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Color.fromARGB(
                                                  255,
                                                  60,
                                                  60,
                                                  60,
                                                ),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromARGB(
                                              255,
                                              255,
                                              255,
                                              255,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: 15,
                                              horizontal:
                                                  8, // menos padding horizontal
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                          onPressed: _continuar,
                                          child: FittedBox(
                                            fit:
                                                BoxFit
                                                    .scaleDown, // ajusta el texto al ancho
                                            child: Text(
                                              "Continuar",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Color.fromARGB(
                                                  255,
                                                  255,
                                                  81,
                                                  0,
                                                ),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: "Correo electrónico",
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
          // Nueva expresión regular corregida
          if (RegExp(
                r'^[\w\.-]+@[a-zA-Z\d-]+\.[a-zA-Z]{2,4}$',
              ).hasMatch(value) ==
              false) {
            return 'Ingrese un correo válido';
          }
          return null;
        },
        onSaved: (value) => correo = value!,
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    bool showPassword,
    Function(bool) onToggleVisibility, {
    required Function(String?) onSaved,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        obscureText: !showPassword,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: IconButton(
            icon: Icon(
              showPassword ? Icons.visibility_off : Icons.visibility,
              color: Color.fromARGB(255, 10, 65, 90),
            ),
            onPressed: () => setState(() => onToggleVisibility(!showPassword)),
          ),
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
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    if (value.length < 8) {
      return 'Mínimo 8 caracteres';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Debe contener al menos una mayúscula';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Debe contener al menos un número';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Debe contener al menos un carácter especial';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    if (value == contrasena) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }
}
