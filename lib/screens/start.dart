// start.dart

import 'package:flutter/material.dart';
import 'package:appmemberdigital/screens/Selec_ocupacion.dart';
import 'package:appmemberdigital/screens/forms/login_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    // Datos de pantalla
    final size = MediaQuery.of(context).size;
    final width = size.width;

    // Ajuste de fuente según ancho
    double fontSize = width * 0.06; // 6% del ancho de pantalla
    if (fontSize > 25) fontSize = 25; // límite superior

    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          SizedBox.expand(
            child: Image.asset('assets/mockupstart.png', fit: BoxFit.cover),
          ),
          // Gradient encima
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 4, 52, 107),
                  const Color.fromARGB(255, 9, 54, 145).withValues(alpha: 0.75),
                  const Color.fromARGB(90, 103, 169, 255),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          // Contenido en la parte inferior
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end, // manda todo al fondo
                crossAxisAlignment: CrossAxisAlignment.start, // alineación izq
                children: [
                  // Animación de texto RESPONSIVA
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        RotateAnimatedText(
                          'BIENVENIDO',
                          textStyle: TextStyle(fontSize: 35),
                          textAlign: TextAlign.center,
                          duration: const Duration(milliseconds: 3000),
                        ),
                        RotateAnimatedText(
                          'SE PARTE DEL CAMBIO\nCON NOSOTROS',
                          textAlign: TextAlign.center,
                          duration: const Duration(milliseconds: 3000),
                        ),
                        RotateAnimatedText(
                          'CON TU MEMBRESIA DIGITAL\nDEL SHADDAI PAPELERIA',
                          textAlign: TextAlign.center,
                          duration: const Duration(milliseconds: 3000),
                        ),
                      ],
                      pause: const Duration(milliseconds: 500),
                      repeatForever: true,
                      stopPauseOnTap: false,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Botones
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color.fromARGB(255, 236, 95, 13),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Iniciar Sesión',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Selec_ocupacion(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 94, 0),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Registrarme',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
