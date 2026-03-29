import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/extension/extension_method.dart';
import 'package:daily_language/core/utils/utils.dart';
import 'package:flutter/material.dart';

class MicListeningWidget extends StatefulWidget {
  final bool isLoading;
  final VoidCallback? onStop;

  const MicListeningWidget({super.key, this.isLoading = false, this.onStop});

  @override
  State<MicListeningWidget> createState() => _MicListeningWidgetState();
}

class _MicListeningWidgetState extends State<MicListeningWidget>
    with TickerProviderStateMixin {
  static const _barCount = 5;
  static const _minHeight = 8.0;
  static const _maxHeight = 44.0;

  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  static const _durations = [
    Duration(milliseconds: 520),
    Duration(milliseconds: 380),
    Duration(milliseconds: 600),
    Duration(milliseconds: 440),
    Duration(milliseconds: 500),
  ];

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(_barCount, (i) {
      return AnimationController(vsync: this, duration: _durations[i]);
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: _minHeight,
        end: _maxHeight,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    }).toList();

    for (var i = 0; i < _barCount; i++) {
      Future.delayed(Duration(milliseconds: i * 80), () {
        if (mounted) _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppCircularProgressIndicator(),
          SizedBox(height: 24),
          Text(
            context.l10n.processing,
            style: TextStyle(
              color: ColorApp.primary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PulsingMicIcon(),
        const SizedBox(height: 24),
        SizedBox(
          height: _maxHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(_barCount, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AnimatedBuilder(
                  animation: _animations[i],
                  builder: (_, __) {
                    return Container(
                      width: 6,
                      height: _animations[i].value,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: const LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [ColorApp.primary, ColorApp.secondary],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          context.l10n.listening,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: ColorApp.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          context.l10n.speakNow,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: ColorApp.taupeGray),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        GestureDetector(
          onTap: widget.onStop,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: ColorApp.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: ColorApp.primary.withAlpha(80),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stop_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  context.l10n.stopRecording,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Private: pulsing glow behind mic icon
// ---------------------------------------------------------------------------
class _PulsingMicIcon extends StatefulWidget {
  @override
  State<_PulsingMicIcon> createState() => _PulsingMicIconState();
}

class _PulsingMicIconState extends State<_PulsingMicIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (_, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorApp.primary.withAlpha(20),
        ),
        child: Center(
          child: Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: ColorApp.primary,
            ),
            child: const Icon(Icons.mic, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}
