part of '../app.dart';

class _MemoryCardTile extends StatelessWidget {
  const _MemoryCardTile({
    required this.card,
    required this.themeChoice,
    required this.onTap,
  });

  final GameCard card;
  final CardThemeChoice themeChoice;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final showFront = card.isFaceUp || card.isMatched;
    final label = card.isMatched
        ? 'Matched ${card.visual.label} card'
        : showFront
        ? '${card.visual.label} card'
        : 'Hidden ${card.visual.label} card';

    return Semantics(
      label: label,
      button: !showFront,
      child: GestureDetector(
        onTap: onTap,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(end: showFront ? 1 : 0),
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            final isFront = value > .5;
            final rotation = value * pi;
            return AnimatedOpacity(
              opacity: card.isMatched ? .72 : 1,
              duration: const Duration(milliseconds: 220),
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(rotation),
                alignment: Alignment.center,
                child: Transform(
                  transform: Matrix4.identity()..rotateY(isFront ? pi : 0),
                  alignment: Alignment.center,
                  child: isFront
                      ? _CardFront(visual: card.visual)
                      : _CardBack(themeChoice: themeChoice),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PausedCardTile extends StatelessWidget {
  const _PausedCardTile();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF172C2A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(
          Icons.pause_circle_filled_rounded,
          color: Color(0xFFF0B84C),
          size: 42,
        ),
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  const _CardBack({required this.themeChoice});

  final CardThemeChoice themeChoice;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF172C2A),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .16),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _CardPatternPainter()),
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .12),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  themeChoice.icon,
                  color: const Color(0xFFF0B84C),
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: .08)
      ..strokeWidth = 2;
    const spacing = 18.0;

    for (var x = -size.height; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CardFront extends StatelessWidget {
  const _CardFront({required this.visual});

  final CardVisual visual;

  @override
  Widget build(BuildContext context) {
    final asset = visual.asset;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: visual.color.withValues(alpha: .18),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: visual.color.withValues(alpha: .16),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: asset == null
                  ? DecoratedBox(
                      decoration: BoxDecoration(
                        color: visual.accent.withValues(alpha: .18),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(visual.icon, size: 46, color: visual.color),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        asset,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        semanticLabel: visual.label,
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                visual.label,
                maxLines: 1,
                style: TextStyle(
                  color: visual.color,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BestRecordsStrip extends StatelessWidget {
  const _BestRecordsStrip({
    required this.bestRecords,
    required this.formatTime,
  });

  final Map<Difficulty, ScoreRecord> bestRecords;
  final String Function(int seconds) formatTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ControlLabel(
          icon: Icons.emoji_events_rounded,
          label: 'Best Scores',
          trailing: 'This session',
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: Difficulty.values.map((difficulty) {
            final record = bestRecords[difficulty];
            return _BestRecordPill(
              difficulty: difficulty,
              record: record,
              formatTime: formatTime,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _BestRecordPill extends StatelessWidget {
  const _BestRecordPill({
    required this.difficulty,
    required this.record,
    required this.formatTime,
  });

  final Difficulty difficulty;
  final ScoreRecord? record;
  final String Function(int seconds) formatTime;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final label = record == null
        ? 'No score'
        : '${record!.score} • ${formatTime(record!.seconds)}';
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F4EA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE6DDCB)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(difficulty.icon, size: 17, color: color),
            const SizedBox(width: 6),
            Text(
              '${difficulty.label}: ',
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}
