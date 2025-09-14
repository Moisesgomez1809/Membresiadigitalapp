import 'dart:ui';
import 'package:appmemberdigital/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../../services/shared_preferences.dart';
import '../../services/supabase_service.dart';

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
  final String contrasena;

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
    required this.contrasena,
  });

  @override
  createState() => _RegistroFase4State();
}

class _RegistroFase4State extends State<RegistroFase4> {
  bool _aceptaTerminos = false;
  bool _recibirNotificaciones = true;
  bool _isLoading = false;

  void _registrar() async {
    if (!_aceptaTerminos) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Debe aceptar los términos y condiciones"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final service = SupabaseService();

      // Crear el domicilio completo
      String domicilioCompleto = "${widget.calles}, Colonia ${widget.colonia}";

      String fechaOriginal = widget.fechaNacimiento;
      List<String> partes = fechaOriginal.split('/');

      // Convertimos a formato ISO: YYYY-MM-DD
      String fechaISO =
          "${partes[2].padLeft(4, '0')}-${partes[1].padLeft(2, '0')}-${partes[0].padLeft(2, '0')}";

      final uuid = await service.registrarUsuario(
        correo: widget.correo,
        contrasena: widget.contrasena,
        nombre: widget.nombre,
        tipo: widget.tipo,
        edad:
            widget.tipo == "Estudiante" ||
                    widget.tipo == "Padre" ||
                    widget.tipo == "Profesor"
                ? widget.edad
                : null,
        escuela: widget.tipo != "Padre" ? widget.escuela : null,
        domicilio: domicilioCompleto,
        fechadenac: fechaISO, // Nueva línea
      );
      final userData = {'uuid': uuid, 'nombre': widget.nombre, 'visitas': 0};
      await SesionManager.guardarSesion(userData);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  HomeScreen(uuid: uuid, nombre: widget.nombre, visitas: 0),
        ),
        (route) => false, // Elimina todas las rutas anteriores
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                      _buildProgressIndicator(4),
                      SizedBox(height: 20),

                      // Formulario de confirmación
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
                            child: Column(
                              children: [
                                Text(
                                  "Confirmar Registro",
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 255, 81, 0),
                                  ),
                                ),
                                SizedBox(height: 20),

                                // Resumen de datos
                                _buildSummaryCard(),

                                SizedBox(height: 20),

                                // Checkbox términos y condiciones
                                Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _aceptaTerminos,
                                            activeColor: Color.fromARGB(
                                              255,
                                              255,
                                              81,
                                              0,
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                _aceptaTerminos = value!;
                                              });
                                            },
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Acepto los términos y condiciones",
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
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _recibirNotificaciones,
                                            activeColor: Color.fromARGB(
                                              255,
                                              0,
                                              174,
                                              255,
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                _recibirNotificaciones = value!;
                                              });
                                            },
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Deseo recibir notificaciones",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Color.fromARGB(
                                                  255,
                                                  10,
                                                  65,
                                                  90,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
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
                                            vertical: 8,
                                            horizontal:
                                                8, // menos padding horizontal para móviles pequeños
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
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
                                            81,
                                            0,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 30,
                                            vertical: 8,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                        ),
                                        onPressed:
                                            _isLoading ? null : _registrar,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child:
                                              _isLoading
                                                  ? SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                            Color
                                                          >(Colors.white),
                                                    ),
                                                  )
                                                  : Text(
                                                    "Registrar",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
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

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color.fromARGB(255, 0, 174, 255).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Resumen de tu información:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 81, 0),
            ),
          ),
          SizedBox(height: 15),

          _buildSummaryItem("Tipo:", widget.tipo),
          _buildSummaryItem("Nombre:", widget.nombre),
          _buildSummaryItem("Fecha de nacimiento:", widget.fechaNacimiento),
          if (widget.tipo == "Estudiante")
            _buildSummaryItem("Edad:", "${widget.edad} años"),
          if (widget.tipo != "Padre" && widget.tipo != "Empresa")
            _buildSummaryItem("Escuela:", widget.escuela),
          _buildSummaryItem(
            "Domicilio:",
            "${widget.calles}, Col. ${widget.colonia}",
          ),
          _buildSummaryItem("Teléfono:", widget.telefono),
          _buildSummaryItem("Correo:", widget.correo),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 10, 65, 90),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Color.fromARGB(255, 60, 60, 60)),
            ),
          ),
        ],
      ),
    );
  }
}
