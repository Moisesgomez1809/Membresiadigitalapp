import 'package:appmemberdigital/screens/forms/registro_fase1.dart';
import 'package:flutter/material.dart';

class SelecOcupacion extends StatefulWidget {
  const SelecOcupacion({super.key});

  @override
  createState() => _Selec_ocupacionState();
}

// ignore: camel_case_types
class _Selec_ocupacionState extends State<SelecOcupacion> {
  @override
  void initState() {
    super.initState();
  }

  // Método para navegar al registro con el tipo seleccionado
  void _navigateToRegistro(String tipoOcupacion) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistroFase1(tipoPreseleccionado: tipoOcupacion),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/logov.png',
                  width: MediaQuery.of(context).size.width * 0.6,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Text(
            textAlign: TextAlign.center,
            "Para una mejor experiencia y beneficios \n selecciona 1 de las 4 opciones\n segun tu ocupacion.",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 255, 123, 0),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          SizedBox(
            width: screenWidth * 0.5,
            height: screenHeight * 0.05,
            child: ElevatedButton(
              onPressed: () => _navigateToRegistro("Estudiante"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 243, 243, 243),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(55),
                ),
              ),
              child: Text(
                'Estudiante',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 111, 15),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          SizedBox(
            width: screenWidth * 0.5,
            height: screenHeight * 0.05,
            child: ElevatedButton(
              onPressed: () => _navigateToRegistro("Profesor"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 243, 243, 243),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(55),
                ),
              ),
              child: Text(
                'Profesor',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 111, 15),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          SizedBox(
            width: screenWidth * 0.5,
            height: screenHeight * 0.05,
            child: ElevatedButton(
              onPressed: () => _navigateToRegistro("Padre"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 243, 243, 243),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(55),
                ),
              ),
              child: Text(
                'Padre/Tutor',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 111, 15),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          SizedBox(
            width: screenWidth * 0.5,
            height: screenHeight * 0.05,
            child: ElevatedButton(
              onPressed: () => _navigateToRegistro("Empresa"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 243, 243, 243),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(55),
                ),
              ),
              child: Text(
                'Empresa',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 111, 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
