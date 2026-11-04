import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math' show Random;
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

// ==========================================
// CONFIGURACIÓN GLOBAL
// ==========================================
const String urlBackend = 'https://nexo-backend-3-xhb2.onrender.com';

class AppStrings {  
  static Map<String, Map<String, String>> traducciones = {
    'es': {
      'titulo_app': 'Nexo - Salud Mental',
      'bienvenido': '¡En el caos o en la calma, Nexo te acompaña!',
    },
    'en': {
      'titulo_app': 'Nexo - Mental Health',
      'bienvenido': 'In chaos or in calm, Nexo is with you!',
    }
  };

  static String obtener(String idioma, String clave) {
    return traducciones[idioma]?[clave] ?? traducciones['es']![clave]!;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBhHPS1FIfIylG9LYMuqrcuet37cOCfHyo",
      authDomain: "nexo-bc5bd.firebaseapp.com",
      projectId: "nexo-bc5bd",
      storageBucket: "nexo-bc5bd.firebasestorage.app",
      messagingSenderId: "572587873896",
      appId: "1:572587873896:web:f534b46117bce766d80ddd",
    ),
  );
  
  runApp(const NexoApp());
}

class NexoApp extends StatelessWidget {
  const NexoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nexo: Tu Espacio Seguro',
      theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: const Color(0xFFF8FAFC)),
      home: const PantallaLanding(),
    );
  }
}

// ==========================================
// 0. PÁGINA DE INICIO (LANDING PAGE)
// ==========================================
class PantallaLanding extends StatelessWidget {
  const PantallaLanding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.shield_moon, size: 80, color: Color(0xFF38BDF8)),
              const SizedBox(height: 20),
              const Text("NEXO", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 8)),
              const SizedBox(height: 10),
              const Text("Tu Espacio Seguro de Salud Mental", style: TextStyle(fontSize: 20, color: Color(0xFF38BDF8), fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              const SizedBox(
                width: 600,
                child: Text(
                  "Nexo es una herramienta de apoyo emocional diseñada para acompañarte en momentos de ansiedad o crisis. Incluye ejercicios de respiración, arte terapia, diario de desahogo, audios relajantes y un asistente de apoyo 24/7.", 
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5)
                ),
              ),
              const SizedBox(height: 40),
              
              // Mensaje oficial solicitado
              Container(
                margin: const EdgeInsets.only(bottom: 25),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF38BDF8).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.3)),
                ),
                child: const Text(
                  "Puedes instalar Nexo en tu celular o computadora desde Mi Perfil, en \"Descarga la Aplicación\".",
                  style: TextStyle(fontSize: 14, color: Color(0xFF38BDF8), fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF38BDF8), foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5
                ),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PantallaBienvenida())),
                icon: const Icon(Icons.rocket_launch, size: 28),
                label: const Text("ENTRAR A NEXO", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 1. PANTALLA DE BIENVENIDA
// ==========================================
class PantallaBienvenida extends StatelessWidget {
  const PantallaBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              const Icon(Icons.shield_moon, size: 100, color: Color(0xFF38BDF8)),
              const SizedBox(height: 20),
              const Text("NEXO", style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 5)),
              const SizedBox(height: 10),
              const Text("En el caos o en la calma, Nexo te acompaña", style: TextStyle(fontSize: 16, color: Colors.white70, fontStyle: FontStyle.italic)),
              const SizedBox(height: 60),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF38BDF8), foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 5
                ),
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PantallaDeCarga())),
                child: const Text("INICIAR", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2)),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text("© 2026 Creado por FRANCISCO JAVIER NERI LOPEZ\nTodos los derechos reservados", textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 12)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. PANTALLA DE CARGA
// ==========================================
class PantallaDeCarga extends StatefulWidget {
  const PantallaDeCarga({super.key});
  @override
  State<PantallaDeCarga> createState() => _PantallaDeCargaState();
}
class _PantallaDeCargaState extends State<PantallaDeCarga> {
  final List<String> frases = ["Respira profundo...", "Estás en un lugar seguro.", "La ansiedad no te define.", "Todo va a estar bien."];
  int indiceFrase = 0;
  Timer? timer;
  
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 1800), (t) async {
      if (mounted) {
        if (indiceFrase < frases.length - 1) { 
          setState(() { indiceFrase++; });
        } else { 
          t.cancel(); 
          await verificarEstadoUsuario();
        }
      }
    });
  }

  Future<void> verificarEstadoUsuario() async {
    User? usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PantallaLogin()));
      return;
    }

    try {
      DocumentReference userDoc = FirebaseFirestore.instance.collection('usuarios').doc(usuario.uid);
      DocumentSnapshot doc = await userDoc.get();

      if (!doc.exists) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PantallaLogin()));
        return;
      }

      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HubPrincipal()));
      }
    } catch (e) {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HubPrincipal()));
      }
    }
  }

  @override
  void dispose() { timer?.cancel(); super.dispose(); }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(child: Padding(padding: const EdgeInsets.all(30.0), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const CircularProgressIndicator(color: Color(0xFF38BDF8)), const SizedBox(height: 40),
        AnimatedSwitcher(duration: const Duration(milliseconds: 800), child: Text(frases[indiceFrase], key: ValueKey(indiceFrase), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 22, fontStyle: FontStyle.italic))),
      ]))),
    );
  }
}

// ==========================================
// 3. PANTALLA DE LOGIN (Corregida para cualquier cuenta)
// ==========================================
class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});
  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}
class _PantallaLoginState extends State<PantallaLogin> {
  bool cargandoAutenticacion = false;

  Future<void> iniciarSesionConGoogle() async {
    setState(() => cargandoAutenticacion = true);
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      UserCredential credential = await FirebaseAuth.instance.signInWithPopup(googleProvider);
      
      User? usuario = credential.user;

      if (usuario != null) {
        DocumentReference userDoc = FirebaseFirestore.instance.collection('usuarios').doc(usuario.uid);
        DocumentSnapshot doc = await userDoc.get();

        if (!doc.exists) {
          await userDoc.set({
            'nombre': usuario.displayName ?? 'Usuario',
            'email': usuario.email ?? '',
            'fecha_registro': FieldValue.serverTimestamp(),
          });
        }
      }

      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HubPrincipal()));
      }
    } catch (e) {
      if (mounted) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al iniciar sesión: $e"))); }
    } finally {
      if (mounted) setState(() => cargandoAutenticacion = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_sync, size: 80, color: Color(0xFF3B82F6)), 
                const SizedBox(height: 20),
                const Text("Únete a la Comunidad Nexo", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))), 
                const SizedBox(height: 15),
                const Text("Regístrate gratis para guardar tu progreso, personalizar tus ejercicios y acceder desde cualquier dispositivo.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color(0xFF64748B))), 
                const SizedBox(height: 40),
                if (cargandoAutenticacion) const CircularProgressIndicator()
                else ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, foregroundColor: Colors.black87, 
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                    ),
                    onPressed: iniciarSesionConGoogle, 
                    icon: Image.network("https://cdn-icons-png.flaticon.com/512/2991/2991148.png", width: 24, height: 24), 
                    label: const Text("Continuar con Google", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PantallaPrivacidad())),
                  child: const Text("Al continuar aceptas el aviso de privacidad. Léelo aquí.", textAlign: TextAlign.center, style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B), decoration: TextDecoration.underline)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 5. HUB PRINCIPAL
// ==========================================
class HubPrincipal extends StatefulWidget {
  const HubPrincipal({super.key});

  @override
  State<HubPrincipal> createState() => _HubPrincipalState();
}

class _HubPrincipalState extends State<HubPrincipal> {

