import 'package:appmemberdigital/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart'; // 👈 agregado

class HomeScreen extends StatefulWidget {
  final String uuid;
  final String nombre;
  final int visitas;

  const HomeScreen({
    super.key,
    required this.uuid,
    required this.nombre,
    required this.visitas,
  });

  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  void _flipCard() {
    if (isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    isFront = !isFront;
  }

  // --- INICIO: CÓDIGO AGREGADO ---
  // Función para mostrar el diálogo de confirmación de cierre de sesión.
  void _mostrarDialogoCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text(
            "Confirmar Cierre de Sesión",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("¿Estás seguro de que quieres cerrar tu sesión?"),
                SizedBox(height: 15),
                Text(
                  "Te recomendamos mantener tu sesión iniciada para un acceso más rápido y una mejor experiencia.",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                SizedBox(height: 10),
                Text(
                  "Solo cierra la sesión si el equipo de mantenimiento te lo ha indicado.",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Cierra el diálogo
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                "Confirmar",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                SesionManager.cerrarSesion(context);
              },
            ),
          ],
        );
      },
    );
  }

  // --- FIN: CÓDIGO AGREGADO ---

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Variables responsive
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;

    // Definir metas y tarjetas según visitas
    String cardImage = "assets/Cards/card_basic.png";
    int meta = 50;
    String progresoTexto = "";
    bool mostrarBarra = true;
    bool nivelMaximo = false;

    if (widget.visitas <= 50) {
      cardImage = "assets/Cards/card_basic.png";
      meta = 50;
      progresoTexto = "De $meta visitas te faltan ${meta - widget.visitas}";
    } else if (widget.visitas > 50 && widget.visitas < 100) {
      cardImage = "assets/Cards/card_frequent.png";
      meta = 100;
      progresoTexto = "De $meta visitas te faltan ${meta - widget.visitas}";
    } else {
      cardImage = "assets/Cards/card_loyal.png";
      mostrarBarra = false;
      nivelMaximo = true;
    }

    final double progreso =
        nivelMaximo ? 1.0 : (widget.visitas / meta).clamp(0, 1).toDouble();

    final bool activa = widget.visitas > 0;

    // --- Beneficios dinámicos ---
    List<Map<String, dynamic>> beneficios = [];
    if (widget.visitas <= 50) {
      beneficios = [
        {
          "icon": Icons.local_offer,
          "texto": "Promociones en útiles y papelería",
        },
        {"icon": Icons.new_releases, "texto": "Aviso de nuevos productos"},
        {"icon": Icons.support_agent, "texto": "Soporte básico"},
      ];
    } else if (widget.visitas > 50 && widget.visitas < 100) {
      beneficios = [
        {
          "icon": Icons.discount,
          "texto": "5% en compras mayores a \$200 en efectivo",
        },
        {"icon": Icons.trending_up, "texto": "Más puntos en compras grandes"},
        {"icon": Icons.new_releases, "texto": "Aviso de nuevos productos"},
        {"icon": Icons.local_offer, "texto": "Descuentos de temporada"},
        {"icon": Icons.support_agent, "texto": "Soporte prioritario"},
      ];
    } else {
      beneficios = [
        {
          "icon": Icons.discount,
          "texto": "10% en compras mayores a \$100 en efectivo",
        },
        {
          "icon": Icons.credit_card,
          "texto": "5% en compras mayores a \$100 con tarjeta",
        },
        {"icon": Icons.brush, "texto": "5% en personalización de productos"},
        {"icon": Icons.notifications_active, "texto": "Avisos anticipados"},
        {"icon": Icons.star, "texto": "Promociones exclusivas"},
        {"icon": Icons.support_agent, "texto": "Soporte prioritario"},
      ];
    }
    // --- Gradientes dinámicos según card ---
    LinearGradient getGradientByCard(String cardType) {
      switch (cardType) {
        case "basic":
          return const LinearGradient(
            colors: [
              Color.fromARGB(255, 42, 166, 255),
              Color(0xFF1ed4e7),
            ], // Azul
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
        case "frequent":
          return const LinearGradient(
            colors: [
              Color(0xFF25b5f4),
              Color.fromARGB(255, 31, 211, 148),
            ], // Verde
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
        case "loyal":
          return const LinearGradient(
            colors: [Color(0xFFEF6C00), Color(0xFFf5c025)], // Naranja
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
        default:
          return const LinearGradient(
            colors: [Colors.grey, Colors.blueGrey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,

        // 👈 Botón de soporte a la izquierda
        leading: IconButton(
          icon: Icon(Icons.support_agent, color: Colors.grey[700]),
          tooltip: 'Soporte',
          onPressed: () async {
            const url = 'https://wa.link/p80v21'; //  wa.link aquí
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(
                Uri.parse(url),
                mode: LaunchMode.externalApplication,
              );
            }
          },
        ),
        title: const Text(
          "Mi Membresía",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 81, 0),
          ),
        ),
        centerTitle: true,
        // 👉 Botón de cerrar sesión a la derecha
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.grey[700]),
            tooltip: 'Cerrar Sesión',
            onPressed: () {
              _mostrarDialogoCerrarSesion(context);
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.02),

              // Logo
              Center(
                child: Image.asset(
                  'assets/logov.png',
                  width: isSmallScreen ? screenWidth * 0.2 : screenWidth * 0.3,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: screenHeight * 0.025),

              // Tarjeta con animación flip
              GestureDetector(
                onTap: _flipCard,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    final angle = _animation.value * pi;
                    final isFrontVisible = angle < pi / 2;

                    return Transform(
                      alignment: Alignment.center,
                      transform:
                          Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(angle),
                      child:
                          isFrontVisible
                              ? Image.asset(
                                cardImage,
                                width: screenWidth * 0.85,
                              )
                              : Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()..rotateY(pi),
                                child: Container(
                                  width: screenWidth * 0.85,
                                  height: screenWidth * 0.55,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withValues(
                                          alpha: .3,
                                        ),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        QrImageView(
                                          data: widget.uuid,
                                          size: screenWidth * 0.4,
                                        ),
                                        SizedBox(height: screenHeight * 0.015),
                                        Text(
                                          widget.uuid,
                                          style: TextStyle(
                                            fontSize:
                                                isSmallScreen
                                                    ? 12
                                                    : screenWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                    );
                  },
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Estado de la membresía
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: activa ? Colors.green : Colors.grey,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    activa
                        ? "Su membresía está activa"
                        : "Su membresía aún no está activada",
                    style: TextStyle(
                      color: activa ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.02),

              // Semestre dinámico (por ahora fijo)
              Text(
                "Julio-Diciembre",
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 81, 0),
                  fontSize: isSmallScreen ? 20 : screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Barra de progreso o nivel máximo
              if (mostrarBarra) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: LinearPercentIndicator(
                    linearGradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 24, 65, 179),
                        Color.fromARGB(255, 58, 189, 241),
                      ],
                    ),
                    barRadius: const Radius.circular(20),
                    lineHeight: isSmallScreen ? 35.0 : 30.0,
                    percent: progreso,
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  progresoTexto,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 81, 0),
                    fontSize: isSmallScreen ? 12 : screenWidth * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] else if (nivelMaximo) ...[
                Text(
                  "🎉 Nivel Máximo 🎉",
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontSize: isSmallScreen ? 20 : screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Felicidades, ahora eres nivel Loyal.\nGracias por creer y confiar en nuestra calidad y servicio.",
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: isSmallScreen ? 14 : screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              SizedBox(height: screenHeight * 0.003),
              // --- Separador visual ---
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                height: 5,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: getGradientByCard(
                    cardImage.contains("basic")
                        ? "basic"
                        : cardImage.contains("frequent")
                        ? "frequent"
                        : "loyal",
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // --- Sección de beneficios ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 15,
                ),
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: .1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título alineado a la izquierda
                    Text(
                      "Beneficios de tu nivel",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[900],
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Lista de beneficios
                    Column(
                      children:
                          beneficios.map((b) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  // Icono dentro de un cuadrito con gradiente
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      gradient: getGradientByCard(
                                        cardImage.contains("basic")
                                            ? "basic"
                                            : cardImage.contains("frequent")
                                            ? "frequent"
                                            : "loyal",
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      b["icon"],
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Texto del beneficio
                                  Expanded(
                                    child: Text(
                                      b["texto"],
                                      style: TextStyle(
                                        fontSize:
                                            isSmallScreen
                                                ? 13
                                                : screenWidth * 0.04,
                                        color: const Color.fromARGB(
                                          255,
                                          6,
                                          42,
                                          77,
                                        ),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.15),
            ],
          ),
        ),
      ),
    );
  }
}
