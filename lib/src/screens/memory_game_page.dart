part of '../app.dart';

class MemoryGamePage extends StatefulWidget {
  const MemoryGamePage({super.key});

  @override
  State<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage>
    with SingleTickerProviderStateMixin {
  final _random = Random();
  Difficulty _difficulty = Difficulty.medium;
  CardThemeChoice _themeChoice = CardThemeChoice.classic;
  List<GameCard> _cards = [];
  List<int> _selected = [];
  final Map<Difficulty, ScoreRecord> _bestRecords = {};
  final List<RoundResult> _history = [];
  late final AnimationController _confettiController;
  late List<ConfettiParticle> _confettiParticles;
  Timer? _timer;
  int _seconds = 0;
  int _moves = 0;
  int _matches = 0;
  bool _hasStarted = false;
  bool _isPaused = false;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    _cards = _createDeck();
    _confettiParticles = _createConfetti();
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _confettiController.dispose();
    super.dispose();
  }

  List<GameCard> _createDeck() {
    final cards = <GameCard>[];
    final visuals = _themeChoice.visuals.take(_difficulty.pairs).toList();

    for (final visual in visuals) {
      cards
        ..add(GameCard(id: visual.id, visual: visual))
        ..add(GameCard(id: visual.id, visual: visual));
    }

    return cards..shuffle(_random);
  }

  List<ConfettiParticle> _createConfetti() {
    const colors = [
      Color(0xFFE96B56),
      Color(0xFFF0B84C),
      Color(0xFF0F6B5B),
      Color(0xFF2E5EAA),
      Color(0xFF6D5BD0),
    ];

    return List.generate(72, (index) {
      return ConfettiParticle(
        x: _random.nextDouble(),
        delay: _random.nextDouble() * .35,
        speed: .52 + _random.nextDouble() * .48,
        size: 5 + _random.nextDouble() * 9,
        color: colors[index % colors.length],
        spin: _random.nextDouble() * pi,
        drift: (_random.nextDouble() - .5) * .26,
      );
    });
  }

  void _startGame() {
    _timer?.cancel();
    setState(() {
      _hasStarted = true;
      _cards = _createDeck();
      _selected = [];
      _seconds = 0;
      _moves = 0;
      _matches = 0;
      _isPaused = false;
      _locked = false;
    });
    _startTimer();
    _playCue(GameCue.tap);
  }

