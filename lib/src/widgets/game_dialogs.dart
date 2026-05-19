part of '../app.dart';

class _WinDialog extends StatelessWidget {
  const _WinDialog({
    required this.score,
    required this.moves,
    required this.time,
    required this.rating,
    required this.isNewBest,
    required this.bestRecord,
    required this.onPlayAgain,
    required this.onHistory,
  });

  final int score;
  final int moves;
  final String time;
  final int rating;
  final bool isNewBest;
  final ScoreRecord? bestRecord;
  final VoidCallback onPlayAgain;
  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.emoji_events_rounded, color: Color(0xFFF0B84C)),
          const SizedBox(width: 8),
          Expanded(child: Text(isNewBest ? 'New Best Score' : 'You Won')),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Icon(
                index < rating ? Icons.star_rounded : Icons.star_border_rounded,
                color: const Color(0xFFF0B84C),
                size: 34,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _DialogMetric(label: 'Score', value: score.toString()),
          _DialogMetric(label: 'Moves', value: moves.toString()),
          _DialogMetric(label: 'Time', value: time),
          if (bestRecord != null)
            _DialogMetric(label: 'Best', value: bestRecord!.score.toString()),
        ],
      ),
      actions: [
        TextButton.icon(
          onPressed: onHistory,
          icon: const Icon(Icons.history_rounded),
          label: const Text('History'),
        ),
        FilledButton.icon(
          onPressed: onPlayAgain,
          icon: const Icon(Icons.replay_rounded),
          label: const Text('Play Again'),
        ),
      ],
    );
  }
}

class _DialogMetric extends StatelessWidget {
  const _DialogMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _HistoryDialog extends StatelessWidget {
  const _HistoryDialog({required this.history, required this.formatTime});

  final List<RoundResult> history;
  final String Function(int seconds) formatTime;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Score History'),
      content: SizedBox(
        width: 360,
        child: history.isEmpty
            ? const Text('No completed rounds yet.')
            : ListView.separated(
                shrinkWrap: true,
                itemCount: history.length,
                separatorBuilder: (_, _) => const Divider(height: 18),
                itemBuilder: (context, index) {
                  final result = history[index];
                  return Row(
                    children: [
                      Icon(result.difficulty.icon),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${result.difficulty.label} • ${result.theme.label}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              '${result.moves} moves • ${formatTime(result.seconds)}',
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            result.score.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              3,
                              (star) => Icon(
                                star < result.rating
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                color: const Color(0xFFF0B84C),
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
