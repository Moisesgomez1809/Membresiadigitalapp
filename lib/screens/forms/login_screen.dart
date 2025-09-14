// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:appmemberdigital/screens/home_screen.dart';
import 'package:appmemberdigital/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import '../../services/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Size? circleSize;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final SupabaseService _supabaseService = SupabaseService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      circleSize = renderBox.size;
      setState(() {});
    });
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userData = await _supabaseService.iniciarSesion(
        correo: _emailController.text.trim(),
        contrasena: _passwordController.text.trim(),
      );

      if (userData != null) {
        await SesionManager.guardarSesion(userData);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => HomeScreen(
                  uuid: userData['uuid'],
                  nombre: userData['nombre'],
                  visitas: userData['visitas'],
                ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Correo o contraseña incorrectos'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error de conexión. Inténtalo de nuevo.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      // --- INICIO: CÓDIGO MODIFICADO ---
      // Se hace transparente para que se vea la imagen del Stack de fondo
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          // CAPA 1: IMAGEN DE FONDO
          Opacity(
            opacity: 0.05,
            child: Image.asset(
              'assets/imgfondo.png', // <-- CAMBIA ESTO por la ruta de tu imagen
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
              //opacity: const AlwaysStoppedAnimation(0.2),
            ),
          ),

          // CAPA 2: CONTENIDO ORIGINAL DE LA PANTALLA
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height:
                        isSmallScreen
                            ? screenHeight * 0.45
                            : screenHeight * 0.5,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: -screenHeight * 0.25,
                          left: -screenWidth * 0.25,
                          right: -screenWidth * 0.25,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              width: screenWidth * 1.4,
                              height: screenWidth * 1.4,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 255, 81, 0),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -screenHeight * 0.25,
                          left: -screenWidth * 0.25,
                          right: -screenWidth * 0.25,
                          child: Container(
                            width: screenWidth * 1.4,
                            height: screenWidth * 1.4,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 81, 0),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          top:
                              isSmallScreen
                                  ? screenHeight * 0.05
                                  : screenHeight * 0.08,
                          child: SizedBox(
                            width: screenWidth * 0.8,
                            height: screenWidth * 0.8,
                            child: Image.asset(
                              'assets/logo.png',
                              width: screenWidth * 0.6,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Contenido debajo del círculo
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.08,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Membresía Digital',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 28 : screenWidth * 0.09,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 0, 153, 255),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.0005),
                        Text(
                          'Bienvenido a tu tarjeta de membresía digital',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 12 : screenWidth * 0.04,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Column(
                          children: [
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Correo Electrónico',
                                floatingLabelStyle: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  color: Color.fromARGB(255, 255, 81, 0),
                                ),
                                helperText:
                                    'Ingresa el correo asociado a tu membresía',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(60),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(60),
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(60),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 0, 153, 255),
                                    width: 2.0,
                                  ),
                                ),
                                filled: true,
                                fillColor: const Color.fromARGB(
                                  255,
                                  248,
                                  248,
                                  248,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                helperText:
                                    'La contraseña asociada a tu membresía',
                                labelText: 'Contraseña',
                                floatingLabelStyle: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  color: Color.fromARGB(255, 255, 81, 0),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(60),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(60),
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(60),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 0, 153, 255),
                                    width: 2.0,
                                  ),
                                ),
                                filled: true,
                                fillColor: const Color.fromARGB(
                                  255,
                                  248,
                                  248,
                                  248,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        SizedBox(
                          width: screenWidth * 0.4,
                          height: screenHeight * 0.05,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                0,
                                153,
                                255,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child:
                                _isLoading
                                    ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Text(
                                      'INGRESAR',
                                      style: TextStyle(
                                        fontSize:
                                            isSmallScreen
                                                ? 16
                                                : screenWidth * 0.045,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.08),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // --- FIN: CÓDIGO MODIFICADO ---
    );
  }
}
