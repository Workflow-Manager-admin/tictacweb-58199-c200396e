import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToeApp());
}

// PUBLIC_INTERFACE
class TicTacToeApp extends StatelessWidget {
  /// This is the root widget for the Tic Tac Toe app.
  const TicTacToeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF1976D2),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF1976D2),
          secondary: const Color(0xFF43A047),
          surface: Colors.white,
          background: Colors.white,
          error: Colors.red.shade700,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onError: Colors.white,
          onBackground: Colors.black,
          onSurface: Colors.black,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFFB300),
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 26,
            color: Color(0xFF1976D2),
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 19,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        useMaterial3: true,
      ),
      home: const TicTacToeHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Enum to represent the player type
enum Player { none, x, o }

// Enum to represent the game status
enum GameStatus { playing, won, draw }

// PUBLIC_INTERFACE
class TicTacToeHomePage extends StatefulWidget {
  /// Home page widget containing the Tic Tac Toe game UI.
  const TicTacToeHomePage({Key? key}) : super(key: key);

  @override
  State<TicTacToeHomePage> createState() => _TicTacToeHomePageState();
}

class _TicTacToeHomePageState extends State<TicTacToeHomePage> {
  late List<List<Player>> _board;
  late Player _currentTurn;
  late Player _startingPlayer;
  late GameStatus _status;
  late List<int> _winningLine; // To highlight the winning cells
  int _scoreX = 0;
  int _scoreO = 0;

  @override
  void initState() {
    super.initState();
    _startingPlayer = Player.x;
    _resetBoard();
  }

  /// Resets the tic tac toe board to a new game state.
  void _resetBoard({bool resetScore = false}) {
    setState(() {
      _board = List.generate(3, (_) => List.generate(3, (_) => Player.none));
      _currentTurn = _startingPlayer;
      _status = GameStatus.playing;
      _winningLine = [];
      if (resetScore) {
        _scoreX = 0;
        _scoreO = 0;
      }
    });
  }

  /// Handles tapping on a cell in the board.
  void _handleTap(int row, int col) {
    if (_status != GameStatus.playing || _board[row][col] != Player.none) {
      return;
    }
    setState(() {
      _board[row][col] = _currentTurn;
      // Check for win/draw
      final winInfo = _checkWin();
      if (winInfo['winner'] != Player.none) {
        _status = GameStatus.won;
        _winningLine = winInfo['winningLine'] ?? [];
        if (_currentTurn == Player.x) {
          _scoreX++;
        } else {
          _scoreO++;
        }
      } else if (_isBoardFull()) {
        _status = GameStatus.draw;
      } else {
        _currentTurn = _currentTurn == Player.x ? Player.o : Player.x;
      }
    });
  }

  /// Checks if the board is full with no empty spots.
  bool _isBoardFull() {
    for (var row in _board) {
      for (var cell in row) {
        if (cell == Player.none) return false;
      }
    }
    return true;
  }

  /// Checks the board for win condition.
  ///
  /// Returns a map with `winner` (Player) and `winningLine` (indices) if win, or none.
  Map<String, dynamic> _checkWin() {
    // Rows, columns and diagonals
    final lines = <List<int>>[
      // Rows
      [0, 0, 0, 1, 0, 2],
      [1, 0, 1, 1, 1, 2],
      [2, 0, 2, 1, 2, 2],
      // Columns
      [0, 0, 1, 0, 2, 0],
      [0, 1, 1, 1, 2, 1],
      [0, 2, 1, 2, 2, 2],
      // Diagonals
      [0, 0, 1, 1, 2, 2],
      [0, 2, 1, 1, 2, 0],
    ];

    for (var line in lines) {
      final a = _board[line[0]][line[1]];
      final b = _board[line[2]][line[3]];
      final c = _board[line[4]][line[5]];

      if (a != Player.none && a == b && b == c) {
        return {
          'winner': a,
          'winningLine': [line[0] * 3 + line[1], line[2] * 3 + line[3], line[4] * 3 + line[5]],
        };
      }
    }
    return {'winner': Player.none};
  }

  /// Handles selecting the starting player.
  void _handleSelectPlayer(Player player) {
    if (_startingPlayer != player) {
      setState(() {
        _startingPlayer = player;
        _resetBoard();
      });
    }
  }

  /// Returns a [String] representation for a [Player].
  String _playerSymbol(Player player) {
    switch (player) {
      case Player.x:
        return 'X';
      case Player.o:
        return 'O';
      case Player.none:
      default:
        return '';
    }
  }

  /// Returns the color used to display a [Player] mark.
  Color _playerColor(Player player, BuildContext context) {
    switch (player) {
      case Player.x:
        return Theme.of(context).colorScheme.primary;
      case Player.o:
        return Theme.of(context).colorScheme.secondary;
      case Player.none:
      default:
        return Colors.transparent;
    }
  }