  void _abrirPantalla(Widget destino) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => destino));
  }

  Future<void> _llamarAyuda() async {
    final Uri tel = Uri(scheme: 'tel', path: '8009112000');
    if (await canLaunchUrl(tel)) {
      await launchUrl(tel);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Marca 800 911 2000 (Línea de la Vida, gratuita, 24 horas).")));
    }
  }

  Widget _tarjetaAyuda() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFECDD3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.support_agent, color: Color(0xFFBE123C)),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              "¿Necesitas hablar con alguien? Línea de la Vida: 800 911 2000 (gratuita, 24 h).",
              style: TextStyle(fontSize: 12.5, color: Color(0xFF881337), height: 1.3),
            ),
          ),
          TextButton(onPressed: _llamarAyuda, child: const Text("Llamar")),
        ],
      ),
    );
  }

  void _activarSOS() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [Icon(Icons.warning_amber_rounded, color: Colors.red, size: 30), SizedBox(width: 10), Text("Alerta S.O.S", style: TextStyle(color: Colors.red))]),
        content: const Text("Esto abrirá WhatsApp con un mensaje preescrito de auxilio para enviarlo a tu contacto de confianza.\n\n¿Deseas activar la alerta ahora?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(context);
              final Uri url = Uri.parse('https://wa.me/?text=¡Hola!+Necesito+ayuda,+estoy+pasando+por+un+momento+de+crisis+de+ansiedad.+Por+favor+comunícate+conmigo.');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No se pudo abrir WhatsApp.")));
              }
            }, 
            child: const Text("SÍ, ACTIVAR S.O.S")
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nexo", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        backgroundColor: Colors.transparent, elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 32, color: Color(0xFF3B82F6)), 
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PantallaMiCuenta()))
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("¿Qué necesitas hoy?", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 15),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 4
                ),
                onPressed: _activarSOS, 
                icon: const Icon(Icons.sos, size: 28), 
                label: const Text("BOTÓN DE EMERGENCIA S.O.S", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.5))
              ),
              
              const SizedBox(height: 12),
              _tarjetaAyuda(),

              const SizedBox(height: 25),
              const Text("Herramientas de Rescate", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 15),
              GridView.count(
                shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15,
                children: [
                  _botonHub(context, "Modo Casa", Icons.home, const Color(0xFF2DD4BF), const MenuModoCasa()),
                  _botonHub(context, "Modo Calle", Icons.directions_walk, const Color(0xFFD97757), const MenuModoCalle()),
                  _botonHub(context, "Arte Terapia", Icons.palette, const Color(0xFFEC4899), const CatalogoMandalas()),
                  _botonHub(context, "Juegos", Icons.videogame_asset, const Color(0xFF8B5CF6), const CatalogoJuegos()),
                ],
              ),
              const SizedBox(height: 30),
              
              const Row(
                children: [
                  Icon(Icons.apps, color: Color(0xFF6366F1)), SizedBox(width: 8),
                  Text("Más herramientas", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                ],
              ),
              const SizedBox(height: 15),
              
              GridView.count(
                shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 1.2,
                children: [
                  _botonHerramienta(context, "Estadísticas", Icons.bar_chart, const PantallaEstadisticas(), const Color(0xFF818CF8)),
                  _botonHerramienta(context, "Terapeuta IA", Icons.smart_toy, const PantallaChatbotIA(), const Color(0xFF6366F1)),
                  _botonHerramienta(context, "Catálogo de Audios", Icons.headset, const PantallaAudios(), const Color(0xFF8B5CF6)),
                ],
              ),

              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE), 
                  borderRadius: BorderRadius.circular(20), 
                  border: Border.all(color: const Color(0xFFBAE6FD))
                ),
                child: Column(
                  children: [
                    const Icon(Icons.forum, color: Color(0xFF0284C7), size: 35),
                    const SizedBox(height: 10),
                    const Text("¿Qué te parece Nexo?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF075985))),
                    const SizedBox(height: 5),
                    const Text("Tu opinión es súper importante para seguir mejorando esta herramienta. ¡Déjanos un comentario!", textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF0C4A6E))),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7), 
                        foregroundColor: Colors.white, 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                      ),
                      onPressed: () async {
                        final Uri urlFeedback = Uri.parse('https://forms.gle/HPwn5KzNp9sJATD78'); 
                        if (await canLaunchUrl(urlFeedback)) {
                          await launchUrl(urlFeedback, mode: LaunchMode.externalApplication);
                        }
                      }, 
                      icon: const Icon(Icons.feedback, size: 18), 
                      label: const Text("Enviar comentario")
                    )
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Text("Aprende sobre tu mente", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 15),
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PantallaBiblioteca())),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity, padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: const Color(0xFF3B82F6), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))]),
                  child: const Row(children: [
                    Icon(Icons.menu_book, size: 40, color: Colors.white), SizedBox(width: 20),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text("Biblioteca de Calma", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)), SizedBox(height: 5),
                      Text("Libros y canales recomendados.", style: TextStyle(fontSize: 13, color: Colors.white70)),
                    ])),
                    Icon(Icons.arrow_forward_ios, color: Colors.white70)
                  ]),
                ),
              ),

              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 15),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFFED7AA))),
                child: const Column(
                  children: [
                    Icon(Icons.volunteer_activism, color: Color(0xFFEA580C), size: 30),
                    SizedBox(height: 10),
                    Text("Nexo es una herramienta de apoyo, no un sustituto de la terapia.", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF9A3412), fontSize: 14)),
                    SizedBox(height: 10),
                    Text("Si tus ataques de ansiedad son frecuentes, te recomendamos hablarlo con tus familiares y buscar la ayuda de un profesional de la salud mental. No estás solo.", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF9A3412), fontSize: 13, height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _botonHub(BuildContext context, String titulo, IconData icono, Color color, Widget destino) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => destino)), borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))]),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icono, size: 45, color: Colors.white), const SizedBox(height: 15), Text(titulo, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))]),
      ),
    );
  }

  Widget _botonHerramienta(BuildContext context, String titulo, IconData icono, Widget destino, Color color) {
    return InkWell(
      onTap: () => _abrirPantalla(destino), borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color, color.withOpacity(0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))]
        ),
        child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icono, size: 35, color: Colors.white), const SizedBox(height: 10), Text(titulo, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white))])),
      ),
    );
  }
}

// ==========================================
// 6. MI CUENTA Y DESCARGAS
// ==========================================
class PantallaMiCuenta extends StatelessWidget {
  const PantallaMiCuenta({super.key});

  void _instrucciones(BuildContext context, String titulo, String texto) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(titulo),
        content: Text(texto, style: const TextStyle(height: 1.5)),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Entendido"))],
      ),
    );
  }

  // Borra el historial, el perfil y la cuenta de la persona (con confirmación).
  Future<void> _eliminarCuenta(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("¿Eliminar tu cuenta?"),
        content: const Text("Se borrarán tu cuenta y todo tu historial de ansiedad. Esta acción no se puede deshacer."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancelar")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Sí, eliminar"),
          ),
        ],
      ),
    );
    if (confirmar != true) return;

    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) return;

    try {
      // Firebase exige haber iniciado sesión hace poco para borrar una cuenta.
      await usuario.reauthenticateWithPopup(GoogleAuthProvider());

      final refUsuario = FirebaseFirestore.instance.collection('usuarios').doc(usuario.uid);
      final historial = await refUsuario.collection('historial_ansiedad').get();
      for (final doc in historial.docs) {
        await doc.reference.delete();
      }
      await refUsuario.delete();
      await usuario.delete();

      navigator.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const PantallaLogin()), (route) => false);
      messenger.showSnackBar(const SnackBar(content: Text("Tu cuenta y tus datos fueron eliminados.")));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text("No se pudo eliminar la cuenta: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    User? usuarioActual = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Mi Perfil")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (usuarioActual != null) ...[
              CircleAvatar(radius: 50, backgroundImage: usuarioActual.photoURL != null ? NetworkImage(usuarioActual.photoURL!) : null, child: usuarioActual.photoURL == null ? const Icon(Icons.person, size: 50) : null),
              const SizedBox(height: 15),
              Text("¡Hola, ${usuarioActual.displayName ?? 'Usuario'}!", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(usuarioActual.email ?? "", style: const TextStyle(color: Colors.grey, fontSize: 16)), 
              const SizedBox(height: 30),
              OutlinedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const PantallaLogin()), (route) => false);
                  }
                }, 
                icon: const Icon(Icons.logout, color: Colors.red), label: const Text("Cerrar Sesión", style: TextStyle(color: Colors.red))
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PantallaPrivacidad())),
                icon: const Icon(Icons.privacy_tip_outlined),
                label: const Text("Aviso de privacidad"),
              ),
              TextButton.icon(
                onPressed: () => _eliminarCuenta(context),
                icon: const Icon(Icons.delete_forever, color: Colors.red),
                label: const Text("Eliminar mi cuenta y mis datos", style: TextStyle(color: Colors.red)),
              ),
            ],
            
            const Divider(height: 50),
            
            const Text("Descarga la Aplicación", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () { 
                    _instrucciones(context, "Instalar en Android", "Abre Nexo en Chrome. Toca el menú (⋮) y elige \"Instalar app\" o \"Agregar a pantalla de inicio\". Quedará con su ícono, como cualquier otra app."); 
                  }, 
                  icon: const Icon(Icons.android, color: Colors.green), 
                  label: const Text("Android")
                )
              ), 
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () { 
                    _instrucciones(context, "Instalar en iPhone", "Abre Nexo en Safari. Toca el botón Compartir (el cuadro con una flecha hacia arriba) y elige \"Agregar a pantalla de inicio\". Quedará con su ícono, como cualquier otra app."); 
                  }, 
                  icon: const Icon(Icons.apple, color: Colors.black), 
                  label: const Text("iOS")
                )
              ), 
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () { 
                    _instrucciones(context, "Instalar en computadora", "Abre Nexo en Chrome o Edge. En la barra de direcciones toca el ícono de instalar (una pantalla con una flecha), o abre el menú (⋮) y elige \"Instalar Nexo\". Se abrirá en su propia ventana, con su ícono en el escritorio o en el menú de inicio."); 
                  }, 
                  icon: const Icon(Icons.desktop_windows, color: Colors.blue), 
                  label: const Text("PC")
                )
              ),
            ])
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 7. CATÁLOGOS CON MÁNDALAS Y JUEGOS
// ==========================================
class CatalogoMandalas extends StatelessWidget {
  const CatalogoMandalas({super.key});

  void _abrir(BuildContext context, String tipo) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PantallaMandala(tipo: tipo)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Catálogo de Mándalas"), backgroundColor: const Color(0xFFFBCFE8), foregroundColor: const Color(0xFF831843)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _tarjetaCatalogo(context, "Estrella de Calma", Icons.star_border, () => _abrir(context, "estrella")),
          _tarjetaCatalogo(context, "Flor Abstracta", Icons.local_florist_outlined, () => _abrir(context, "flor")),
          _tarjetaCatalogo(context, "Geometría Sagrada", Icons.hexagon_outlined, () => _abrir(context, "geometria")),
          _tarjetaCatalogo(context, "Espiral Infinito", Icons.cyclone, () => _abrir(context, "espiral")),
          _tarjetaCatalogo(context, "Roseta Mística", Icons.filter_vintage, () => _abrir(context, "roseta")),
          _tarjetaCatalogo(context, "Círculos Complejos", Icons.blur_circular, () => _abrir(context, "circulos")),
        ],
      ),
    );
  }
}

