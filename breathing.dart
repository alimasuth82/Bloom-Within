import 'package:flutter/material.dart';

// --- Option Data Class ---
// Represents a labeled option that navigates to a corresponding page
class Option {
  final String label;
  final Widget page;

  const Option({required this.label, required this.page});
}

// --- Breathing Exercises Screen ---
// Displays a list of breathing exercise techniques the user can choose from
class BreathingExercises extends StatelessWidget {
  const BreathingExercises({super.key});

  // List of available breathing exercises
  static const List<Option> options = [
    Option(label: "Box Breathing", page: BoxBreathing()),
    Option(label: "4-7-8 Breathing", page: FourSevenEightBreathing()),
    Option(label: "Deep Belly Breathing", page: DeepBellyBreathing())
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text("Breathing Exercises", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 32),

            // Build a styled button for each breathing exercise option
            for (final option in options)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the corresponding breathing exercise page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => option.page),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.surface,
                    foregroundColor: colorScheme.onSurface,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    option.label,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// --- Box Breathing Page ---
// A screen that guides the user through a calming box breathing animation
class BoxBreathing extends StatelessWidget {
  const BoxBreathing({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(
          "Box Breathing",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              "Box Breathing",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 24),

            // Breathing animation widget
            BoxBreathingAnimation(),
            const SizedBox(height: 32),

            // Instructional text
            Text(
              "Follow the circle as it expands and contracts. Inhale as it grows, exhale as it shrinks. Repeat for a few cycles to feel grounded.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
                color: colorScheme.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Box Breathing Animation ---
// A circular breathing animation that cycles through inhale, hold, exhale, and hold phases
class BoxBreathingAnimation extends StatefulWidget {
  @override
  State<BoxBreathingAnimation> createState() => _BoxBreathingAnimationState();
}

class _BoxBreathingAnimationState extends State<BoxBreathingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Controls the animation timing
  late Animation<double> _animation; // Controls the animated size of the circle
  int _phaseIndex = 0; // Keeps track of the current breathing phase

  // List of breathing phases and corresponding colors
  final List<String> _phases = ["Inhale", "Hold", "Exhale", "Hold"];
  final List<Color> _phaseColors = [
    Colors.green,
    Colors.blueGrey,
    Colors.orange,
    Colors.blueGrey,
  ];

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller with a 4-second duration
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // Define the animation's size range using a Tween
    _animation = Tween<double>(begin: 100, end: 200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start cycling through breathing phases
    _startPhaseCycle();
  }

  // Continuously cycle through the phases and control the animation accordingly
  void _startPhaseCycle() async {
    while (mounted) {
      setState(() {}); // Triggers rebuild to update phase text and color

      // Animate based on current phase
      if (_phases[_phaseIndex] == "Inhale") {
        await _controller.forward(); // Expand the circle
      }
      else if (_phases[_phaseIndex] == "Exhale") {
        await _controller.reverse(); // Shrink the circle
      }
      else {
        await Future.delayed(const Duration(seconds: 4)); // Hold phase
      }

      // Move to the next phase in the cycle
      _phaseIndex = (_phaseIndex + 1) % _phases.length;
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          children: [
            // The animated circle with dynamic size and color based on phase
            Container(
              width: _animation.value,
              height: _animation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _phaseColors[_phaseIndex].withOpacity(0.4),
              ),
              child: Center(
                child: Text(
                  _phases[_phaseIndex], // Display current phase (e.g., Inhale)
                  style: TextStyle(
                    fontSize: 20,
                    color: colorScheme.onBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}



// --- 4-7-8 Breathing Page ---
// This page introduces the user to the 4-7-8 breathing technique with an animated visual
class FourSevenEightBreathing extends StatelessWidget {
  const FourSevenEightBreathing({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        // App bar with title and consistent theming
        title: Text("4-7-8 Breathing", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title of the technique
              Text(
                "4-7-8 Breathing",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 24),

              // Animated breathing visual
              FourSevenEightAnimation(),

              const SizedBox(height: 32),

              // Instructional text describing the method
              Text(
                "Inhale for 4 seconds\nHold for 7 seconds\nExhale for 8 seconds\nRepeat to calm your nervous system.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  color: colorScheme.onBackground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Animated Visual for 4-7-8 Breathing Technique ---
class FourSevenEightAnimation extends StatefulWidget {
  @override
  State<FourSevenEightAnimation> createState() => _FourSevenEightAnimationState();
}

class _FourSevenEightAnimationState extends State<FourSevenEightAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _phaseIndex = 0;

  // Breathing phases and durations
  final List<String> _phases = ["Inhale", "Hold", "Exhale"];
  final List<int> _durations = [4, 7, 8]; // durations in seconds

  // Colors corresponding to each breathing phase
  final List<Color> _phaseColors = [
    Colors.green,
    Colors.blueGrey,
    Colors.orange,
  ];

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller with the first phase duration
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _durations[0]),
    );

    // Define the size animation (circle expansion and contraction)
    _animation = Tween<double>(begin: 100, end: 200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start cycling through the breathing phases
    _startPhaseCycle();
  }

  // Runs the breathing cycle repeatedly
  void _startPhaseCycle() async {
    while (mounted) {
      setState(() {}); // Refresh the UI with the current phase

      final currentPhase = _phases[_phaseIndex];
      final duration = _durations[_phaseIndex];

      // Handle animation based on current phase
      if (currentPhase == "Inhale") {
        _controller.duration = Duration(seconds: duration);
        await _controller.forward();
      }
      else if (currentPhase == "Exhale") {
        _controller.duration = Duration(seconds: duration);
        await _controller.reverse();
      }
      else {
        await Future.delayed(Duration(seconds: duration));
      }

      // Move to the next phase
      _phaseIndex = (_phaseIndex + 1) % _phases.length;
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up animation resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          children: [
            Container(
              width: _animation.value,
              height: _animation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _phaseColors[_phaseIndex].withOpacity(0.4),
              ),
              child: Center(
                child: Text(
                  _phases[_phaseIndex],
                  style: TextStyle(
                    fontSize: 20,
                    color: colorScheme.onBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}


// --- Deep Belly Breathing Exercise Screen ---
class DeepBellyBreathing extends StatelessWidget {
  const DeepBellyBreathing({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "Deep Belly Breathing",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Exercise title
            Text(
              "Deep Belly Breathing",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 24),

            // Animated breathing character
            FunnyBreathingPerson(),
            const SizedBox(height: 32),

            // Instructional text
            Text(
              "Watch the belly expand and contract as you breathe. Try placing a hand on your own belly as you breathe with the animation!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
                color: colorScheme.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FunnyBreathingPerson extends StatefulWidget {
  @override
  State<FunnyBreathingPerson> createState() => _FunnyBreathingPersonState();
}

class _FunnyBreathingPersonState extends State<FunnyBreathingPerson>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _phaseIndex = 0;

  // Breathing cycle phases and corresponding durations
  final List<String> _phases = ['Inhale', 'Hold', 'Exhale', 'Hold'];
  final List<int> _durations = [4, 2, 6, 2]; // seconds

  // Visual phase colors for the animated belly
  final List<Color> _phaseColors = [
    Color(0xFF81C784),  // Inhale
    Colors.blueGrey,    // Hold
    Colors.orange,      // Exhale
    Colors.blueGrey,    // Hold again
  ];

  @override
  void initState() {
    super.initState();

    // Set up animation controller with initial phase duration
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _durations[0]),
    );

    // Begin the breathing animation cycle
    _startBreathingCycle();
  }

  // Runs the breathing cycle repeatedly, updating phase and triggering animations
  void _startBreathingCycle() async {
    while (mounted) {
      setState(() {}); // Triggers UI update for current phase

      _controller.duration = Duration(seconds: _durations[_phaseIndex]);

      if (_phases[_phaseIndex] == 'Inhale') {
        await _controller.forward(); // Expand animation
      }
      else if (_phases[_phaseIndex] == 'Exhale') {
        await _controller.reverse(); // Contract animation
      }
      else {
        await Future.delayed(Duration(seconds: _durations[_phaseIndex])); // Hold
      }

      // Move to the next phase
      _phaseIndex = (_phaseIndex + 1) % _phases.length;
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Breathing animation (size change)
    final animation = Tween<double>(begin: 100, end: 180).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Column(
          children: [
            // Head
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 10),

            // Upper torso
            Container(
              width: 100,
              height: 80,
              color: colorScheme.primary,
            ),

            // Animated belly with phase label
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: animation.value,
                  height: animation.value,
                  decoration: BoxDecoration(
                    color: _phaseColors[_phaseIndex],
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                Text(
                  _phases[_phaseIndex],
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onBackground,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Legs
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 20, height: 60, color: colorScheme.primary),
                const SizedBox(width: 20),
                Container(width: 20, height: 60, color: colorScheme.primary),
              ],
            ),
          ],
        );
      },
    );
  }
}