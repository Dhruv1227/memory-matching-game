part of '../app.dart';

class _StartScreen extends StatelessWidget {
  const _StartScreen({
    required this.difficulty,
    required this.themeChoice,
    required this.bestRecords,
    required this.previewCards,
    required this.formatTime,
    required this.onDifficultyChanged,
    required this.onThemeChanged,
    required this.onStart,
    required this.onHowToPlay,
    required this.onHistory,
  });

  final Difficulty difficulty;
  final CardThemeChoice themeChoice;
  final Map<Difficulty, ScoreRecord> bestRecords;
  final List<GameCard> previewCards;
  final String Function(int seconds) formatTime;
  final ValueChanged<Difficulty> onDifficultyChanged;
  final ValueChanged<CardThemeChoice> onThemeChanged;
  final VoidCallback onStart;
  final VoidCallback onHowToPlay;
  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 860;
        return DecoratedBox(
          decoration: const BoxDecoration(color: Color(0xFFF5F1E8)),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              isWide ? 36 : 20,
              24,
              isWide ? 36 : 20,
              28,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: _StartControlPanel(
                              difficulty: difficulty,
                              themeChoice: themeChoice,
                              bestRecords: bestRecords,
                              formatTime: formatTime,
                              onDifficultyChanged: onDifficultyChanged,
                              onThemeChanged: onThemeChanged,
                              onStart: onStart,
                              onHowToPlay: onHowToPlay,
                              onHistory: onHistory,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            flex: 4,
                            child: _PreviewPanel(
                              cards: previewCards,
                              themeChoice: themeChoice,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _StartControlPanel(
                            difficulty: difficulty,
                            themeChoice: themeChoice,
                            bestRecords: bestRecords,
                            formatTime: formatTime,
                            onDifficultyChanged: onDifficultyChanged,
                            onThemeChanged: onThemeChanged,
                            onStart: onStart,
                            onHowToPlay: onHowToPlay,
                            onHistory: onHistory,
                          ),
                          const SizedBox(height: 18),
                          _PreviewPanel(
                            cards: previewCards,
                            themeChoice: themeChoice,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StartControlPanel extends StatelessWidget {
  const _StartControlPanel({
    required this.difficulty,
    required this.themeChoice,
    required this.bestRecords,
    required this.formatTime,
    required this.onDifficultyChanged,
    required this.onThemeChanged,
    required this.onStart,
    required this.onHowToPlay,
    required this.onHistory,
  });

  final Difficulty difficulty;
  final CardThemeChoice themeChoice;
  final Map<Difficulty, ScoreRecord> bestRecords;
  final String Function(int seconds) formatTime;
  final ValueChanged<Difficulty> onDifficultyChanged;
  final ValueChanged<CardThemeChoice> onThemeChanged;
  final VoidCallback onStart;
  final VoidCallback onHowToPlay;
  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .82),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0D8C8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.grid_view_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Memory Match',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            _ControlLabel(
              icon: Icons.speed_rounded,
              label: 'Difficulty',
              trailing: '${difficulty.pairs} pairs',
            ),
            const SizedBox(height: 10),
            _DifficultySelector(
              selected: difficulty,
              onChanged: onDifficultyChanged,
            ),
            const SizedBox(height: 22),
            _ControlLabel(
              icon: Icons.palette_rounded,
              label: 'Card Theme',
              trailing: themeChoice.label,
            ),
            const SizedBox(height: 10),
            _ThemeSelector(selected: themeChoice, onChanged: onThemeChanged),
            const SizedBox(height: 22),
            _BestRecordsStrip(bestRecords: bestRecords, formatTime: formatTime),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start Game'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onHowToPlay,
                    icon: const Icon(Icons.help_outline_rounded),
                    label: const Text('How To Play'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onHistory,
                    icon: const Icon(Icons.history_rounded),
                    label: const Text('History'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlLabel extends StatelessWidget {
  const _ControlLabel({
    required this.icon,
    required this.label,
    required this.trailing,
  });

  final IconData icon;
  final String label;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        const Spacer(),
        Text(
          trailing,
          style: TextStyle(
            color: Colors.black.withValues(alpha: .55),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _PreviewPanel extends StatelessWidget {
  const _PreviewPanel({required this.cards, required this.themeChoice});

  final List<GameCard> cards;
  final CardThemeChoice themeChoice;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF172C2A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(themeChoice.icon, color: const Color(0xFFF0B84C)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${themeChoice.label} Preview',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cards.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: .92,
              ),
              itemBuilder: (context, index) {
                final card = cards[index];
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _CardFront(visual: card.visual),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