class CatalogoJuegos extends StatelessWidget {
  const CatalogoJuegos({super.key});

  void _abrir(BuildContext context, Widget destino) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => destino));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Juegos Antiestrés"), backgroundColor: const Color(0xFFDDD6FE), foregroundColor: const Color(0xFF4C1D95)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _tarjetaCatalogo(context, "Pop-It (Burbujas)", Icons.bubble_chart, () => _abrir(context, const PantallaJuegoBurbujas())),
          _tarjetaCatalogo(context, "Trazar el Infinito", Icons.all_inclusive, () => _abrir(context, const PantallaJuegoInfinito())),
          _tarjetaCatalogo(context, "Caza-Puntos Visual", Icons.gps_fixed, () => _abrir(context, const PantallaJuegoPuntos())),
          _tarjetaCatalogo(context, "Cielo Estrellado", Icons.nightlight_round, () => _abrir(context, const PantallaCieloEstrellado())),
          _tarjetaCatalogo(context, "Toques de Calma", Icons.touch_app, () => _abrir(context, const PantallaJuegoToques())),
          _tarjetaCatalogo(context, "Pared de Presión", Icons.vibration, () => _abrir(context, const PantallaJuegoPresion())),
        ],
      ),
    );
  }
}

Widget _tarjetaCatalogo(BuildContext context, String titulo, IconData icono, VoidCallback onTap) {
  return Card(
    margin: const EdgeInsets.only(bottom: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: ListTile(
      contentPadding: const EdgeInsets.all(15), 
      leading: Icon(icono, size: 40, color: Colors.blueGrey),
      title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)), 
      trailing: const Icon(Icons.play_arrow, color: Colors.teal),
      onTap: onTap,
    ),
  );
}

// ==========================================
// 8. CIELO ESTRELLADO
// ==========================================
class PantallaCieloEstrellado extends StatefulWidget {
  const PantallaCieloEstrellado({super.key});
  @override
  State<PantallaCieloEstrellado> createState() => _PantallaCieloEstrelladoState();
}
class _PantallaCieloEstrelladoState extends State<PantallaCieloEstrellado> {
  List<Offset> estrellas = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(title: const Text("Cielo Estrellado"), backgroundColor: Colors.transparent, foregroundColor: Colors.white, elevation: 0),
      body: GestureDetector(
        onTapDown: (TapDownDetails details) { setState(() { estrellas.add(details.localPosition); }); },
        child: Stack(
          children: [
            Container(color: Colors.transparent, width: double.infinity, height: double.infinity),
            const Positioned(top: 20, left: 20, right: 20, child: Text("Toca cualquier parte de la pantalla para encender una estrella. Concéntrate en llenar el cielo.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 16))),
            ...estrellas.map((pos) => Positioned(left: pos.dx - 12, top: pos.dy - 12, child: const Icon(Icons.star, color: Colors.yellowAccent, size: 24, shadows: [Shadow(color: Colors.yellow, blurRadius: 10)]))),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.white24, onPressed: () => setState(() => estrellas.clear()), child: const Icon(Icons.cleaning_services, color: Colors.white)),
    );
  }
}

// ==========================================
// 9. BIBLIOTECA DE CALMA
// ==========================================
class PantallaBiblioteca extends StatelessWidget {
  const PantallaBiblioteca({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text("Biblioteca de Calma"), backgroundColor: const Color(0xFFDBEAFE), foregroundColor: const Color(0xFF1E40AF)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("Entender lo que sientes es el primer paso para dominarlo. Aquí tienes recursos recomendados:", style: TextStyle(fontSize: 16, color: Color(0xFF475569))), const SizedBox(height: 30),
          const Row(children: [Icon(Icons.menu_book, color: Color(0xFF3B82F6)), SizedBox(width: 10), Text("Libros Recomendados", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)))]), const SizedBox(height: 15),
          _itemBiblioteca("Deshacer la ansiedad", "Judson Brewer", "Explica cómo la ansiedad es un hábito que se puede desaprender mediante mindfulness.", Icons.book),
          _itemBiblioteca("El cerebro del niño", "Daniel J. Siegel", "Excelente para entender cómo nuestras emociones dominan la lógica y cómo reconectarlas.", Icons.book),
          _itemBiblioteca("El hombre en busca de sentido", "Viktor Frankl", "Un clásico sobre cómo encontrar propósito en medio del sufrimiento mental.", Icons.book),
          const SizedBox(height: 30),
          const Row(children: [Icon(Icons.play_circle_filled, color: Colors.red), SizedBox(width: 10), Text("Canales de YouTube", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)))]), const SizedBox(height: 15),
          _itemBiblioteca("Desansiedad", "Psicología Clínica", "Fabiola Cuevas explica paso a paso qué hacer durante un ataque de pánico.", Icons.video_library),
          _itemBiblioteca("AMAD", "Apoyo Emocional", "Comunidad dedicada a brindar herramientas prácticas para el día a día.", Icons.video_library),
        ],
      ),
    );
  }
  Widget _itemBiblioteca(String titulo, String subtitulo, String descripcion, IconData icono) {
    return Card(
      elevation: 1, color: Colors.white, margin: const EdgeInsets.only(bottom: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              CircleAvatar(backgroundColor: const Color(0xFFDBEAFE), child: Icon(icono, color: const Color(0xFF2563EB))), const SizedBox(width: 15),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text(subtitulo, style: const TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.w600, fontSize: 12))])),
            ]),
            const SizedBox(height: 10),
            Text(descripcion, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, height: 1.4)),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 10. SLIDER DE ANSIEDAD
// ==========================================
class PantallaSliderAnsiedad extends StatefulWidget {
  final String contexto;
  const PantallaSliderAnsiedad({super.key, required this.contexto});
  @override
  State<PantallaSliderAnsiedad> createState() => _PantallaSliderAnsiedadState();
}
class _PantallaSliderAnsiedadState extends State<PantallaSliderAnsiedad> {
  double nivelAnsiedad = 5;

  Future<void> guardarNivelEnBaseDeDatos(int nivel) async {
    User? usuario = FirebaseAuth.instance.currentUser;
    if (usuario != null) {
      await FirebaseFirestore.instance.collection('usuarios').doc(usuario.uid).collection('historial_ansiedad').add({
        'nivel': nivel,
        'contexto': widget.contexto,
        'fecha': FieldValue.serverTimestamp(),
      });
    }
  }

  Color obtenerColorNivel() {
    if (nivelAnsiedad <= 3) return Colors.green;
    if (nivelAnsiedad <= 7) return Colors.orange;
    return Colors.red;
  }
  String obtenerMensaje() {
    if (nivelAnsiedad <= 3) return "Inquietud Leve";
    if (nivelAnsiedad <= 7) return "Ansiedad Moderada";
    return "Pico de Ansiedad / Crisis";
  }

  @override
  Widget build(BuildContext context) {
    bool esCasa = widget.contexto == "casa";
    return Scaffold(
      backgroundColor: esCasa ? const Color(0xFFF0FDF4) : const Color(0xFFFFF7ED),
      appBar: AppBar(title: const Text("Medición Emocional"), backgroundColor: esCasa ? const Color(0xFF99F6E4) : const Color(0xFFFED7AA)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("¿Qué tan intenso es lo que sientes ahora?", textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 40),
              Text(nivelAnsiedad.toInt().toString(), style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: obtenerColorNivel())),
              Text(obtenerMensaje(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)), const SizedBox(height: 40),
              Slider(value: nivelAnsiedad, min: 1, max: 10, divisions: 9, activeColor: obtenerColorNivel(), onChanged: (val) => setState(() => nivelAnsiedad = val)),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("1 (Calma)"), Text("10 (Pánico)")])),
              const SizedBox(height: 60),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: obtenerColorNivel(), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                onPressed: () async {
                  await guardarNivelEnBaseDeDatos(nivelAnsiedad.toInt());
                  if (context.mounted) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PantallaEjercicios(contexto: widget.contexto, nivelUsuario: nivelAnsiedad.toInt())));
                  }
                },
                icon: const Icon(Icons.arrow_forward), label: const Text("Continuar a Ejercicios", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 11. MENÚS DE MODO CASA Y MODO CALLE
// ==========================================
class MenuModoCasa extends StatelessWidget {
  const MenuModoCasa({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      appBar: AppBar(title: const Text("🏠 Modo Casa"), backgroundColor: const Color(0xFF99F6E4), foregroundColor: const Color(0xFF134E4A)),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _tarjetaMenu(context, "Ejercicios Adaptables", "Regulación según tu intensidad.", Icons.self_improvement, const Color(0xFF38BDF8), const PantallaSliderAnsiedad(contexto: "casa")),
          const SizedBox(height: 12),
          _tarjetaMenu(context, "Mindfulness", "Respiración guiada animada.", Icons.spa, const Color(0xFF2DD4BF), const PantallaMindfulness()),
          const SizedBox(height: 12),
          _tarjetaMenu(context, "Diario de Desahogo", "Exagera tus pensamientos.", Icons.edit_note, const Color(0xFF818CF8), const PantallaDesahogo()),
        ],
      ),
    );
  }
}

