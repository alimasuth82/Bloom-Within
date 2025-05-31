import 'package:flutter/material.dart';
import 'breathing.dart';
import 'grounding.dart';
import 'journaling_options.dart';

// --- Option Data Class ---
// This class represents each exercise option with a label and its corresponding page
class Option {
  final String label;   // Text to display on the button
  final Widget page;    // The page to navigate to when clicked

  const Option({required this.label, required this.page});
}

// --- Main Exercises Page ---
class Exercises extends StatelessWidget {
  const Exercises({super.key});

  // List of exercise options with labels and navigation targets
  static const List<Option> options = [
    Option(label: "Breathing Exercises", page: BreathingExercises()),
    Option(label: "Grounding Techniques", page: GroundingTechniques()),
    Option(label: "Journaling", page: JournalingOptions())
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme; // Access app theme colors

    return Scaffold(
      backgroundColor: colorScheme.background, // Set page background color

      // --- App Bar ---
      appBar: AppBar(
        title: const Text("Exercises", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),

      // --- Body Content ---
      body: Padding(
        padding: const EdgeInsets.all(24.0), // Consistent spacing around content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Expand children horizontally
          children: [
            // Page title
            Text(
              "Support Your Mind & Body",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: colorScheme.onBackground,
              ),
            ),

            const SizedBox(height: 32), // Space below the title

            // --- Dynamic Buttons for Each Option ---
            for (final option in options)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the selected exercise page
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