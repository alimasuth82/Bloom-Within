import 'package:flutter/material.dart';

// --- Option Data Class ---
class Option {
  final String label;
  final Widget page;

  const Option({required this.label, required this.page});
}


// --- Grounding Techniques Main Page ---
class GroundingTechniques extends StatelessWidget {
  const GroundingTechniques({super.key});

  // List of available grounding options
  static const List<Option> options = [
    Option(label: "5-4-3-2-1 Technique", page: FiveFourThreeTwoOne()),
    Option(label: "Describe your Surroundings", page: Surroundings()),
    Option(label: "Count Backward from 100 by 7s", page: CountingBackwords()),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "Grounding Techniques",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Reconnect with the present moment",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 32),

            // Loop through each grounding option and render a button
            for (final option in options)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
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


// --- 5-4-3-2-1 Grounding Technique Page ---
class FiveFourThreeTwoOne extends StatefulWidget {
  const FiveFourThreeTwoOne({super.key});

  @override
  State<FiveFourThreeTwoOne> createState() => _FiveFourThreeTwoOneState();
}

class _FiveFourThreeTwoOneState extends State<FiveFourThreeTwoOne> {
  // Text controllers for each sense input
  final _seeController = TextEditingController();
  final _touchController = TextEditingController();
  final _hearController = TextEditingController();
  final _smellController = TextEditingController();
  final _tasteController = TextEditingController();

  @override
  void dispose() {
    // Dispose all controllers when widget is removed from the tree
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
      appBar: AppBar(
        title: const Text(
          "Let's Try Grounding",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page title
            Text(
              "5-4-3-2-1 Grounding Technique",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),

            const SizedBox(height: 16),

            // Instructional text
            Text(
              "Take a breath. Then fill in what you sense below:",
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
                color: colorScheme.onBackground,
              ),
            ),

            const SizedBox(height: 24),

            // Input fields for each of the 5 senses
            TextField(
              controller: _seeController,
              decoration: const InputDecoration(
                labelText: "5 things you can SEE",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _touchController,
              decoration: const InputDecoration(
                labelText: "4 things you can TOUCH",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _hearController,
              decoration: const InputDecoration(
                labelText: "3 things you can HEAR",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _smellController,
              decoration: const InputDecoration(
                labelText: "2 things you can SMELL",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tasteController,
              decoration: const InputDecoration(
                labelText: "1 thing you can TASTE or appreciate",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 32),

            // Submission button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Check if all fields are filled before proceeding
                  if (_seeController.text.isNotEmpty &&
                      _touchController.text.isNotEmpty &&
                      _hearController.text.isNotEmpty &&
                      _smellController.text.isNotEmpty &&
                      _tasteController.text.isNotEmpty) {
                    // All inputs provided — show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Grounding complete. You’re doing great. 🌿")),
                    );
                    Navigator.pop(context);
                  } else {
                    // Prompt user to complete all fields
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Take your time. When you're ready, complete the rest of your grounding. 💚")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                child: const Text("I'm Grounded"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// --- Describe Your Surroundings Page ---
class Surroundings extends StatefulWidget {
  const Surroundings({super.key});

  @override
  State<Surroundings> createState() => _SurroundingsState();
}

class _SurroundingsState extends State<Surroundings> {
  // Controller for the user's description input
  final TextEditingController _descController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controller when the widget is removed
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Describe your Surroundings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),

                // Instructional text at the top
                Text(
                  "Describe your Surroundings",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onBackground,
                  ),
                ),

                // Text input field for the user's observations
                TextField(
                  controller: _descController,
                  maxLines: 6,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: "What Do You Notice Around You?",
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 24),

                // Submit button to validate and exit
                ElevatedButton.icon(
                  onPressed: () {
                    if (_descController.text.trim().isNotEmpty) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("You’ve observed your surroundings. You're here, and you're safe."),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Take your time. Notice a few more things around you."),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.save, color: colorScheme.onPrimary),
                  label: const Text("Submit"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    minimumSize: const Size.fromHeight(50),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// --- Count Backward from 100 by 7s Page ---
class CountingBackwords extends StatefulWidget {
  const CountingBackwords({super.key});

  @override
  State<CountingBackwords> createState() => _CountingBackwordsState();
}

class _CountingBackwordsState extends State<CountingBackwords> {
  // The current number displayed on screen
  int numberValue = 100;

  // Controller for the user's input field
  final TextEditingController _inputValueController = TextEditingController();

  // Validates the user's input and updates the UI
  void checkAnswer() {
    final input = _inputValueController.text.trim();
    final parsedInput = int.tryParse(input);

    // Show an error if input is not a valid number
    if (parsedInput == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid number.")),
      );
      return;
    }

    // If the input is correct, update the state or finish the exercise
    if (parsedInput == numberValue - 7) {
      if (numberValue != 2) {
        setState(() {
          numberValue = parsedInput;
          _inputValueController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Good job! Keep going.")),
        );
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Well done! You did a great job.")),
        );
      }
    } else {
      // Show an error if the input is incorrect
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("That's not correct. Try again.")),
      );
    }
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is removed
    _inputValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Count Backwards by 7s",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Display the current number
                Text(
                  "$numberValue",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onBackground,
                  ),
                ),

                const SizedBox(height: 12),

                // Input field for the next number
                TextField(
                  controller: _inputValueController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => checkAnswer(),
                  decoration: const InputDecoration(
                    labelText: "Enter the next value",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                // Button to check the answer
                ElevatedButton(
                  onPressed: checkAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  child: const Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}