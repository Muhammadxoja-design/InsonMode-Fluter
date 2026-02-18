import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:insonmode_fluter/core/theme/app_theme.dart';
import 'package:insonmode_fluter/core/widgets/neon_button.dart';
import 'package:insonmode_fluter/features/family/providers/family_provider.dart';

class TeenLinkingScreen extends ConsumerStatefulWidget {
  const TeenLinkingScreen({super.key});

  @override
  ConsumerState<TeenLinkingScreen> createState() => _TeenLinkingScreenState();
}

class _TeenLinkingScreenState extends ConsumerState<TeenLinkingScreen> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuccessAnimation = false;

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleLink(String code) async {
    await ref.read(familyProvider.notifier).linkTeen(code);
    
    final state = ref.read(familyProvider);
    if (state.isLinked) {
      setState(() {
        _showSuccessAnimation = true;
      });
      // Delay for animation before navigation
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        context.go('/home'); // Assuming /home is the target route
      }
    } else if (state.error != null) {
      // Create a shake effect on error (can be done via a controller or key, 
      // but for simplicity we rely on the error text or a simple snackbar/toast here)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error!),
          backgroundColor: Colors.redAccent,
        ),
      );
      _pinController.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 60,
      textStyle: GoogleFonts.orbitron(
        fontSize: 24,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
          ),
        ],
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppTheme.neonCyan),
      boxShadow: [
        const BoxShadow(
          color: AppTheme.neonCyan,
          blurRadius: 15,
          spreadRadius: 1,
        ),
      ],
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.redAccent),
    );

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ENTER PARENT CODE",
                    style: GoogleFonts.inter(
                      color: AppTheme.neonCyan,
                      fontSize: 16,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ).animate().fadeIn(duration: 500.ms),
                  const SizedBox(height: 16),
                  Text(
                    "Ask your parent for the 6-digit code on their screen.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 48),

                  Pinput(
                    length: 6,
                    controller: _pinController,
                    focusNode: _focusNode,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    errorPinTheme: errorPinTheme,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onCompleted: _handleLink,
                  ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),

                  const SizedBox(height: 40),

                  Consumer(builder: (context, ref, _) {
                     final familyState = ref.watch(familyProvider);
                     if (familyState.isLoading) {
                       return const CircularProgressIndicator(color: AppTheme.neonCyan);
                     }
                     return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
          
          if (_showSuccessAnimation)
            _buildSuccessOverlay(),
        ],
      ),
    );
  }

  Widget _buildSuccessOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.neonCyan, width: 4),
                  boxShadow: [
                    const BoxShadow(
                      color: AppTheme.neonCyan,
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(Icons.check, color: AppTheme.neonCyan, size: 80),
              ).animate()
               .scale(duration: 600.ms, curve: Curves.elasticOut)
               .then()
               .boxShadow(
                 color: AppTheme.neonCyan,
                 blurRadius: 100,
                 spreadRadius: 50,
                 duration: 1000.ms,
               ),
              const SizedBox(height: 32),
              Text(
                "CONNECTED",
                style: GoogleFonts.orbitron(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
