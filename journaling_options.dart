import 'package:flutter/material.dart';
import 'journal.dart';

// --- Option Data Class ---
class Option {
  final String label;
  final Widget page;

  const Option({required this.label, required this.page});
}

// --- Journaling Options Main Page ---
class JournalingOptions extends StatelessWidget {
  const JournalingOptions({super.key});

  // List of guided journal prompts
  static const List<Option> options = [
    Option(label: "How am I feeling right now?", page: AddToJournal(prompt: "How am I feeling right now?")),
    Option(label: "What’s one thing I’m grateful for?", page: AddToJournal(prompt: "What’s one thing I’m grateful for?")),
    Option(label: "A recent challenge I overcame", page: AddToJournal(prompt: "A recent challenge I overcame")),
    Option(label: "A kind message to myself", page: AddToJournal(prompt: "A kind message to myself")),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "Journaling",
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
            // Header text
            Text(
              "Support Your Mind & Body",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 32),

            // Loop through each journaling prompt option and display a button
            for (final option in options)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // Navigate to entry page and await result
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => option.page),
                    );

                    // If user saved a journal entry, add it to storage and notify
                    if (result != null && result is JournalEntry) {
                      JournalStorage.entries.add(result);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("The entry is added within your journal.\nPlease visit the journal page.")),
                      );
                    }
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

// --- Add to Journal Entry Page ---
class AddToJournal extends StatefulWidget {
  final String prompt;

  const AddToJournal({super.key, required this.prompt});

  @override
  State<AddToJournal> createState() => _AddToJournalState();
}

class _AddToJournalState extends State<AddToJournal> {
  late TextEditingController _titleController;
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize title controller with the selected prompt
    _titleController = TextEditingController(text: widget.prompt);
  }

  @override
  void dispose() {
    // Dispose of controllers when done
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // Save the journal entry and return it to the previous screen
  void _saveEntry() {
    final String title = _titleController.text.trim();
    final String description = _descController.text.trim();

    // Require a title (prompt should always be prefilled)
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter a title for your journal entry."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final newEntry = JournalEntry(
      title: title,
      description: description,
      timeStamp: DateTime.now(),
    );

    Navigator.pop(context, newEntry);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a Journal Entry", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title header
              Text(
                "Add to your Journal",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 32),

              // Read-only prompt input
              TextField(
                controller: _titleController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Prompt",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // User reflection input
              TextField(
                controller: _descController,
                maxLines: 6,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _saveEntry(),
                decoration: const InputDecoration(
                  labelText: "Your Reflection",
                  hintText: "Write how you feel...",
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Save entry button
              ElevatedButton.icon(
                onPressed: _saveEntry,
                icon: Icon(Icons.save, color: colorScheme.onPrimary),
                label: const Text("Save Entry"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  minimumSize: const Size.fromHeight(50),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 10),

              // Cancel and go back
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.cancel_outlined, color: colorScheme.onSecondary),
                label: const Text("Cancel"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onSecondary,
                  minimumSize: Size.fromHeight(50),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}