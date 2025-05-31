import 'package:flutter/material.dart';

// A simple model that represents each mood option.
// Each mood includes an emoji, a label, and a corresponding affirmation message.
class Mood {
  final String emoji;
  final String label;
  final String affirmation;

  const Mood({
    required this.emoji,
    required this.label,
    required this.affirmation,
  });
}

// The MoodCheckIn widget is a stateful page that allows users to select how they feel.
class MoodCheckIn extends StatefulWidget {
  const MoodCheckIn({super.key});

  @override
  State<MoodCheckIn> createState() => _MoodCheckInState();
}

class _MoodCheckInState extends State<MoodCheckIn> {
  // A predefined list of moods that the user can choose from
  static final List<Mood> moods = [
    Mood(emoji: '😔', label: 'Sad', affirmation: 'It\'s okay to feel sad. Acknowledge your feelings without judgment.'),
    Mood(emoji: '😐', label: 'Meh', affirmation: 'Feeling neutral is perfectly fine. Sometimes just being is enough.'),
    Mood(emoji: '🙂', label: 'Okay', affirmation: 'Good to hear you\'re doing okay. Keep taking care of yourself!'),
    Mood(emoji: '😊', label: 'Good', affirmation: 'Wonderful! Embrace the good feelings and let them energize you.'),
    Mood(emoji: '🤩', label: 'Excited', affirmation: 'Excitement is great energy! Channel it into something positive.'),
    Mood(emoji: '😰', label: 'Anxious', affirmation: 'Deep breaths. You are safe. Try a calming exercise if you need to.'),
  ];

  // Stores the currently selected mood
  Mood? _selectedMood;

  // Updates the selected mood when a box is tapped
  void _selectMood(Mood mood) {
    setState(() {
      _selectedMood = mood;
    });
  }

  // If a mood is selected, navigates to the affirmation screen
  void _continue() {
    if (_selectedMood != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MoodAffirmationPage(affirmation: _selectedMood!.affirmation),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Mood Check-In", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Screen title
            Text(
              "How are you feeling today?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 32),

            // Grid displaying all mood options as selectable boxes
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.0,
                children: [
                  for (final mood in moods)
                    MoodSelectionBox(
                      mood: mood,
                      isSelected: _selectedMood == mood,
                      onPressed: () => _selectMood(mood),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Continue button that activates only if a mood is selected
            ElevatedButton(
              onPressed: _selectedMood == null ? null : _continue,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: const Text("Continue"),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// Reusable widget to display each mood option in a decorated box
class MoodSelectionBox extends StatelessWidget {
  final Mood mood;
  final bool isSelected;
  final VoidCallback onPressed;

  const MoodSelectionBox({
    super.key,
    required this.mood,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withOpacity(0.3)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.grey.shade300,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mood emoji
            Text(
              mood.emoji,
              style: const TextStyle(fontSize: 36.0),
            ),
            const SizedBox(height: 8.0),
            // Mood label
            Text(
              mood.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// The screen that shows the affirmation tied to the selected mood
class MoodAffirmationPage extends StatelessWidget {
  final String affirmation;

  const MoodAffirmationPage({super.key, required this.affirmation});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Affirmation message
              Text(
                affirmation,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onBackground,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 48),
              // Return button to go back to home screen
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: const Text("Return"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}