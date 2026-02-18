import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insonmode_fluter/core/theme/app_theme.dart';
import 'package:insonmode_fluter/core/widgets/neon_button.dart';
import 'package:insonmode_fluter/features/family/providers/family_provider.dart';

class ParentPairingScreen extends ConsumerStatefulWidget {
  const ParentPairingScreen({super.key});

  @override
  ConsumerState<ParentPairingScreen> createState() => _ParentPairingScreenState();
}

class _ParentPairingScreenState extends ConsumerState<ParentPairingScreen> {
  @override
  void initState() {
    super.initState();
    // Generate code on init if not already present
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(familyProvider).pairingCode == null) {
        ref.read(familyProvider.notifier).generatePairingCode();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final familyState = ref.watch(familyProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "FAMILY PAIRING",
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "CONNECT WITH YOUR TEEN",
                style: GoogleFonts.inter(
                  color: AppTheme.neonCyan,
                  fontSize: 16,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                ),
              ).animate().fadeIn(duration: 500.ms),
              const SizedBox(height: 48),

              // Code Display Area
              Expanded(
                child: Center(
                  child: familyState.isLoading
                      ? const CircularProgressIndicator(color: AppTheme.neonCyan)
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (familyState.pairingCode != null)
                              _buildCodeDisplay(familyState.pairingCode!),
                            if (familyState.error != null)
                              Text(
                                familyState.error!,
                                style: const TextStyle(color: Colors.redAccent),
                              ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 32),

              // Regenerate Button
              if (!familyState.isLoading)
                TextButton.icon(
                  onPressed: () {
                    ref.read(familyProvider.notifier).generatePairingCode();
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white54),
                  label: Text(
                    "Regenerate Code",
                    style: GoogleFonts.inter(color: Colors.white54),
                  ),
                ),
              
              const SizedBox(height: 32),

              // Instructions
              Text(
                "Tell your teen to enter this code on their device.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ).animate().fadeIn(delay: 800.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeDisplay(String code) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.electricPurple.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.electricPurple.withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Text(
        code,
        style: GoogleFonts.orbitron(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 8,
          shadows: [
            Shadow(
              color: AppTheme.electricPurple,
              blurRadius: 20,
            ),
            Shadow(
              color: AppTheme.neonCyan,
              blurRadius: 40,
            ),
          ],
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true))
       .custom(
         duration: 2000.ms,
         builder: (context, value, child) => Opacity(
           opacity: 0.8 + (value * 0.2), // Pulse opacity between 0.8 and 1.0
           child: child,
         ),
       ),
    ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack);
  }
}
