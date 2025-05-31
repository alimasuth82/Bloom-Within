import 'package:flutter/material.dart';

// --- JournalEntry Class (Data Model) ---
// This class represents the structure of a journal entry.
// It stores the title, description, and timestamp of when it was created.
class JournalEntry {
  String? title;
  String? description;
  DateTime? timeStamp;

  JournalEntry({required this.title, this.description, this.timeStamp});

  String? getTitle() => this.title;
  String? getDescription() => this.description;
  DateTime? getTimeStamp() => this.timeStamp;

  void setTitle(String? title) => this.title = title;
  void setDescription(String? description) => this.description = description;
}

// --- JournalStorage Class ---
// This static class stores all journal entries in memory.
// It acts as a temporary database for this app session.
class JournalStorage {
  static final List<JournalEntry> entries = [];
}

// --- Main Application Setup ---
// Entry point that runs the app and defines named routes for navigation.
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Journal(), // Default screen
    routes: {
      '/journal': (context) => Journal(),
      '/addJournal': (context) => AddJournalEntry(),
    },
  ));
}

// --- Journal List Screen (Main View) ---
class Journal extends StatefulWidget {
  const Journal({super.key});

  @override
  State<Journal> createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  // Local copy of journal entries pulled from static JournalStorage
  List<JournalEntry> _allJournalEntries = List.from(JournalStorage.entries);

