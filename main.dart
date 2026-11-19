import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

// Task 1
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final formKey = GlobalKey<FormState>();

  final departments = [
    'Computer Science',
    'Software Engineering',
    'Information Technology',
    'Artificial Intelligence',
  ];

  String name = '';
  String? department;
  String? shift;

  void submit() {
    final form = formKey.currentState!;
    String message = 'Please fix errors before submitting';

    if (form.validate()) {
      form.save();
      message = 'Registered: $name - $department, $shift';
    }

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Registration')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return 'Please enter your name';
                if (text.length < 3) return 'Enter at least 3 characters';
                return null;
              },
              onSaved: (value) => name = value!.trim(),
            ),
            const SizedBox(height: 16),
            FormField<String>(
              validator: (value) =>
              value == null ? 'Please select a department' : null,
              onSaved: (value) => department = value,
              builder: (field) {
                return InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Department',
                    errorText: field.errorText,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: field.value,
                      hint: const Text('Select department'),
                      items: [
                        for (final dept in departments)
                          DropdownMenuItem(value: dept, child: Text(dept)),
                      ],
                      onChanged: field.didChange,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            FormField<String>(
              validator: (value) =>
              value == null ? 'Please select a shift' : null,
              onSaved: (value) => shift = value,
              builder: (field) {
                return InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Shift',
                    errorText: field.errorText,
                  ),
                  child: RadioGroup<String>(
                    groupValue: field.value,
                    onChanged: field.didChange,
                    child: const Column(
                      children: [
                        RadioListTile<String>(
                          title: Text('Morning'),
                          value: 'Morning',
                        ),
                        RadioListTile<String>(
                          title: Text('Evening'),
                          value: 'Evening',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: submit,
                  child: const Text('Submit'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {
                    formKey.currentState!.reset();
                    name = '';
                    department = null;
                    shift = null;
                    ScaffoldMessenger.of(context).clearSnackBars();
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Task 2
class BookStoreScreen extends StatefulWidget {
  const BookStoreScreen({super.key});

  @override
  State<BookStoreScreen> createState() => _BookStoreScreenState();
}

class _BookStoreScreenState extends State<BookStoreScreen> {
  int page = 0;
  final books = [
    {'title': 'The Hobbit', 'author': 'J.R.R. Tolkien', 'category': 'Fantasy'},
    {'title': 'Matilda', 'author': 'Roald Dahl', 'category': 'Fantasy'},
    {'title': 'The Alchemist', 'author': 'Paulo Coelho', 'category': 'Fiction'},
    {'title': 'Dune', 'author': 'Frank Herbert', 'category': 'Science Fiction'},
    {'title': 'Emma', 'author': 'Jane Austen', 'category': 'Romance'},
    {'title': 'Dracula', 'author': 'Bram Stoker', 'category': 'Horror'},
    {'title': 'Coraline', 'author': 'Neil Gaiman', 'category': 'Fantasy'},
    {'title': 'Frankenstein', 'author': 'Mary Shelley', 'category': 'Horror'},
    {'title': 'The Time Machine', 'author': 'H.G. Wells', 'category': 'Science Fiction'},
    {'title': 'Animal Farm', 'author': 'George Orwell', 'category': 'Satire'},
    {'title': 'Little Women', 'author': 'Louisa May Alcott', 'category': 'Fiction'},
    {'title': 'Treasure Island', 'author': 'Robert Louis Stevenson', 'category': 'Adventure'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu_book),
        title: const Text('Book Store'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: 4,
                itemBuilder: (context, index) {
                  final book = books[page * 4 + index];
                  final title = book['title']!;

                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.book)),
                      title: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Author: ${book['author']}'),
                          Text('Category: ${book['category']}'),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        final messenger = ScaffoldMessenger.of(context);
                        messenger.removeCurrentSnackBar();
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text('You selected $title'),
                            duration: const Duration(seconds: 2),
                            persist: false,
                            action: SnackBarAction(
                              label: 'Dismiss',
                              onPressed: () => messenger.hideCurrentSnackBar(),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: page == 0 ? null : () => setState(() => page--),
                  child: const Text('Previous'),
                ),
                Text('Page ${page + 1} of 3'),
                ElevatedButton(
                  onPressed: page == 2 ? null : () => setState(() => page++),
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Task 3
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab Café')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Welcome to Lab Café', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MenuScreen()),
                );
              },
              child: const Text('View Menu'),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const items = ['Tea', 'Coffee', 'Hot Chocolate'];

    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: ListView(
        children: [
          for (final item in items)
            ListTile(
              title: Text(item),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderScreen(item: item),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class OrderScreen extends StatelessWidget {
  final String item;

  const OrderScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 64, color: Colors.green),
            const Text('Order placed!', style: TextStyle(fontSize: 24)),
            Text('You ordered: $item'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Menu'),
            ),
          ],
        ),
      ),
    );
  }
}