part of '../app.dart';

class _GameHeader extends StatelessWidget {
  const _GameHeader({
    required this.moves,
    required this.matches,
    required this.totalPairs,
    required this.time,
    required this.bestRecord,
    required this.difficulty,
    required this.themeChoice,
    required this.progress,
    required this.isWide,
    required this.isPaused,
    required this.formatTime,
    required this.onRestart,
    required this.onPause,
    required this.onHowToPlay,
    required this.onHistory,
    required this.onDifficultyChanged,
    required this.onThemeChanged,
  });

  final int moves;
  final int matches;
  final int totalPairs;
  final String time;
  final ScoreRecord? bestRecord;
  final Difficulty difficulty;
  final CardThemeChoice themeChoice;
  final double progress;
  final bool isWide;
  final bool isPaused;
  final String Function(int seconds) formatTime;
  final VoidCallback onRestart;
  final VoidCallback onPause;
  final VoidCallback onHowToPlay;
  final VoidCallback onHistory;
  final ValueChanged<Difficulty> onDifficultyChanged;
  final ValueChanged<CardThemeChoice> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bestLabel = bestRecord == null
        ? 'No best yet'
        : '${bestRecord!.score} / ${formatTime(bestRecord!.seconds)}';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0D8C8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: isWide ? 310 : double.infinity,
                  child: Row(
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
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Memory Match',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _DifficultySelector(
                  selected: difficulty,
                  onChanged: onDifficultyChanged,
                ),
                _ThemeSelector(
                  selected: themeChoice,
                  onChanged: onThemeChanged,
                  compact: true,
                ),
                _RoundIconButton(
                  tooltip: isPaused ? 'Resume' : 'Pause',
                  icon: isPaused
                      ? Icons.play_arrow_rounded
                      : Icons.pause_rounded,
                  onPressed: onPause,
                ),
                _RoundIconButton(
                  tooltip: 'Restart',
                  icon: Icons.restart_alt_rounded,
                  onPressed: onRestart,
                ),
                _RoundIconButton(
                  tooltip: 'How to play',
                  icon: Icons.help_outline_rounded,
                  onPressed: onHowToPlay,
                ),
                _RoundIconButton(
                  tooltip: 'Score history',
                  icon: Icons.history_rounded,
                  onPressed: onHistory,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 10,
                value: progress,
                backgroundColor: const Color(0xFFE7DDC9),
                valueColor: AlwaysStoppedAnimation<Color>(
                  colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _StatPanel(
                  label: 'Moves',
                  value: moves.toString(),
                  icon: Icons.touch_app_rounded,
                ),
                _StatPanel(
                  label: 'Time',
                  value: time,
                  icon: Icons.timer_rounded,
                ),
                _StatPanel(
                  label: 'Pairs',
                  value: '$matches/$totalPairs',
                  icon: Icons.check_circle_rounded,
                ),
                _StatPanel(
                  label: 'Best',
                  value: bestLabel,
                  icon: Icons.emoji_events_rounded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultySelector extends StatelessWidget {
  const _DifficultySelector({required this.selected, required this.onChanged});

  final Difficulty selected;
  final ValueChanged<Difficulty> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Difficulty>(
      showSelectedIcon: false,
      segments: Difficulty.values
          .map(
            (difficulty) => ButtonSegment<Difficulty>(
              value: difficulty,
              label: Text(difficulty.label),
              icon: Icon(difficulty.icon, size: 18),
            ),
          )
          .toList(),
      selected: {selected},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({
    required this.selected,
    required this.onChanged,
    this.compact = false,
  });

  final CardThemeChoice selected;
  final ValueChanged<CardThemeChoice> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: CardThemeChoice.values.map((themeChoice) {
        final isSelected = selected == themeChoice;
        return ChoiceChip(
          selected: isSelected,
          avatar: Icon(themeChoice.icon, size: 18),
          label: Text(compact && !isSelected ? '' : themeChoice.label),
          labelPadding: compact && !isSelected
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 4),
          onSelected: (_) => onChanged(themeChoice),
          visualDensity: compact
              ? VisualDensity.compact
              : VisualDensity.standard,
        );
      }).toList(),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton.filledTonal(onPressed: onPressed, icon: Icon(icon)),
    );
  }
}

class _StatPanel extends StatelessWidget {
  const _StatPanel({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFF8F4EA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE6DDCB)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.black.withValues(alpha: .55),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