class MenuModoCalle extends StatelessWidget {
  const MenuModoCalle({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7ED),
      appBar: AppBar(title: const Text("🚶 Modo Calle"), backgroundColor: const Color(0xFFFED7AA), foregroundColor: const Color(0xFF7C2D12)),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _tarjetaMenu(context, "Ejercicios Discretos", "Ayuda invisible según tu nivel.", Icons.directions_walk, const Color(0xFFF59E0B), const PantallaSliderAnsiedad(contexto: "calle")),
          const SizedBox(height: 12),
          _tarjetaMenu(context, "Musicoterapia", "Tonos para tus audífonos.", Icons.graphic_eq, const Color(0xFFD97757), const PantallaFrecuencias()),
          const SizedBox(height: 12),
          _tarjetaMenu(context, "Diario de Desahogo", "Exagera tus pensamientos.", Icons.edit_note, const Color(0xFF818CF8), const PantallaDesahogo()),
          const SizedBox(height: 12),
          _tarjetaMenu(context, "Afirmaciones de Fortaleza", "Frases rápidas para leer en público.", Icons.auto_awesome, const Color(0xFFF59E0B), const PantallaAfirmaciones()),
        ],
      ),
    );
  }
}

Widget _tarjetaMenu(BuildContext context, String titulo, String sub, IconData icono, Color color, Widget destino) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 2, color: Colors.white,
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      leading: CircleAvatar(radius: 22, backgroundColor: color.withOpacity(0.15), child: Icon(icono, color: color, size: 26)),
      title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF334155))),
      subtitle: Text(sub, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFCBD5E1)),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => destino)),
    ),
  );
}

// ==========================================
// 12. EJERCICIOS (SISTEMA DE REGLAS LOCAL)
// ==========================================
class PantallaEjercicios extends StatefulWidget {
  final String contexto;
  final int nivelUsuario;
  const PantallaEjercicios({super.key, required this.contexto, required this.nivelUsuario});
  @override
  State<PantallaEjercicios> createState() => _PantallaEjerciciosState();
}
class _PantallaEjerciciosState extends State<PantallaEjercicios> {
  FlutterTts flutterTts = FlutterTts();
  String mensajeAsistente = "Presiona el botón para comenzar tu ciclo de calma.";
  String explicacion = "";
  int pasoActual = 1;
  bool esUltimoEjercicio = false;
  bool estaHablando = false;
  bool ejercicioIniciado = false;

  @override
  void initState() { super.initState(); flutterTts.setLanguage("es-MX"); flutterTts.setSpeechRate(0.45); }
  @override
  void dispose() { flutterTts.stop(); super.dispose(); }

  void alternarVoz(String texto) async {
    if (estaHablando) { await flutterTts.stop(); setState(() => estaHablando = false); } 
    else { setState(() => estaHablando = true); await flutterTts.speak(texto); flutterTts.setCompletionHandler(() => setState(() => estaHablando = false)); }
  }

  void pedirEjercicio() {
    setState(() {
      ejercicioIniciado = true;
      esUltimoEjercicio = pasoActual >= 3;
      List<String> rutina = [];

      if (widget.contexto == "casa") {
        if (widget.nivelUsuario >= 8) {
          rutina = [
            "Siéntate en el piso. Siente la firmeza del suelo bajo de ti.", 
            "Inhala profundo por 4 segundos, sostén por 4 y exhala por 6.", 
            "Nombra en voz alta 5 cosas que puedas ver y 4 que puedas tocar."
          ];
        } else if (widget.nivelUsuario >= 5) {
          // Nuevos ejercicios para nivel intermedio (5 a 7)
          rutina = [
            "Estira los brazos hacia arriba e inhala profundamente.",
            "Toca tu cuello y da un suave masaje con las yemas de tus dedos.",
            "Bebe un vaso de agua lentamente, prestando atención a la temperatura."
          ];
        } else {
          rutina = [
            "Cierra los ojos un momento. Nota 3 sonidos a tu alrededor.", 
            "Haz tres respiraciones profundas y muy lentas.", 
            "Piensa en un lugar o recuerdo que te transmita mucha paz." 
          ];
        }
      } else { // Calle
        if (widget.nivelUsuario >= 8) {
          rutina = [
            "Apoya tu espalda en una pared firme si es posible.", 
            "Cuenta lentamente del 100 hacia atrás de 3 en 3.", 
            "Concéntrate en la sensación de las suelas de tus zapatos tocando el suelo."
          ];
        } else if (widget.nivelUsuario >= 5) {
          // Nuevos ejercicios para nivel intermedio en calle (5 a 7)
          rutina = [
            "Busca un lugar donde puedas sentarte o detenerte un minuto.",
            "Frota tus manos para generar un poco de calor y suelta la tensión.",
            "Respira al ritmo de tus pasos: inhala en 2 pasos, exhala en 2."
          ];
        } else {
          rutina = [
            "Observa a tu alrededor y busca 5 cosas de color azul.", 
            "Relaja la mandíbula y baja los hombros conscientemente.", 
            "Sigue tu camino a un ritmo más lento, prestando atención a tus pasos." 
          ];
        }
      }

      int indice = pasoActual - 1;
      if (indice > 2) indice = 2; 
      mensajeAsistente = rutina[indice];
      explicacion = "Concéntrate únicamente en esta instrucción.";
    });
  }

  @override
  Widget build(BuildContext context) {
    bool esCasa = widget.contexto == "casa";
    return Scaffold(
      backgroundColor: esCasa ? const Color(0xFFF0FDF4) : const Color(0xFFFFF7ED),
      appBar: AppBar(title: Text(esCasa ? "Ejercicios en Casa" : "Ejercicios en Calle"), backgroundColor: esCasa ? const Color(0xFF99F6E4) : const Color(0xFFFED7AA), foregroundColor: esCasa ? const Color(0xFF134E4A) : const Color(0xFF7C2D12)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 4, color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(mensajeAsistente, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF334155)), textAlign: TextAlign.center),
                    if (explicacion.isNotEmpty) ...[const Divider(height: 30), Text(explicacion, style: const TextStyle(fontSize: 15, color: Color(0xFF475569)))],
                    if (ejercicioIniciado && explicacion.isNotEmpty) ...[
                      const SizedBox(height: 15),
                      FilledButton.tonalIcon(onPressed: () => alternarVoz("$mensajeAsistente. $explicacion"), icon: Icon(estaHablando ? Icons.stop : Icons.volume_up), label: Text(estaHablando ? "Detener Voz" : "Escuchar Voz"))
                    ]
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (!ejercicioIniciado)
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: esCasa ? const Color(0xFF2DD4BF) : const Color(0xFFF59E0B), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)), onPressed: pedirEjercicio, child: const Text("COMENZAR EJERCICIO", style: TextStyle(fontWeight: FontWeight.bold)))
            else
              Column(
                children: [
                  if (!esUltimoEjercicio) ...[
                    OutlinedButton(onPressed: () { setState(() => pasoActual++); pedirEjercicio(); }, child: Text("Siguiente ejercicio (${pasoActual + 1} de 3)")),
                    const SizedBox(height: 15),
                  ],
                  ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15)), onPressed: () { flutterTts.stop(); Navigator.pop(context); }, child: const Text("YA ESTOY MEJOR", style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 13. DIARIO DE DESAHOGO (LOCAL)
// ==========================================
class PantallaDesahogo extends StatefulWidget {
  const PantallaDesahogo({super.key});
  @override
  State<PantallaDesahogo> createState() => _PantallaDesahogoState();
}
class _PantallaDesahogoState extends State<PantallaDesahogo> {
  TextEditingController controlador = TextEditingController();
  List<Map<String, String>> mensajes = [{"autor": "Asistente", "texto": "Escribe sin filtro lo que te preocupa. Exagéralo al máximo posible hasta que suene absurdo."}];
  
  void enviarMensaje() {
    final texto = controlador.text.trim();
    if (texto.isEmpty) return;
    setState(() {
      mensajes.add({"autor": "Usuario", "texto": texto});
      controlador.clear();
    });

    final respuesta = CerebroNexo.esCrisis(texto)
        ? CerebroNexo.analizarMensaje(texto)
        : "Sigue escribiendo, sácalo todo. Ponerlo en palabras le quita poder a la ansiedad.";

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => mensajes.add({"autor": "Asistente", "texto": respuesta}));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text("Diario de Exageración"), backgroundColor: const Color(0xFFC7D2FE), foregroundColor: const Color(0xFF312E81)),
      body: Column(
        children: [
          Expanded(child: ListView.builder(padding: const EdgeInsets.all(15), itemCount: mensajes.length, itemBuilder: (context, i) {
            bool esUsuario = mensajes[i]["autor"] == "Usuario";
            return Align(alignment: esUsuario ? Alignment.centerRight : Alignment.centerLeft, child: Container(margin: const EdgeInsets.symmetric(vertical: 5), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: esUsuario ? const Color(0xFF818CF8) : Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)]), child: Text(mensajes[i]["texto"]!, style: TextStyle(color: esUsuario ? Colors.white : const Color(0xFF334155)))));
          })),
          Padding(padding: const EdgeInsets.all(10), child: Row(children: [
            Expanded(child: TextField(controller: controlador, decoration: const InputDecoration(hintText: "Escribe tu pensamiento...", border: OutlineInputBorder(), fillColor: Colors.white, filled: true))),
            IconButton(onPressed: enviarMensaje, icon: const Icon(Icons.send, color: Color(0xFF818CF8))),
          ]))
        ],
      ),
    );
  }
}

