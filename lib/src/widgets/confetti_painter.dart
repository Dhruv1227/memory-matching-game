part of '../app.dart';

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.animation, required this.particles})
    : super(repaint: animation);

  final Animation<double> animation;
  final List<ConfettiParticle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    final t = animation.value;
    if (t == 0) return;

    for (final particle in particles) {
      final local = ((t - particle.delay) / (1 - particle.delay)).clamp(
        0.0,
        1.0,
      );
      if (local <= 0 || local >= 1) continue;

      final opacity = (1 - local).clamp(0.0, 1.0);
      final paint = Paint()..color = particle.color.withValues(alpha: opacity);
      final x = (particle.x + particle.drift * local) * size.width;
      final y = (local * particle.speed * size.height) - 24;
      final rect = Rect.fromCenter(
        center: Offset(x, y),
        width: particle.size,
        height: particle.size * .58,
      );

      canvas.save();
      canvas.translate(rect.center.dx, rect.center.dy);
      canvas.rotate(particle.spin + local * pi * 3);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: rect.width,
            height: rect.height,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.particles != particles;
  }
}
