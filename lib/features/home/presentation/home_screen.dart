
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:insonmode_fluter/core/theme/app_theme.dart';
import 'package:insonmode_fluter/core/widgets/glass_card.dart';
import 'package:insonmode_fluter/core/widgets/neon_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              const SizedBox(height: 40),

              // Focus Score Centerpiece
              Center(
                child: _buildFocusScoreCircle(),
              ),
              const SizedBox(height: 50),

              // Missions Section
              Text(
                "MISSIONS",
                style: GoogleFonts.orbitron(
                  fontSize: 18,
                  color: AppTheme.neonCyan,
                  letterSpacing: 2,
                ),
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 20),
              _buildMissionsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Xayrli tun,",
          style: GoogleFonts.inter(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Azizbek",
          style: GoogleFonts.orbitron(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildFocusScoreCircle() {
    return CustomPaint(
      size: const Size(280, 280),
      painter: FocusScorePainter(percentage: 0.85),
      child: SizedBox(
        width: 280,
        height: 280,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "85%",
              style: GoogleFonts.orbitron(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  const Shadow(
                    color: AppTheme.neonCyan,
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "FOCUS SCORE",
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white50,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    ).animate().scale(duration: 800.ms, curve: Curves.easeOutBack);
  }

  Widget _buildMissionsList() {
    final missions = [
      "Instagram Algorithm Shift",
      "Dopamine Detox",
      "Deep Work Session",
      "Morning Meditation",
    ];

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: missions.length,
        separatorBuilder: (c, i) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return GlassCard(
            width: 160,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.electricPurple.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.bolt, // Using standard icon as placeholder for Lucide
                    color: AppTheme.electricPurple,
                    size: 24,
                  ),
                ),
                Text(
                  missions[index],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.electricPurple,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.electricPurple.withOpacity(0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate(delay: (200 * index).ms).fadeIn().slideX(begin: 0.2, end: 0);
        },
      ),
    );
  }
}

class FocusScorePainter extends CustomPainter {
  final double percentage;

  FocusScorePainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 15.0;

    // 1. Background Track
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // 2. Neon Glow (Behind)
    final glowPaint = Paint()
      ..color = AppTheme.neonCyan.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 10
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    final sweepAngle = 2 * pi * percentage;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      glowPaint,
    );

    // 3. Progress Arc (Sharp)
    final progressPaint = Paint()
      ..color = AppTheme.neonCyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    // 4. White Cap at the end
    final capAngle = -pi / 2 + sweepAngle;
    final capX = center.dx + radius * cos(capAngle);
    final capY = center.dy + radius * sin(capAngle);
    
    canvas.drawCircle(
      Offset(capX, capY),
      strokeWidth / 2,
      Paint()..color = Colors.white..maskFilter = const MaskFilter.blur(BlurStyle.solid, 4),
    );
     canvas.drawCircle(
      Offset(capX, capY),
      strokeWidth / 4,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant FocusScorePainter oldDelegate) =>
      oldDelegate.percentage != percentage;
}