// ==========================================
// 14. FRECUENCIAS Y AUDIOS
// ==========================================
class PantallaFrecuencias extends StatefulWidget {
  const PantallaFrecuencias({super.key});
  @override
  State<PantallaFrecuencias> createState() => _PantallaFrecuenciasState();
}
class _PantallaFrecuenciasState extends State<PantallaFrecuencias> {
  final AudioPlayer reproductor = AudioPlayer();
  String frecuenciaActiva = "";
  @override
  void dispose() { reproductor.stop(); reproductor.dispose(); super.dispose(); }
  void reproducirAudio(String titulo, String archivoMp3) async { await reproductor.stop(); setState(() => frecuenciaActiva = titulo); await reproductor.play(AssetSource('audio/$archivoMp3')); }
  void detenerAudio() async { await reproductor.stop(); setState(() => frecuenciaActiva = ""); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7ED),
      appBar: AppBar(title: const Text("Musicoterapia"), backgroundColor: const Color(0xFFFED7AA), foregroundColor: const Color(0xFF7C2D12)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("Conecta tus audífonos y selecciona un sonido para regularte:", style: TextStyle(fontSize: 16, color: Color(0xFF475569))), const SizedBox(height: 20),
          _itemFrecuencia("432 Hz - Reducción de Estrés", "Disminuye la ansiedad.", "432hz.mp3"),
          _itemFrecuencia("528 Hz - Reparación Profunda", "Frecuencia de la tranquilidad.", "528hz.mp3"),
          _itemFrecuencia("Cuencos Tibetanos", "Armonización corporal.", "cuencos.mp3"),
          _itemFrecuencia("Ruido Rosa", "Bloquea pensamientos.", "ruidorosa.mp3"),
          _itemFrecuencia("Ruido Blanco", "Ideal para enfocar.", "ruidoblanco.mp3"),
          _itemFrecuencia("Lluvia Suave", "Sonido de la naturaleza.", "lluvia.mp3"),
          const SizedBox(height: 30),
          if (frecuenciaActiva.isNotEmpty)
            Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]), child: Column(children: [
              const Icon(Icons.audiotrack, size: 40, color: Color(0xFFD97757)), const SizedBox(height: 10), Text("Reproduciendo: $frecuenciaActiva", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155))), const SizedBox(height: 15),
              FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEF4444)), onPressed: detenerAudio, icon: const Icon(Icons.stop), label: const Text("Detener Audio"))
            ]))
        ],
      ),
    );
  }
  Widget _itemFrecuencia(String titulo, String desc, String archivo) {
    bool estaSonando = frecuenciaActiva == titulo;
    return Card(
      margin: const EdgeInsets.only(bottom: 15), elevation: 1, color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: estaSonando ? const Color(0xFFD97757) : const Color(0xFFFED7AA), child: Icon(Icons.waves, color: estaSonando ? Colors.white : const Color(0xFF7C2D12))),
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(desc),
        trailing: Icon(estaSonando ? Icons.volume_up : Icons.play_circle_fill, size: 36, color: estaSonando ? const Color(0xFFD97757) : const Color(0xFFCBD5E1)),
        onTap: () { if (estaSonando) { detenerAudio(); } else { reproducirAudio(titulo, archivo); } },
      ),
    );
  }
}

// ==========================================
// 15. MINDFULNESS ANIMADO
// ==========================================
class PantallaMindfulness extends StatefulWidget {
  const PantallaMindfulness({super.key});
  @override
  State<PantallaMindfulness> createState() => _PantallaMindfulnessState();
}
class _PantallaMindfulnessState extends State<PantallaMindfulness> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String fase = "Inhala";
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _animation = Tween<double>(begin: 0.5, end: 1.3).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) { setState(() => fase = "Exhala"); _controller.reverse(); }
      else if (status == AnimationStatus.dismissed) { setState(() => fase = "Inhala"); _controller.forward(); }
    });
    _controller.forward();
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mindfulness"), backgroundColor: const Color(0xFF99F6E4), foregroundColor: const Color(0xFF134E4A)),
      backgroundColor: const Color(0xFFF0FDF4),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(fase, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF134E4A))), const SizedBox(height: 60),
        ScaleTransition(scale: _animation, child: Container(width: 200, height: 200, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF2DD4BF).withOpacity(0.2), border: Border.all(color: const Color(0xFF2DD4BF), width: 4), boxShadow: [BoxShadow(color: const Color(0xFF2DD4BF).withOpacity(0.3), blurRadius: 30, spreadRadius: 10)]), child: const Icon(Icons.spa, size: 80, color: Color(0xFF2DD4BF)))),
        const SizedBox(height: 80), const Text("Sigue el ritmo del círculo\npara calmar tu sistema nervioso.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color(0xFF64748B))),
      ])),
    );
  }
}

// ==========================================
// 16. MÁNDALAS
// ==========================================
class PantallaMandala extends StatefulWidget {
  final String tipo;
  const PantallaMandala({super.key, required this.tipo});
  @override
  State<PantallaMandala> createState() => _PantallaMandalaState();
}
class _PantallaMandalaState extends State<PantallaMandala> {
  Color colorSeleccionado = Colors.teal;
  List<Color> coloresSecciones = List.generate(16, (_) => Colors.white);
  final List<Color> paleta = [Colors.teal, Colors.blue, Colors.purple, Colors.pink, Colors.orange, Colors.amber, Colors.green, Colors.red];
  
  @override
  Widget build(BuildContext context) {
    int numeroCapas = (widget.tipo == "roseta" || widget.tipo == "circulos") ? 16 : 8;

    return Scaffold(
      appBar: AppBar(title: Text("Mándala: ${widget.tipo.toUpperCase()}")),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.all(15), child: Text("Selecciona un color y toca las figuras para pintar.", textAlign: TextAlign.center)),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 300, height: 300,
                child: Stack(
                  alignment: Alignment.center,
                  children: List.generate(numeroCapas, (i) {
                    double size = 280.0 - (i * (280/numeroCapas));
                    Widget figura;
                    if (widget.tipo == "flor") {
                      figura = Transform.rotate(angle: i * 0.4, child: Container(width: size, height: size, decoration: BoxDecoration(color: coloresSecciones[i], borderRadius: BorderRadius.circular(size / 3), border: Border.all(color: Colors.black87, width: 2))));
                    } else if (widget.tipo == "estrella") {
                      figura = Transform.rotate(angle: i * 0.785, child: Container(width: size, height: size, decoration: BoxDecoration(color: coloresSecciones[i], border: Border.all(color: Colors.black87, width: 2))));
                    } else if (widget.tipo == "geometria") {
                      figura = Transform.rotate(angle: i * 0.2, child: Container(width: size, height: size / 1.3, decoration: BoxDecoration(color: coloresSecciones[i], border: Border.all(color: Colors.black87, width: 2))));
                    } else if (widget.tipo == "roseta") {
                      figura = Transform.rotate(angle: i * 0.39, child: Container(width: size, height: size, decoration: BoxDecoration(color: coloresSecciones[i].withOpacity(0.8), borderRadius: BorderRadius.only(topLeft: Radius.circular(size), bottomRight: Radius.circular(size)), border: Border.all(color: Colors.purple.shade900, width: 1))));
                    } else if (widget.tipo == "circulos") {
                      figura = Transform.translate(offset: Offset(i % 2 == 0 ? 10 : -10, i % 3 == 0 ? 10 : -10), child: Transform.rotate(angle: i * 0.15, child: Container(width: size, height: size, decoration: BoxDecoration(color: coloresSecciones[i].withOpacity(0.7), shape: BoxShape.circle, border: Border.all(color: Colors.indigo, width: 1.5)))));
                    } else {
                      figura = Transform.scale(scale: 1.0 - (i * 0.1), child: Container(width: 280, height: 280, decoration: BoxDecoration(shape: BoxShape.circle, color: coloresSecciones[i], border: Border.all(color: Colors.black87, width: 2))));
                    }
                    return GestureDetector(onTap: () => setState(() => coloresSecciones[i] = colorSeleccionado), child: figura);
                  }),
                ),
              ),
            ),
          ),
          Container(padding: const EdgeInsets.all(15), color: Colors.white, child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: paleta.map((color) {
            bool seleccionado = colorSeleccionado == color;
            return GestureDetector(onTap: () => setState(() => colorSeleccionado = color), child: Container(width: 38, height: 38, decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: seleccionado ? Border.all(color: Colors.black, width: 3) : null)));
          }).toList()))
        ],
      ),
    );
  }
}

