
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:insonmode_fluter/core/theme/app_theme.dart';
import 'package:insonmode_fluter/core/widgets/glass_card.dart';
import 'package:insonmode_fluter/core/widgets/neon_button.dart';

// --- Logic ---
final loginStateProvider = StateProvider<AsyncValue<void>>((ref) => const AsyncData(null));

// --- UI ---
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    ref.read(loginStateProvider.notifier).state = const AsyncLoading();
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      ref.read(loginStateProvider.notifier).state = const AsyncData(null);
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginStateProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      body: Stack(
        children: [
          // 1. Animated Mesh Gradient Background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgController,
              builder: (context, child) {
                return CustomPaint(
                  painter: MeshGradientPainter(_bgController.value),
                );
              },
            ),
          ),
          
          // 2. Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with Glitch Effect
                  _buildGlitchLogo(),
                  const SizedBox(height: 60),

                  // Login Form
                  GlassCard(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Text(
                          "WELCOME BACK",
                          style: AppTheme.darkTheme.textTheme.displayMedium?.copyWith(
                            fontSize: 20,
                            letterSpacing: 2,
                            color: AppTheme.neonCyan,
                          ),
                        ),
                        const SizedBox(height: 32),
                        _buildTextField(label: "Email", icon: Icons.email_outlined),
                        const SizedBox(height: 20),
                        _buildTextField(label: "Password", icon: Icons.lock_outline, isPassword: true),
                        const SizedBox(height: 40),
                        loginState.isLoading
                            ? const CircularProgressIndicator(color: AppTheme.neonCyan)
                            : NeonButton(
                                text: "KIRISH",
                                onTap: _handleLogin,
                                color: AppTheme.neonCyan,
                              ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                  .slideY(begin: 0.1, end: 0, duration: 600.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlitchLogo() {
    return Stack(
      children: [
        Text(
          "INSONMODE",
          style: GoogleFonts.orbitron(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: AppTheme.electricPurple.withOpacity(0.7),
          ),
        ).animate(onPlay: (c) => c.repeat()).shake(hz: 8, offset: const Offset(-2, 0)),
        Text(
          "INSONMODE",
          style: GoogleFonts.orbitron(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: AppTheme.neonCyan.withOpacity(0.7),
          ),
        ).animate(onPlay: (c) => c.repeat()).shake(hz: 5, offset: const Offset(2, 0)),
        Text(
          "INSONMODE",
          style: GoogleFonts.orbitron(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({required String label, required IconData icon, bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: AppTheme.neonCyan),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppTheme.neonCyan),
        ),
      ),
    );
  }
}

class MeshGradientPainter extends CustomPainter {
  final double animationValue;

  MeshGradientPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // Subtle moving blobs
    final paint = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);
    
    // Blob 1 (Cyan)
    final offset1 = Offset(
      size.width * 0.2 + sin(animationValue * 2 * pi) * 50,
      size.height * 0.3 + cos(animationValue * 2 * pi) * 50,
    );
    paint.color = AppTheme.neonCyan.withOpacity(0.15);
    canvas.drawCircle(offset1, 150, paint);

    // Blob 2 (Purple)
    final offset2 = Offset(
      size.width * 0.8 - sin(animationValue * 2 * pi) * 50,
      size.height * 0.7 - cos(animationValue * 2 * pi) * 50,
    );
    paint.color = AppTheme.electricPurple.withOpacity(0.15);
    canvas.drawCircle(offset2, 180, paint);
  }

  @override
  bool shouldRepaint(covariant MeshGradientPainter oldDelegate) => true;
}
