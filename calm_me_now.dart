import 'package:bloom_within/soothing_sounds.dart';
import 'package:flutter/material.dart';

// --- Option Data Class ---
// A reusable class to store each menu option's label and corresponding page widget.
class Option {
  final String label; // Display text on the button
  final Widget page; // Widget to navigate to when the button is pressed

  const Option({required this.label, required this.page});
}

// --- Main Calm Me Now Page ---
class CalmMeNow extends StatelessWidget {
  const CalmMeNow({super.key});

  // List of all menu options with their labels and target pages
  static List<Option> options = [
    Option(label: "Breathe with Me", page: BreatheWithMe()),
    Option(label: "Let's Try Grounding", page: Grounding()),
    Option(label: "Hear a Kind Word", page: KindWord()),
    Option(label: "Play Soothing Sounds", page: SoothingSounds())
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme; // Use app theme colors

    return Scaffold(
      // --- App Bar ---
      appBar: AppBar(
        title: const Text(
          "Calm Me Now",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),

      // --- Main Background Color ---
      backgroundColor: colorScheme.background,

      // --- Body Padding ---
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Header Text ---
            Text(
              "Let's calm down together",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: colorScheme.onBackground,
              ),
            ),

            const SizedBox(height: 32), // Add vertical spacing

            // --- Generate a Button for Each Option ---
            for (final option in options)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the respective exercise page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => option.page),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.surface, // Button background
                    foregroundColor: colorScheme.onSurface, // Button text color
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    option.label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
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

// Breathing Exercise Page
class BreatheWithMe extends StatelessWidget {
  const BreatheWithMe({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,

      // App Bar with consistent theming
      appBar: AppBar(
        title: Text("Breathe with Me",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),

      // Body with breathing instructions and animation
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

            // Breathing animation widget (circle that expands/contracts)
            BreatheAnimation(),
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

// --- BreatheAnimation Widget ---
// A custom animated widget that represents a breathing cycle using a circle animation
class BreatheAnimation extends StatefulWidget {
  @override
  State<BreatheAnimation> createState() => _BreatheAnimationState();
}

class _BreatheAnimationState extends State<BreatheAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Controls the breathing animation
  late Animation<double> _animation; // Animates circle size
  int _phaseIndex = 0; // Tracks current phase (Inhale, Hold, etc.)

  // List of breathing phases
  final List<String> _phases = ["Inhale", "Hold", "Exhale", "Hold"];

  // Corresponding background color for each phase
  final List<Color> _phaseColors = [
    Colors.green,
    Colors.blueGrey,
    Colors.orange,
    Colors.blueGrey,
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animation controller with 4-second duration
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // Animate from 100 to 200 in size (for the circle)
    _animation = Tween<double>(begin: 100, end: 200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _startPhaseCycle(); // Start the breathing loop
  }

  // Controls the breathing logic: expand/hold/shrink/hold
  void _startPhaseCycle() async {
    while (mounted) {
      setState(() {}); // Triggers UI update for phase text & color

      // Inhale phase: expand the circle
      if (_phases[_phaseIndex] == "Inhale") {
        await _controller.forward();
      }
      // Exhale phase: shrink the circle
      else if (_phases[_phaseIndex] == "Exhale") {
        await _controller.reverse();
      }
      // Hold phases: wait without animation
      else {
        await Future.delayed(const Duration(seconds: 4));
      }

      // Move to next phase in loop
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

    // Use AnimatedBuilder to rebuild UI whenever animation changes
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
                  _phases[_phaseIndex], // Show current breathing phase
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

// Grounding Exercise Page
class Grounding extends StatefulWidget {
  const Grounding({super.key});

  @override
  State<Grounding> createState() => _GroundingState();
}

class _GroundingState extends State<Grounding> {
  // Text editing controllers for user input across the 5-4-3-2-1 senses technique
  final _seeController = TextEditingController();
  final _touchController = TextEditingController();
  final _hearController = TextEditingController();
  final _smellController = TextEditingController();
  final _tasteController = TextEditingController();

  @override
  void dispose() {
    // Disposing controllers to avoid memory leaks
    _seeController.dispose();
    _touchController.dispose();
    _hearController.dispose();
    _smellController.dispose();
    _tasteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,

      // Top app bar for page title
      appBar: AppBar(
        title: Text("Let's Try Grounding",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),

      // Main content wrapped in scrollable view to support smaller screens
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and guidance text
            Text(
              "5-4-3-2-1 Grounding Technique",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground),
            ),
            SizedBox(height: 16),
            Text(
              "Take a breath. Then fill in what you sense below:",
              style: TextStyle(
                  fontSize: 16, height: 1.4, color: colorScheme.onBackground),
            ),
            SizedBox(height: 24),

            // Each TextField corresponds to one of the 5 senses
            TextField(
              controller: _seeController,
              decoration: InputDecoration(
                labelText: "5 things you can SEE",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            TextField(
              controller: _touchController,
              decoration: InputDecoration(
                labelText: "4 things you can TOUCH",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            TextField(
              controller: _hearController,
              decoration: InputDecoration(
                labelText: "3 things you can HEAR",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            TextField(
              controller: _smellController,
              decoration: InputDecoration(
                labelText: "2 things you can SMELL",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            TextField(
              controller: _tasteController,
              decoration: InputDecoration(
                labelText: "1 thing you can TASTE or appreciate",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32),

            // Button that checks if all fields are filled before confirming grounding
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_seeController.text.isNotEmpty &&
                      _touchController.text.isNotEmpty &&
                      _hearController.text.isNotEmpty &&
                      _smellController.text.isNotEmpty &&
                      _tasteController.text.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text("Grounding complete. You're doing great.")),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              "Take your time. When you're ready, complete the rest of your grounding.")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                child: Text("I'm Grounded"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Simple data model class to represent an affirmation
class Affirmation {
  final String text; // Affirmation message
  final String emoji; // Visual symbol (used here to give warmth)

  Affirmation({required this.text, required this.emoji});
}

// Kind Word Page
class KindWord extends StatelessWidget {
  KindWord({super.key});

  // A static list of affirmation objects; each has a message and a symbol
  final List<Affirmation> affirmations = [
    Affirmation(
        text: "You are doing your best, and that is enough.", emoji: '🌟'),
    Affirmation(text: "It's okay to not be okay.", emoji: '💙'),
    Affirmation(text: "You are stronger than you think.", emoji: '💪'),
    Affirmation(text: "Be patient and kind with yourself.", emoji: '🫶'),
    Affirmation(text: "You are worthy of peace and happiness.", emoji: '🌸'),
    Affirmation(text: "This feeling is temporary.", emoji: '⏳'),
    Affirmation(text: "You are capable of handling challenges.", emoji: '🧠'),
    Affirmation(text: "Allow yourself time to rest and heal.", emoji: '🛌'),
    Affirmation(text: "You are not alone.", emoji: '🤝'),
    Affirmation(text: "Breathe. You've got this.", emoji: '🧘‍♀️'),
  ];

  @override
  Widget build(BuildContext context) {
    // Randomly selects one affirmation from the list to display
    final randomAffirmation = (affirmations..shuffle()).first;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,

      // App bar with title and color styling
      appBar: AppBar(
        title:
            Text("Hear a Kind Word", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),

      // Body contains the randomly selected affirmation, styled
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Displays the affirmation message
              Text(
                randomAffirmation.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onBackground,
                  height: 1.4,
                ),
              ),
              // Displays the accompanying emoji (optional decorative purpose)
              Text(
                randomAffirmation.emoji,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 60,
                  height: 1.4,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