// ==========================================
// 17. JUEGOS ORIGINALES Y JUEGOS EXTRA
// ==========================================
class PantallaJuegoBurbujas extends StatefulWidget {
  const PantallaJuegoBurbujas({super.key});
  @override
  State<PantallaJuegoBurbujas> createState() => _PantallaJuegoBurbujasState();
}
class _PantallaJuegoBurbujasState extends State<PantallaJuegoBurbujas> {
  List<bool> estadoBurbujas = List.generate(24, (_) => false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pop-It")),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.all(20), child: Text("Revienta las burbujas. Este movimiento repetitivo ayuda a calmar el estrés mecánico.", style: TextStyle(fontSize: 16))),
          Expanded(child: GridView.builder(padding: const EdgeInsets.all(20), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 15, mainAxisSpacing: 15), itemCount: 24, itemBuilder: (context, i) {
            bool reventada = estadoBurbujas[i];
            return GestureDetector(onTap: () => setState(() => estadoBurbujas[i] = !reventada), child: AnimatedContainer(duration: const Duration(milliseconds: 150), decoration: BoxDecoration(shape: BoxShape.circle, color: reventada ? Colors.grey.shade300 : Colors.cyanAccent.shade700, boxShadow: reventada ? [] : [BoxShadow(color: Colors.cyan.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))])));
          })),
          ElevatedButton(onPressed: () => setState(() => estadoBurbujas = List.generate(24, (_) => false)), child: const Text("Reiniciar")),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class PantallaJuegoInfinito extends StatelessWidget {
  const PantallaJuegoInfinito({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trazar el Infinito")),
      body: const Center(
        child: Padding(padding: EdgeInsets.all(30.0), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.all_inclusive, size: 150, color: Colors.purpleAccent), SizedBox(height: 40),
          Text("Con tu dedo, traza lentamente la forma del infinito en la pantalla.", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), SizedBox(height: 20),
          Text("Inhala al subir, exhala al bajar. Cruzar la línea media del cuerpo equilibra ambos hemisferios.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
        ])),
      ),
    );
  }
}

class PantallaJuegoPuntos extends StatefulWidget {
  const PantallaJuegoPuntos({super.key});
  @override
  State<PantallaJuegoPuntos> createState() => _PantallaJuegoPuntosState();
}
class _PantallaJuegoPuntosState extends State<PantallaJuegoPuntos> {
  double posX = 150.0;
  double posY = 300.0;
  int puntos = 0;
  void moverPunto() { setState(() { puntos++; posX = (posX * 3.14) % 250 + 50; posY = (posY * 1.5) % 400 + 100; }); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Caza-Puntos (Atrapados: $puntos)")),
      body: Stack(
        children: [
          const Positioned(top: 20, left: 20, right: 20, child: Text("Toca el punto naranja. Obliga a tus ojos a enfocar y a tu cerebro a salir del pánico.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16))),
          Positioned(left: posX, top: posY, child: GestureDetector(onTap: moverPunto, child: Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.orangeAccent, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.5), blurRadius: 15)]), child: const Icon(Icons.ads_click, color: Colors.white))))
        ],
      ),
    );
  }
}

class PantallaJuegoToques extends StatefulWidget {
  const PantallaJuegoToques({super.key});
  @override
  State<PantallaJuegoToques> createState() => _PantallaJuegoToquesState();
}
class _PantallaJuegoToquesState extends State<PantallaJuegoToques> {
  int toques = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E8FF),
      appBar: AppBar(title: const Text("Toques de Calma")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Toca la esfera rítmicamente para liberar tensión.", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () => setState(() => toques++),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: 180 + (toques % 5 * 10), height: 180 + (toques % 5 * 10),
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.purpleAccent, boxShadow: [BoxShadow(color: Colors.purple, blurRadius: 20)]),
                child: Center(child: Text("$toques", style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PantallaJuegoPresion extends StatelessWidget {
  const PantallaJuegoPresion({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pared de Presión")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.touch_app, size: 80, color: Colors.indigo),
              const SizedBox(height: 20),
              const Text("Mantén presionado el centro con tu pulgar con fuerza constante durante 10 segundos.", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              GestureDetector(
                onLongPress: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✨ Excelente trabajo de liberación física."))),
                child: Container(width: 200, height: 200, decoration: BoxDecoration(color: Colors.indigo, borderRadius: BorderRadius.circular(30)), child: const Center(child: Text("MANTÉN\nPRESIONADO", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PantallaAfirmaciones extends StatefulWidget {
  const PantallaAfirmaciones({super.key});
  @override
  State<PantallaAfirmaciones> createState() => _PantallaAfirmacionesState();
}
class _PantallaAfirmacionesState extends State<PantallaAfirmaciones> {
  final List<String> afirmaciones = ["Estoy a salvo en este momento.", "Esta sensación es incómoda, pero NO es peligrosa.", "Mi cuerpo sabe cómo volver a la calma.", "Tengo el control de mi respiración aquí y ahora.", "He superado esto antes y lo superaré hoy también.", "No tengo que resolver todo en este instante.", "Puedo sentir ansiedad y aun así seguir adelante.", "No tengo que ser perfecto para merecer calma.", "Un pensamiento no es un hecho.", "Estoy haciendo lo mejor que puedo hoy.", "Pedir ayuda es una muestra de fuerza.", "Cada respiración me ayuda a volver al presente."];
  int indice = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF3C7),
      appBar: AppBar(title: const Text("Afirmaciones de Calma"), backgroundColor: const Color(0xFFFDE68A)),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome, size: 70, color: Color(0xFFD97706)), const SizedBox(height: 40),
            Card(elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), child: Padding(padding: const EdgeInsets.all(30.0), child: Text("\"${afirmaciones[indice]}\"", textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF78350F), height: 1.4)))),
            const SizedBox(height: 40),
            ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)), onPressed: () => setState(() => indice = (indice + 1) % afirmaciones.length), icon: const Icon(Icons.swap_horiz), label: const Text("Siguiente Afirmación"))
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 18. ESTADÍSTICAS (Adaptado para Web sin errores de índice)
// ==========================================
class PantallaEstadisticas extends StatelessWidget {
  const PantallaEstadisticas({super.key});

  @override
  Widget build(BuildContext context) {
    User? usuario = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text("Tus Estadísticas"), backgroundColor: const Color(0xFFC7D2FE), foregroundColor: const Color(0xFF312E81)),
      body: usuario == null 
        ? const Center(child: Text("Debes iniciar sesión para ver esto."))
        : StreamBuilder(
            stream: FirebaseFirestore.instance.collection('usuarios').doc(usuario.uid).collection('historial_ansiedad').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(30.0), child: Text("Aún no tienes registros.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey))));
              
              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs[index];
                  int nivel = doc['nivel'] ?? 0; 
                  String contextoApp = doc['contexto'] ?? 'general'; 
                  Timestamp? t = doc['fecha'];
                  
                  String fechaStr = "Hace un momento";
                  if (t != null) { 
                    DateTime fecha = t.toDate(); 
                    fechaStr = "${fecha.day}/${fecha.month}/${fecha.year} a las ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}"; 
                  }
                  
                  Color colorNivel = Colors.green; 
                  if (nivel > 3) colorNivel = Colors.orange; 
                  if (nivel > 7) colorNivel = Colors.red;
                  
                  return Card(
                    elevation: 2, margin: const EdgeInsets.only(bottom: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      leading: CircleAvatar(radius: 25, backgroundColor: colorNivel.withOpacity(0.2), child: Text(nivel.toString(), style: TextStyle(color: colorNivel, fontWeight: FontWeight.bold, fontSize: 20))),
                      title: Text("Ansiedad en Modo ${contextoApp.toUpperCase()}", style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(fechaStr), trailing: const Icon(Icons.show_chart, color: Colors.grey),
                    ),
                  );
                }
              );
            },
          ),
    );
  }
}

// ==========================================
// 19. AUDIOS Y FRECUENCIAS
// ==========================================
class PantallaAudios extends StatefulWidget {
  const PantallaAudios({super.key});
  @override
  State<PantallaAudios> createState() => _PantallaAudiosState();
}
class _PantallaAudiosState extends State<PantallaAudios> {
  final AudioPlayer reproductor = AudioPlayer();
  String frecuenciaActiva = "";
  @override
  void dispose() { reproductor.stop(); reproductor.dispose(); super.dispose(); }
  void reproducirAudio(String titulo, String archivoMp3) async { await reproductor.stop(); setState(() => frecuenciaActiva = titulo); await reproductor.play(AssetSource('audio/$archivoMp3')); }
  void detenerAudio() async { await reproductor.stop(); setState(() => frecuenciaActiva = ""); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E8FF),
      appBar: AppBar(title: const Text("Catálogo de Audios"), backgroundColor: const Color(0xFFD8B4FE), foregroundColor: const Color(0xFF581C87)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("Frecuencias y audios relajantes:", style: TextStyle(fontSize: 16, color: Color(0xFF475569))), const SizedBox(height: 20),
          _itemFrecuencia("432 Hz - Reducción de Estrés", "Disminuye la ansiedad.", "432hz.mp3"),
          _itemFrecuencia("528 Hz - Reparación Profunda", "Frecuencia de la tranquilidad.", "528hz.mp3"),
          _itemFrecuencia("Cuencos Tibetanos", "Armonización corporal.", "cuencos.mp3"),
          _itemFrecuencia("Ruido Rosa", "Bloquea pensamientos.", "ruidorosa.mp3"),
          _itemFrecuencia("Ruido Blanco", "Ideal para enfocar.", "ruidoblanco.mp3"),
          _itemFrecuencia("Lluvia Suave", "Sonido de la naturaleza.", "lluvia.mp3"),
          const Divider(height: 30),
          _itemFrecuencia("Ondas Theta (4 Hz)", "Induce estado de sueño y sanación.", "theta.mp3"),
          _itemFrecuencia("Ondas Delta (2 Hz)", "Reparación física y regeneración.", "delta.mp3"),
          _itemFrecuencia("Ruido Marrón", "Ideal para TDAH y calma mental.", "ruidomarron.mp3"),
          const SizedBox(height: 30),
          if (frecuenciaActiva.isNotEmpty)
            Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]), child: Column(children: [
              const Icon(Icons.music_note, size: 40, color: Color(0xFF8B5CF6)), const SizedBox(height: 10), Text("Reproduciendo: $frecuenciaActiva", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155))), const SizedBox(height: 15),
              FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEF4444)), onPressed: detenerAudio, icon: const Icon(Icons.stop), label: const Text("Detener Audio"))
            ]))
        ],
      ),
    );
  }
  Widget _itemFrecuencia(String titulo, String desc, String archivo) {
    bool estaSonando = frecuenciaActiva == titulo;
    return Card(
      margin: const EdgeInsets.only(bottom: 15), elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: estaSonando ? const Color(0xFF8B5CF6) : const Color(0xFFE9D5FF), child: Icon(Icons.headset, color: estaSonando ? Colors.white : const Color(0xFF581C87))),
        title: Text(titulo, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple.shade900)), subtitle: Text(desc),
        trailing: Icon(estaSonando ? Icons.volume_up : Icons.play_circle_fill, size: 36, color: estaSonando ? const Color(0xFF8B5CF6) : const Color(0xFFCBD5E1)),
        onTap: () { if (estaSonando) { detenerAudio(); } else { reproducirAudio(titulo, archivo); } },
      ),
    );
  }
}