  /// Returns a minimal icon for the player's turn indicator.
  IconData _playerIcon(Player player) {
    switch (player) {
      case Player.x:
        return Icons.close;
      case Player.o:
        return Icons.radio_button_unchecked;
      case Player.none:
      default:
        return Icons.help_outline;
    }
  }

  /// Shows a simple dialog displaying the outcome (win/draw).
  void _showOutcomeDialog(String message) {
    // Not shown automatically; result is displayed inline at the top for minimalism
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = const Color(0xFFFFB300);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tic Tac Toe",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Outcome message panel
            Padding(
              padding: const EdgeInsets.only(top: 28.0, bottom: 6),
              child: _status == GameStatus.playing
                  ? _buildTurnIndicator(theme)
                  : _buildResultBanner(theme),
            ),
            // Score panel
            _buildScorePanel(theme),
            const SizedBox(height: 20),
            // Player selection panel
            _buildPlayerSelection(theme),
            const SizedBox(height: 18),
            // Centered tic tac toe board
            Expanded(
              flex: 3,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: _buildBoard(theme),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: _buildActionButtons(theme, accentColor),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds turn indicator widget for the top panel.
  Widget _buildTurnIndicator(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          _playerIcon(_currentTurn),
          color: _playerColor(_currentTurn, context),
          size: 26,
        ),
        const SizedBox(width: 10),
        Text(
          'Turn: ${_playerSymbol(_currentTurn)}',
          style: theme.textTheme.headlineMedium,
        ),
      ],
    );
  }

  /// Builds result banner (win or draw).
  Widget _buildResultBanner(ThemeData theme) {
    String message;
    Color color = const Color(0xFF1976D2); // Default

    if (_status == GameStatus.draw) {
      message = "It's a Draw!";
      color = Colors.grey[600]!;
    } else {
      final winner = _playerSymbol(_currentTurn);
      message = "Player $winner Wins!";
      color = _playerColor(_currentTurn, context);
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        message,
        style: theme.textTheme.headlineMedium!.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Builds the score panel widget showing X and O scores.
  Widget _buildScorePanel(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50]!,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200]!,
              offset: const Offset(0, 1),
              blurRadius: 5,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _scoreTile('X', _scoreX, theme.colorScheme.primary),
            const SizedBox(width: 6),
            _scoreTile('O', _scoreO, theme.colorScheme.secondary),
          ],
        ),
      ),
    );
  }

  /// Helper to make a neatly styled score tile.
  Widget _scoreTile(String label, int score, Color color) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(width: 3),
        Text(
          score.toString(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        )
      ],
    );
  }

  /// Builds the player X/O selection buttons.
  Widget _buildPlayerSelection(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _playerPickerButton(Player.x, theme),
        const SizedBox(width: 16),
        _playerPickerButton(Player.o, theme),
      ],
    );
  }

  /// Builds an individual player picker button.
  Widget _playerPickerButton(Player player, ThemeData theme) {
    final selected = _startingPlayer == player;
    final color = selected
        ? _playerColor(player, context)
        : Colors.grey[300]!;

    return GestureDetector(
      onTap: () => _handleSelectPlayer(player),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 28),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? _playerColor(player, context)
                : Colors.grey[400]!,
            width: selected ? 2 : 1,
          ),
        ),
        child: Text(
          _playerSymbol(player),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : Colors.black87,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  /// Builds the main tic tac toe board.
  Widget _buildBoard(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(12.0),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 7,
          crossAxisSpacing: 7,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          final row = index ~/ 3;
          final col = index % 3;
          final player = _board[row][col];

          bool isWinningCell = _winningLine.contains(index);

          return GestureDetector(
            onTap: () => _handleTap(row, col),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeIn,
              decoration: BoxDecoration(
                color: isWinningCell
                    ? (_playerColor(player, context)).withOpacity(0.16)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: isWinningCell
                      ? _playerColor(player, context)
                      : theme.colorScheme.primary.withOpacity(0.2),
                  width: isWinningCell ? 2.6 : 1,
                ),
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: player == Player.none
                      ? const SizedBox.shrink()
                      : Icon(
                          _playerIcon(player),
                          key: ValueKey(player),
                          size: 46,
                          color: _playerColor(player, context),
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds action buttons panel: restart and new game.
  Widget _buildActionButtons(ThemeData theme, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 12, left: 28, right: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _minimalTextButton(
            icon: Icons.refresh_rounded,
            label: (_status == GameStatus.playing) ? "Restart" : "Play Again",
            color: accentColor,
            onTap: () => _resetBoard(),
          ),
          _minimalTextButton(
            icon: Icons.fiber_new_rounded,
            label: "New Game",
            color: theme.colorScheme.primary,
            onTap: () => _resetBoard(resetScore: true),
          ),
        ],
      ),
    );
  }

  /// Reusable minimal text button with icon for action panel.
  Widget _minimalTextButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return SizedBox(
      width: 134,
      height: 46,
      child: Material(
        borderRadius: BorderRadius.circular(17),
        color: color.withOpacity(0.12),
        child: InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 23, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.5,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