  void _newGame() {
    _timer?.cancel();
    setState(() {
      _cards = _createDeck();
      _selected = [];
      _seconds = 0;
      _moves = 0;
      _matches = 0;
      _isPaused = false;
      _locked = false;
    });

    if (_hasStarted) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _hasStarted && !_isPaused) {
        setState(() => _seconds++);
      }
    });
  }

  void _togglePause() {
    if (!_hasStarted) return;

    setState(() => _isPaused = !_isPaused);
    if (_isPaused) {
      _timer?.cancel();
    } else {
      _startTimer();
    }
    _playCue(GameCue.tap);
  }

  Future<void> _tapCard(int index) async {
    final card = _cards[index];
    if (!_hasStarted ||
        _isPaused ||
        _locked ||
        card.isFaceUp ||
        card.isMatched) {
      return;
    }

    _playCue(GameCue.tap);
    setState(() {
      card.isFaceUp = true;
      _selected.add(index);
    });

    if (_selected.length != 2) {
      return;
    }

    setState(() {
      _moves++;
      _locked = true;
    });

    final first = _cards[_selected.first];
    final second = _cards[_selected.last];

    if (first.id == second.id) {
      await Future<void>.delayed(const Duration(milliseconds: 350));
      if (!mounted) return;
      _playCue(GameCue.match);
      setState(() {
        first.isMatched = true;
        second.isMatched = true;
        _matches++;
        _selected = [];
        _locked = false;
      });
      if (_matches == _difficulty.pairs) {
        _finishGame();
      }
    } else {
      await Future<void>.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      _playCue(GameCue.mismatch);
      setState(() {
        first.isFaceUp = false;
        second.isFaceUp = false;
        _selected = [];
        _locked = false;
      });
    }
  }

  void _finishGame() {
    _timer?.cancel();
    final score = _scoreForRound();
    final rating = _ratingForRound();
    final result = RoundResult(
      difficulty: _difficulty,
      theme: _themeChoice,
      score: score,
      moves: _moves,
      seconds: _seconds,
      rating: rating,
    );
    final record = ScoreRecord(
      difficulty: _difficulty,
      theme: _themeChoice,
      score: score,
      moves: _moves,
      seconds: _seconds,
      rating: rating,
    );
    final oldBest = _bestRecords[_difficulty];
    final isNewBest = oldBest == null || _isBetterRecord(record, oldBest);

    setState(() {
      if (isNewBest) {
        _bestRecords[_difficulty] = record;
      }
      _history.insert(0, result);
      if (_history.length > 8) {
        _history.removeRange(8, _history.length);
      }
    });

    _confettiParticles = _createConfetti();
    unawaited(_confettiController.forward(from: 0));
    _playCue(GameCue.win);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _WinDialog(
        score: score,
        moves: _moves,
        time: _formatTime(_seconds),
        rating: rating,
        isNewBest: isNewBest,
        bestRecord: _bestRecords[_difficulty],
        onPlayAgain: () {
          Navigator.of(context).pop();
          _newGame();
        },
        onHistory: () {
          Navigator.of(context).pop();
          _showHistory();
        },
      ),
    );
  }

  bool _isBetterRecord(ScoreRecord next, ScoreRecord current) {
    if (next.score != current.score) {
      return next.score > current.score;
    }
    if (next.moves != current.moves) {
      return next.moves < current.moves;
    }
    return next.seconds < current.seconds;
  }

  int _scoreForRound() {
    return max(
      1200 + (_difficulty.pairs * 12) - (_moves * 18) - (_seconds * 4),
      100,
    );
  }

  int _ratingForRound() {
    if (_moves <= _difficulty.pairs + 2 && _seconds <= _difficulty.pairs * 6) {
      return 3;
    }
    if (_moves <= _difficulty.pairs + 6 && _seconds <= _difficulty.pairs * 10) {
      return 2;
    }
    return 1;
  }

  void _setDifficulty(Difficulty difficulty) {
    if (_difficulty == difficulty) {
      return;
    }
    _timer?.cancel();
    setState(() {
      _difficulty = difficulty;
      _cards = _createDeck();
      _selected = [];
      _seconds = 0;
      _moves = 0;
      _matches = 0;
      _isPaused = false;
      _locked = false;
    });
    if (_hasStarted) {
      _startTimer();
    }
    _playCue(GameCue.tap);
  }

  void _setTheme(CardThemeChoice themeChoice) {
    if (_themeChoice == themeChoice) {
      return;
    }
    _timer?.cancel();
    setState(() {
      _themeChoice = themeChoice;
      _cards = _createDeck();
      _selected = [];
      _seconds = 0;
      _moves = 0;
      _matches = 0;
      _isPaused = false;
      _locked = false;
    });
    if (_hasStarted) {
      _startTimer();
    }
    _playCue(GameCue.tap);
  }

  void _playCue(GameCue cue) {
    unawaited(SystemSound.play(SystemSoundType.click));
    switch (cue) {
      case GameCue.tap:
        unawaited(HapticFeedback.selectionClick());
      case GameCue.match:
        unawaited(HapticFeedback.lightImpact());
      case GameCue.mismatch:
        unawaited(HapticFeedback.mediumImpact());
      case GameCue.win:
        unawaited(HapticFeedback.heavyImpact());
    }
  }

  void _showHowToPlay() {
    _playCue(GameCue.tap);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How To Play'),
        content: const Text(
          'Flip two cards at a time. Matching cards stay open. Finish all pairs '
          'with fewer moves and less time to earn a higher score and more stars.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showHistory() {
    _playCue(GameCue.tap);
    showDialog<void>(
      context: context,
      builder: (context) =>
          _HistoryDialog(history: _history, formatTime: _formatTime),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remaining = seconds % 60;
    return '$minutes:${remaining.toString().padLeft(2, '0')}';
  }

  int _columnsForWidth(double width) {
    if (width >= 1100) return 5;
    if (width >= 760) return 4;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasStarted) {
      return Scaffold(
        body: SafeArea(
          child: _StartScreen(
            difficulty: _difficulty,
            themeChoice: _themeChoice,
            bestRecords: _bestRecords,
            previewCards: _cards.take(6).toList(),
            formatTime: _formatTime,
            onDifficultyChanged: _setDifficulty,
            onThemeChanged: _setTheme,
            onStart: _startGame,
            onHowToPlay: _showHowToPlay,
            onHistory: _showHistory,
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final isWide = width >= 860;
                final columns = _columnsForWidth(width);
                final progress = _difficulty.pairs == 0
                    ? 0.0
                    : _matches / _difficulty.pairs;

                return DecoratedBox(
                  decoration: const BoxDecoration(color: Color(0xFFF5F1E8)),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            isWide ? 32 : 18,
                            18,
                            isWide ? 32 : 18,
                            8,
                          ),
                          child: _GameHeader(
                            moves: _moves,
                            matches: _matches,
                            totalPairs: _difficulty.pairs,
                            time: _formatTime(_seconds),
                            bestRecord: _bestRecords[_difficulty],
                            difficulty: _difficulty,
                            themeChoice: _themeChoice,
                            progress: progress,
                            isWide: isWide,
                            isPaused: _isPaused,
                            formatTime: _formatTime,
                            onRestart: _newGame,
                            onPause: _togglePause,
                            onHowToPlay: _showHowToPlay,
                            onHistory: _showHistory,
                            onDifficultyChanged: _setDifficulty,
                            onThemeChanged: _setTheme,
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          isWide ? 32 : 18,
                          12,
                          isWide ? 32 : 18,
                          28,
                        ),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            if (_isPaused) {
                              return const _PausedCardTile();
                            }
                            return _MemoryCardTile(
                              card: _cards[index],
                              themeChoice: _themeChoice,
                              onTap: () => _tapCard(index),
                            );
                          }, childCount: _cards.length),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: isWide ? 1.05 : .92,
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _ConfettiPainter(
                    animation: _confettiController,
                    particles: _confettiParticles,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