// ==========================================
// MOTOR DE INTELIGENCIA NEXO (IA PROPIA)
// ==========================================
class CerebroNexo {
  static const String lineaAyuda =
      'Línea de la Vida: 800 911 2000 (gratuita, 24 horas) o el 911 si hay peligro inmediato';

  static final Random _azar = Random();

  // Minúsculas y sin acentos, para comparar palabras clave.
  static String _normalizar(String texto) {
    const conAcento = 'áàäâéèëêíìïîóòöôúùüûñ';
    const sinAcento = 'aaaaeeeeiiiioooouuuun';
    var t = texto.toLowerCase();
    for (var i = 0; i < conAcento.length; i++) {
      t = t.replaceAll(conAcento[i], sinAcento[i]);
    }
    return t;
  }

  static bool _tiene(String t, List<String> palabras) => palabras.any((p) => t.contains(p));

  static String _elegir(List<String> opciones) => opciones[_azar.nextInt(opciones.length)];

  static bool esCrisis(String mensaje) {
    final t = _normalizar(mensaje);
    return _tiene(t, [
      'suicid', 'matarme', 'quitarme la vida', 'quiero morir', 'no quiero vivir',
      'ya no quiero estar aqui', 'hacerme dano', 'lastimarme', 'cortarme',
      'acabar con todo', 'terminar con todo', 'acabar con mi vida',
      'mejor muerto', 'mejor muerta', 'no vale la pena vivir',
    ]);
  }

  static String analizarMensaje(String mensajeUsuario) {
    final t = _normalizar(mensajeUsuario);

    // 0. Crisis: siempre tiene prioridad.
    if (esCrisis(mensajeUsuario)) {
      return 'Siento mucho que estés sufriendo así, y me importa que estés bien. No tienes que pasar por esto a solas. '
          'Por favor, habla ahora con alguien que pueda ayudarte: $lineaAyuda. '
          'Si puedes, avísale también a una persona de confianza que esté cerca de ti. '
          'Yo no sustituyo a un profesional, pero aquí sigo contigo.';
    }

    // 1. Pánico / síntomas físicos
    if (_tiene(t, ['panico', 'ataque de', 'no puedo respirar', 'me ahogo', 'taquicardia', 'palpitaciones',
        'me falta el aire', 'me voy a desmayar', 'me voy a morir', 'mareo', 'el corazon'])) {
      return _elegir([
        'Lo que sientes es muy intenso, pero no es peligroso y va a pasar. Haz esto conmigo: inhala por la nariz contando 4 y exhala lento por la boca contando 6. Repítelo varias veces; estoy aquí.',
        'Estás a salvo. Apoya los pies en el suelo, suelta los hombros y exhala largo. Luego nombra 5 cosas que ves a tu alrededor. Los picos de ansiedad suben y bajan, y este también va a bajar.',
        'Entiendo que da mucho miedo, pero tu cuerpo solo está en modo alarma. Respira lento (4 al inhalar, 6 al exhalar) y recuérdate: «esto pasa». Si quieres, abre un ejercicio guiado en Modo Casa o Modo Calle.',
      ]);
    }

    // 2. Insomnio
    if (_tiene(t, ['dormir', 'insomnio', 'desvel', 'pesadilla'])) {
      return _elegir([
        'Dormir con la mente acelerada es agotador. Prueba esto: inhala 4, sostén 4 y exhala 6, varias veces, y deja que los pensamientos pasen sin seguirlos. Si no te duermes en unos 20 minutos, levántate un rato con luz tenue.',
        'Es difícil descansar cuando la cabeza no para. Intenta relajar el cuerpo por partes, de los pies a la cara, tensando y soltando. Y apunta lo pendiente en un papel para dejarlo fuera de la cama.',
      ]);
    }

    // 3. Tristeza
    if (_tiene(t, ['triste', 'llorar', 'lloro', 'vacio', 'deprim', 'sin ganas', 'desanim'])) {
      return _elegir([
        'Siento que estés pasando por esto. Está bien sentirse así y no tienes que fingir que no. ¿Quieres contarme qué fue lo que más te pesó hoy?',
        'Gracias por decírmelo. La tristeza también necesita espacio. Hoy basta con un paso pequeño: agua, aire fresco o hablar con alguien cercano. Si dura mucho tiempo, vale la pena hablarlo con un profesional.',
      ]);
    }

    // 4. Soledad
    if (_tiene(t, ['soledad', 'me siento solo', 'me siento sola', 'estoy solo', 'estoy sola',
        'nadie me entiende', 'nadie me quiere', 'aislad'])) {
      return _elegir([
        'Sentirte solo duele, y gracias por confiármelo. Un mensaje corto a alguien de confianza puede ayudar más de lo que parece. ¿Hay alguien a quien podrías escribirle hoy, aunque sea un saludo?',
        'No estás tan solo como se siente en este momento. Aquí estoy para escucharte. ¿Qué te gustaría que alguien te dijera ahora mismo?',
      ]);
    }

    // 5. Enojo
    if (_tiene(t, ['enoj', 'furia', 'coraje', 'molest', 'frustr', 'rabia'])) {
      return _elegir([
        'Tiene sentido que te sientas así. Antes de actuar, dale una salida al cuerpo: exhala largo varias veces, camina un poco o aprieta y suelta los puños. Cuando baje la intensidad, lo pensamos con calma.',
        'El enojo suele traer cansancio detrás. Respira lento unas cuantas veces y, si quieres, cuéntame qué pasó; también puedes escribirlo en el Diario de Desahogo.',
      ]);
    }

    // 6. Estrés (trabajo, escuela)
    if (_tiene(t, ['trabajo', 'escuela', 'examen', 'tarea', 'jefe', 'estres', 'presion', 'agobi', 'abruma', 'pendientes'])) {
      return _elegir([
        'Cuando todo se junta, parece imposible. Intenta esto: escribe todo lo pendiente, elige solo UNA cosa pequeña para empezar y deja el resto para después. Un paso a la vez.',
        'Suena a mucha carga. Haz una pausa de 2 minutos: respira lento y suelta los hombros. Luego dividimos lo que tienes en partes pequeñas y manejables.',
      ]);
    }

    // 6b. Dolor en el pecho: seguridad primero
    if (_tiene(t, ['dolor en el pecho', 'me duele el pecho', 'dolor de pecho', 'opresion en el pecho'])) {
      return 'Si tienes dolor fuerte en el pecho que no cede, te falta el aire de forma intensa, o ya tienes algún problema del corazón, busca atención médica de urgencia: llama al 911. '
          'Si ya te revisaron antes y suele ser ansiedad, respira lento (4 al inhalar, 6 al exhalar) y recuerda que va a pasar.';
    }

    // 6c. Autoestima / culpa
    if (_tiene(t, ['no valgo', 'soy un fracaso', 'no sirvo', 'me odio', 'me siento culpable', 'tengo la culpa', 'es mi culpa',
        'soy inutil', 'no soy suficiente', 'no soy bueno', 'no soy buena'])) {
      return _elegir([
        'Gracias por decirlo. Esa voz que te juzga con tanta dureza no es la verdad: es la ansiedad hablando fuerte. Intenta decirte lo que le dirías a un buen amigo en tu lugar. ¿Qué le dirías?',
        'Equivocarte o sentir que no llegas no define tu valor como persona. Prueba escribir tres cosas que sí hiciste bien esta semana, por pequeñas que sean. Si quieres, las repasamos juntos.',
      ]);
    }

    // 6d. Relaciones (pareja, familia, amistades)
    if (_tiene(t, ['mi pareja', 'mi novio', 'mi novia', 'discusion', 'discuti', 'pelea con', 'mi familia', 'mis papas',
        'mi mama', 'mi papa', 'mis amigos', 'ruptura', 'terminamos', 'me dejo'])) {
      return _elegir([
        'Los conflictos con personas que queremos pesan mucho. Antes de responder, dale un respiro a tu cuerpo: exhala largo varias veces. Cuando estés más tranquilo, piensa qué necesitas decir y qué necesitas pedir. ¿Quieres contarme qué pasó?',
        'Lo que viviste con esa persona importa, y es normal que te afecte. Puedes escribirlo en el Diario de Desahogo para ordenar lo que sientes antes de hablarlo. Si es una situación que te daña, hablarlo con alguien de confianza o con un profesional puede ayudarte.',
      ]);
    }

    // 6e. Duelo / pérdida
    if (_tiene(t, ['murio', 'fallecio', 'perdi a', 'duelo', 'lo extrano', 'la extrano', 'se murio'])) {
      return _elegir([
        'Lo siento muchísimo. El duelo no tiene un tiempo ni una forma correcta, y está bien llorar, extrañar o sentir que no puedes más. No tienes que atravesarlo a solas: si puedes, busca a alguien cercano que te acompañe. ¿Quieres contarme sobre esa persona?',
        'Perder a alguien duele de verdad. Date permiso de sentir lo que sientes hoy, sin exigirte estar bien. Respirar lento y beber agua también es cuidarte. Si el dolor se vuelve demasiado, un profesional puede acompañarte en este proceso.',
      ]);
    }

    // 6f. Cansancio / agotamiento
    if (_tiene(t, ['cansad', 'agotad', 'sin energia', 'no me puedo concentrar', 'no puedo concentrarme', 'burnout'])) {
      return _elegir([
        'El cansancio que deja la ansiedad es real: tu cuerpo ha estado en alerta mucho tiempo. Hoy trata de bajar el ritmo: una pausa corta, agua, y soltar hombros y mandíbula. Dormir y comer a tus horas también ayuda más de lo que parece.',
        'Suena a que has cargado mucho. No tienes que rendir al máximo hoy. Elige una sola cosa importante y permite que lo demás espere. Si el agotamiento dura semanas, vale la pena platicarlo con un profesional.',
      ]);
    }

    // 7. Miedo / preocupación / ansiedad general
    if (_tiene(t, ['no paro de pensar', 'pensando', 'preocup', 'que pasara', 'futuro', 'miedo', 'asustad', 'ansied', 'ansios', 'nervios', 'intranquil'])) {
      return _elegir([
        'Se siente agotador cuando la mente no suelta. Una ayuda: separa lo que puedes controlar de lo que no. Para lo primero, elige un pequeño paso; para lo segundo, respira y déjalo pasar por ahora.',
        'Gracias por contármelo. Prueba el ejercicio de 5 sentidos: nombra 5 cosas que ves, 4 que tocas y 3 que oyes. Ayuda a salir del bucle de pensamientos. ¿Quieres que lo hagamos juntos?',
        'Lo que sientes es real, y se puede manejar. Respira lento y dime: ¿qué es lo que más te preocupa en este momento? A veces ponerlo en palabras lo hace más pequeño.',
      ]);
    }

    // 7b. Ayuda general / qué puede hacer el asistente
    if (_tiene(t, ['que puedes hacer', 'como funcionas', 'necesito ayuda', 'ayudame', 'no se que hacer', 'para que sirves'])) {
      return 'Puedo acompañarte cuando sientas pánico, ansiedad, estrés, insomnio, tristeza, soledad, enojo, culpa, problemas con otras personas o duelo. '
          'Cuéntame con tus palabras qué sientes, o toca una de las sugerencias. También puedes abrir un ejercicio guiado en Modo Casa o Modo Calle.';
    }

    // 8. Agradecimiento / mejoría
    if (_tiene(t, ['gracias', 'me ayudo', 'me siento mejor', 'ya estoy mejor', 'ya me siento mejor'])) {
      return _elegir([
        'Me alegra mucho. Lo hiciste tú: tuviste la fuerza de detenerte y cuidarte. Aquí estaré cuando me necesites.',
        'Qué bueno saberlo. Recuerda que estos ejercicios se pueden repetir cuando quieras. Cuídate mucho.',
      ]);
    }

    // 9. Saludo
    if (RegExp(r'^(hola|buenas|buenos dias|buenas tardes|buenas noches|hey|que tal|holi)\b').hasMatch(t)) {
      return _elegir([
        '¡Hola! Me alegra que estés aquí. ¿Cómo te sientes hoy? Cuéntame lo que quieras, sin prisa.',
        'Hola, aquí estoy para escucharte. ¿Qué tal va tu día?',
      ]);
    }

    // 10. Respuesta por defecto
    return _elegir([
      'Te escucho. Gracias por compartirlo. ¿Puedes contarme un poco más sobre cómo te sientes en este momento?',
      'Lo que sientes importa. Mientras lo platicamos, respira lento: inhala 4, exhala 6. ¿Qué es lo que más te pesa ahora?',
      'Estoy aquí contigo. Si quieres, también puedes abrir un ejercicio guiado en Modo Casa o Modo Calle, y lo hacemos paso a paso.',
    ]);
  }
}

