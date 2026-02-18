import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:insonmode_fluter/core/theme/app_theme.dart';
import 'package:insonmode_fluter/core/widgets/glass_card.dart';
import 'package:insonmode_fluter/core/widgets/neon_button.dart';
import 'package:insonmode_fluter/features/missions/models/mission.dart';

class MissionCard extends StatefulWidget {
  final Mission mission;
  final VoidCallback? onXpClaimed;

  const MissionCard({
    super.key,
    required this.mission,
    this.onXpClaimed,
  });

  @override
  State<MissionCard> createState() => _MissionCardState();
}

class _MissionCardState extends State<MissionCard> with WidgetsBindingObserver {
  bool _isMissionStarted = false;
  bool _canClaimXp = false;
  bool _isXpClaimed = false;
  Timer? _timer;
  bool _showXpAnimation = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the user returns to the app after starting the mission, allow claiming immediately (or check time)
    if (state == AppLifecycleState.resumed && _isMissionStarted && !_isXpClaimed) {
       // For simplicity, we assume if they come back, they might have done it.
       // In a real app, maybe check elapsed time.
       if (mounted) {
         setState(() {
           _canClaimXp = true;
         });
       }
    }
  }

  Future<void> _startMission() async {
    final uri = Uri.parse(widget.mission.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (mounted) {
        setState(() {
          _isMissionStarted = true;
        });
        
        // Start a timer to enable claim button after 10 seconds just in case they stay in app
        _timer = Timer(const Duration(seconds: 10), () {
          if (mounted && !_isXpClaimed) {
             setState(() {
               _canClaimXp = true;
             });
          }
        });
      }
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch mission URL")),
      );
    }
  }

  void _claimXp() {
    setState(() {
      _isXpClaimed = true;
      _showXpAnimation = true;
    });
    
    // Notify parent
    widget.onXpClaimed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Expanded(
                     child: Text(
                      widget.mission.title,
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                  ),
                   ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.neonCyan.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.neonCyan),
                    ),
                    child: Text(
                      "+${widget.mission.xp} XP",
                      style: GoogleFonts.inter(
                        color: AppTheme.neonCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              Row(
                children: [
                  Expanded(
                    child: NeonButton(
                      text: "START MISSION",
                      onTap: _isMissionStarted ? null : _startMission, // Disable if started (or keep enabled to re-open)
                      color: _isMissionStarted ? Colors.grey : AppTheme.electricPurple,
                      height: 40,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: NeonButton(
                      text: _isXpClaimed ? "CLAIMED" : "CLAIM XP",
                      onTap: (_canClaimXp && !_isXpClaimed) ? _claimXp : null,
                      color: (_canClaimXp && !_isXpClaimed) ? AppTheme.neonCyan : Colors.grey.withOpacity(0.3),
                      height: 40,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Floating XP Animation
        if (_showXpAnimation)
          Positioned(
            top: -20,
            right: 20,
            child: Text(
              "+${widget.mission.xp} XP",
              style: GoogleFonts.orbitron(
                color: AppTheme.neonCyan,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  const Shadow(
                    color: AppTheme.neonCyan,
                    blurRadius: 20,
                  ),
                ],
              ),
            )
            .animate()
            .moveY(begin: 0, end: -100, duration: 1500.ms, curve: Curves.easeOut)
            .fadeOut(delay: 800.ms, duration: 700.ms),
          ),
      ],
    );
  }
}