  // Refreshes the local list in case external updates are made
  void _refreshJournalEntries() {
    setState(() {
      _allJournalEntries = List.from(JournalStorage.entries);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // --- Top AppBar with title and theming ---
      appBar: AppBar(
        title:
            Text("My Journal", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),

      // --- Main Body ---
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            children: [
              // --- Title Text ---
              Text(
                "It's okay, let it all out...",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: colorScheme.onBackground,
                ),
              ),
              SizedBox(height: 20),

              // --- Journal List / Empty State ---
              Expanded(
                child: Center(
                  child: _allJournalEntries.isEmpty
                      // --- If no entries exist, show a message ---
                      ? Text(
                          "No Journal Entries entered.\nAdd one to get started!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.onBackground,
                          ),
                        )
                      // --- If entries exist, display them in a list ---
                      : ListView.builder(
                          itemCount: _allJournalEntries.length,
                          itemBuilder: (context, index) {
                            final entry = _allJournalEntries[index];
                            return GestureDetector(
                              // --- On tap, navigate to ViewJournal screen ---
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewJournal(
                                      title: entry.getTitle(),
                                      description: entry.getDescription(),
                                      index: index,
                                    ),
                                  ),
                                );

                                // --- Handle result from ViewJournal screen ---
                                if (result == "DELETE") {
                                  // If user chose to delete, remove from both lists
                                  setState(() {
                                    if (index < JournalStorage.entries.length) {
                                      JournalStorage.entries.removeAt(index);
                                    }
                                    if (index < _allJournalEntries.length) {
                                      _allJournalEntries.removeAt(index);
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Journal Entry Deleted")),
                                    );
                                  });
                                } else if (result != null &&
                                    result is JournalEntry) {
                                  // If user updated the entry, update both lists
                                  setState(() {
                                    if (index < JournalStorage.entries.length) {
                                      JournalStorage.entries[index] = result;
                                    }
                                    if (index < _allJournalEntries.length) {
                                      _allJournalEntries[index] = result;
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Journal Entry Updated")),
                                    );
                                  });
                                }
                              },

                              // --- Display Journal Entry Preview in a Card ---
                              child: Card(
                                color: Colors.white,
                                margin: EdgeInsets.symmetric(vertical: 8.0),
                                child: ListTile(
                                  title: Text(
                                    entry.getTitle() ?? "No Title",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    entry.getDescription() ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Text(
                                    entry.getTimeStamp() != null
                                        ? "${entry.getTimeStamp()!.month}/${entry.getTimeStamp()!.day}/${entry.getTimeStamp()!.year}"
                                        : "",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),

      // --- Add Entry Button ---
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'addBtn',
        tooltip: 'Add Entry',
        onPressed: () async {
          // Navigate to AddJournalEntry screen and await result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddJournalEntry()),
          );
          // If user adds a valid entry, add it to storage and update UI
          if (result != null && result is JournalEntry) {
            setState(() {
              JournalStorage.entries.add(result);
              _allJournalEntries.add(result);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Journal Entry Added")),
              );
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// --- View Journal Entry Screen ---
// Displays a single journal entry's title and description, and gives the user the option to edit or delete it.
class ViewJournal extends StatelessWidget {
  final String? title; // Title of the journal entry
  final String? description; // Description of the journal entry
  final int index; // Index of the entry in the journal list

  const ViewJournal({
    super.key,
    required this.title,
    required this.description,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Fallback values to handle nulls gracefully
    String currentTitle = title ?? "No Title";
    String currentDescription = description ?? "";

    return Scaffold(
      // --- App Bar with Themed Styling ---
      appBar: AppBar(
        title: Text("My Journal Entry",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),

      // --- Main Body Layout ---
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Header Text ---
              Text(
                "Let's see what it says...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: colorScheme.onBackground,
                ),
              ),
              SizedBox(height: 45),

              // --- Journal Entry Display Box ---
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Title:",
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade600)),
                    SizedBox(height: 4),
                    Text(
                      currentTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 18),
                    Text("Description:",
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade600)),
                    SizedBox(height: 4),
                    Text(
                      currentDescription,
                      style: TextStyle(
                          fontSize: 19, color: Colors.black, height: 1.4),
                    ),
                  ],
                ),
              ),

              Spacer(),

              // --- Edit Button: Navigates to EditJournal screen ---
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditJournal(
                        title: currentTitle,
                        description: currentDescription,
                        index: index,
                      ),
                    ),
                  );
                  // If the entry was updated, return the new version to previous screen
                  if (result != null && result is JournalEntry) {
                    Navigator.pop(context, result);
                  }
                },
                icon: Icon(Icons.edit, color: colorScheme.onPrimary),
                label: Text("Edit"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  minimumSize: Size.fromHeight(50),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),

              SizedBox(height: 15),

              // --- Delete Button: Shows confirmation dialog before deletion ---
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext ctx) {
                      return AlertDialog(
                        title: Text('Please Confirm'),
                        content: Text(
                            'Are you sure you want to delete this journal entry? This action cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop(); // Close dialog
                              Navigator.pop(
                                  context, "DELETE"); // Return "DELETE" signal
                            },
                            child: Text('Delete',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.delete_outline, color: colorScheme.onError),
                label: Text("Delete"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                  minimumSize: Size.fromHeight(50),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),

              SizedBox(height: 15),

              // --- Return Button: Goes back to Journal list without changes ---
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: colorScheme.onSecondary),
                label: Text("Return to List"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onSecondary,
                  minimumSize: Size.fromHeight(50),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Add Journal Entry Screen ---
// Allows the user to enter a new journal entry (title and description) and save it
class AddJournalEntry extends StatefulWidget {
  AddJournalEntry({super.key});

  @override
  State<AddJournalEntry> createState() => _AddJournalEntryState();
}

class _AddJournalEntryState extends State<AddJournalEntry> {
  // Controllers to capture text input
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void dispose() {
    // Properly dispose of the controllers to prevent memory leaks
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // Logic to validate and save the journal entry
  void _saveEntry() {
    final String title = _titleController.text.trim();
    final String description = _descController.text.trim();

    // Validate that the title is not empty
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter a title for your journal entry."),
        ),
      );
      return;
    }

    // Create a new journal entry object
    final newEntry = JournalEntry(
      title: title,
      description: description,
      timeStamp: DateTime.now(), // Save current date and time
    );

    // Return the new entry to the previous screen
    Navigator.pop(context, newEntry);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // --- App Bar ---
      appBar: AppBar(
        title: Text("Add a Journal Entry",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),

      // --- Main Body Layout ---
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            // Scrolls if screen height is small
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Page Header ---
                Text(
                  "Write down what you have been feeling.",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onBackground,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 32),

                // --- Title Input Field ---
                TextField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Title*",
                    hintText: "What's the main topic?",
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 16),

                // --- Description Input Field ---
                TextField(
                  controller: _descController,
                  maxLines: 6,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) =>
                      _saveEntry(), // Trigger save on keyboard submit
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "Pour your thoughts out here...",
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 24),

                // --- Save Entry Button ---
                ElevatedButton.icon(
                  onPressed: _saveEntry,
                  icon: Icon(Icons.save, color: colorScheme.onPrimary),
                  label: Text("Save Entry"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    minimumSize: Size.fromHeight(50),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),

                SizedBox(height: 10),

                // --- Cancel Button ---
                ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.pop(context), // Go back without saving
                  icon: Icon(Icons.cancel_outlined,
                      color: colorScheme.onSecondary),
                  label: Text("Cancel"),
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
      ),
    );
  }
}

// --- Edit Journal Entry Screen ---
// Allows the user to edit an existing journal entry's title and description
class EditJournal extends StatefulWidget {
  final String? title; // Existing title to edit
  final String? description; // Existing description to edit
  final int index; // Index of the journal entry being edited

  EditJournal({
    super.key,
    required this.title,
    required this.description,
    required this.index,
  });

  @override
  State<EditJournal> createState() => _EditJournalState();
}

class _EditJournalState extends State<EditJournal> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the existing title and description
    _titleController = TextEditingController(text: widget.title);
    _descController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // Save updated entry and return it to the previous screen
  void _saveEntry() {
    final String title = _titleController.text.trim();
    final String description = _descController.text.trim();

    // If the title is empty, show a warning
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter a title for your journal entry."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Create updated journal entry with the current timestamp
    final updatedEntry = JournalEntry(
      title: title,
      description: description,
      timeStamp: DateTime.now(),
    );

    // Return the updated entry back to the previous screen
    Navigator.pop(context, updatedEntry);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // --- App Bar ---
      appBar: AppBar(
        title: Text("Edit Your Journal",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),

      // --- Main Content Body ---
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            // Allows scrolling if keyboard is open
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Heading Text ---
                Text(
                  "Anything you want to change, kind soul?",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onBackground,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 32),

                // --- Title Input Field ---
                TextField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Title*",
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 16),

                // --- Description Input Field ---
                TextField(
                  controller: _descController,
                  maxLines: 6,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _saveEntry(),
                  decoration: InputDecoration(
                    labelText: "Description",
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 24),

                // --- Save Changes Button ---
                ElevatedButton.icon(
                  onPressed: _saveEntry,
                  icon: Icon(Icons.save_as, color: colorScheme.onPrimary),
                  label: Text("Save Changes"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    minimumSize: Size.fromHeight(50),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),

                SizedBox(height: 10),

                // --- Cancel Button ---
                ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.pop(context), // Return without saving
                  icon: Icon(Icons.cancel_outlined,
                      color: colorScheme.onSecondary),
                  label: Text("Cancel Edit"),
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
      ),
    );
  }
}