// ==========================================
// 20. CHATBOT (ASISTENTE LOCAL, SIN INTERNET)
// ==========================================
class PantallaChatbotIA extends StatefulWidget {
  const PantallaChatbotIA({super.key});
  @override
  State<PantallaChatbotIA> createState() => _PantallaChatbotIAState();
}

class _PantallaChatbotIAState extends State<PantallaChatbotIA> {
  final TextEditingController controlador = TextEditingController();
  bool estaPensando = false;

  List<Map<String, String>> mensajes = [
    {
      "autor": "Nexo",
      "texto": "Respira profundo, estás en un espacio seguro. 🌿\n\nSoy Nexo, tu asistente de apoyo. Cuéntame con tus palabras lo que sientes o toca una de las opciones de abajo. Puedo ayudarte con pánico, ansiedad, estrés, insomnio, tristeza, soledad o enojo. No sustituyo a un profesional, pero puedo acompañarte."
    }
  ];

  // Atajos para que la persona sepa qué puede decir.
  final List<String> sugerencias = const [
    "Tengo un ataque de pánico",
    "No puedo dormir",
    "Me siento ansioso",
    "Estoy muy estresado",
    "Me siento triste",
    "Me siento solo",
    "Estoy enojado",
    "No paro de pensar",
    "Me siento culpable",
    "Estoy muy cansado",
    "Tuve una discusión",
    "¿Qué puedes hacer?",
  ];

  Future<void> enviarMensaje([String? rapido]) async {
    final texto = (rapido ?? controlador.text).trim();
    if (texto.isEmpty) return;

    setState(() {
      mensajes.add({"autor": "Usuario", "texto": texto});
      controlador.clear();
      estaPensando = true;
    });

    // Asistente local (sin internet ni API): pequeña pausa para que se sienta natural.
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      mensajes.add({"autor": "Nexo", "texto": CerebroNexo.analizarMensaje(texto)});
      estaPensando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF2FF),
      appBar: AppBar(
        title: const Text("Asistente Nexo"),
        backgroundColor: const Color(0xFF818CF8),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: mensajes.length,
              itemBuilder: (context, i) {
                final esUsuario = mensajes[i]["autor"] == "Usuario";
                return Align(
                  alignment: esUsuario ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: esUsuario ? const Color(0xFF6366F1) : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      mensajes[i]["texto"]!,
                      style: TextStyle(
                        color: esUsuario ? Colors.white : const Color(0xFF334155),
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (estaPensando)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              children: sugerencias
                  .map((s) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionChip(
                          label: Text(s, style: const TextStyle(fontSize: 13, color: Color(0xFF3730A3))),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFFC7D2FE)),
                          onPressed: estaPensando ? null : () => enviarMensaje(s),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controlador,
                    onSubmitted: (_) => enviarMensaje(),
                    decoration: InputDecoration(
                      hintText: "Escribe cómo te sientes...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: const Color(0xFFF1F5F9),
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: const Color(0xFF6366F1),
                  child: IconButton(
                    onPressed: enviarMensaje,
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// ==========================================
// 21. AVISO DE PRIVACIDAD
// ==========================================
class PantallaPrivacidad extends StatelessWidget {
  const PantallaPrivacidad({super.key});

  Widget _seccion(String titulo, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 6),
          Text(texto, style: const TextStyle(fontSize: 14.5, height: 1.5, color: Color(0xFF475569))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Aviso de privacidad"),
        backgroundColor: const Color(0xFFDBEAFE),
        foregroundColor: const Color(0xFF1E40AF),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView(
            padding: const EdgeInsets.all(22),
            children: [
              _seccion(
                "Qué datos guardamos",
                "Al iniciar sesión con Google guardamos tu nombre, tu correo y la fecha de registro. "
                "Cuando mides tu nivel de ansiedad en Modo Casa o Modo Calle, guardamos ese nivel, el modo y la fecha, "
                "para mostrarte tus estadísticas.",
              ),
              _seccion(
                "Qué NO guardamos",
                "Lo que escribes en el Asistente y en el Diario de Desahogo no se guarda: solo existe en tu pantalla "
                "mientras usas la app.",
              ),
              _seccion(
                "Para qué los usamos",
                "Solo para mostrarte tu perfil y tus estadísticas dentro de Nexo. No vendemos tus datos. "
                "La información se almacena en Firebase, un servicio de Google.",
              ),
              _seccion(
                "Tus derechos",
                "Puedes ver tu historial en Estadísticas y cerrar sesión cuando quieras. También puedes eliminar tu "
                "cuenta y todos tus datos desde Mi Perfil, con el botón \"Eliminar mi cuenta y mis datos\".",
              ),
              _seccion(
                "Importante",
                "Nexo es una herramienta de apoyo y no sustituye la atención de un profesional de la salud mental. "
                "Si estás en una emergencia, llama a la Línea de la Vida: 800 911 2000 (gratuita, 24 horas) o al 911.",
              ),
              _seccion(
                "Dudas o comentarios",
                "Usa el botón \"Enviar comentario\" de la pantalla principal.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
