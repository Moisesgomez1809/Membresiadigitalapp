import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
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
  List<String> colonias = [];
  bool isOtraColonia = false;

  @override
  void initState() {
    super.initState();
    _cargarColonias();
  }

  Future<void> _cargarColonias() async {
    final jsonString = await rootBundle.loadString('assets/col.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    setState(() {
      colonias = List<String>.from(data['colonias']);
    });
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
                      _buildProgressIndicator(2),
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
                                    "Domicilio y Contacto",
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 255, 81, 0),
                                    ),
                                  ),
                                  SizedBox(height: 20),

                                  // Campo de selección de colonia
                                  _buildColoniaField(),

                                  _buildField(
                                    "Calle(s) y número",
                                    maxLines: 2,
                                    onSaved: (v) => calles = v!,
                                  ),

                                  _buildField(
                                    "Número de teléfono",
                                    isNumber: true,
                                    maxLength: 10,
                                    onSaved: (v) => telefono = v!,
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

  Widget _buildColoniaField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            isExpanded: true, // esto evita overflow
            decoration: InputDecoration(
              labelText: "Colonia",
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
              fillColor: const Color.fromARGB(
                255,
                255,
                255,
                255,
              ).withOpacity(0.8),
            ),
            items: [
              ...colonias.map((colonia) {
                return DropdownMenuItem(value: colonia, child: Text(colonia));
              }),
              DropdownMenuItem(value: "Otra...", child: Text("Otra...")),
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
              if (!isOtraColonia) {
                colonia = value!;
              }
            },
            validator: (value) {
              if ((value == null || value.isEmpty) && !isOtraColonia) {
                return 'Seleccione una colonia';
              }
              if (isOtraColonia && (colonia.isEmpty)) {
                return 'Ingrese la colonia';
              }
              return null;
            },
          ),
          if (isOtraColonia)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Escribe tu colonia",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                ),
                onChanged: (value) => colonia = value,
                validator: (value) {
                  if (isOtraColonia && (value == null || value.isEmpty)) {
                    return 'Ingrese la colonia';
                  }
                  return null;
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildField(
    String label, {
    bool isPassword = false,
    bool isNumber = false,
    int? maxLength,
    int maxLines = 1,
    required Function(String?) onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLength: maxLength,
        maxLines: maxLines,
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
          if (isNumber && value.length != 10) {
            return 'Debe tener exactamente 10 dígitos';
          }
          return null;
        },
        onSaved: onSaved,
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
}
