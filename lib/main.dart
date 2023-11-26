// Import the necessary packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Define a model class for tasks
class Task {
  final String title;
  final String description;
  bool isCompleted;

  Task(
      {required this.title,
      required this.description,
      this.isCompleted = false});
}

// Define a provider class for state management
class TaskProvider extends ChangeNotifier {
  // A list of sample tasks
  List<Task> _tasks = [
    Task(
        title: 'Meeting with client',
        description: 'Discuss the project details and timeline',
        isCompleted: true),
    Task(
        title: 'Send report',
        description: 'Write and send the weekly report to the manager',
        isCompleted: false),
    Task(
        title: 'Review code',
        description: 'Review the code quality and performance of the team',
        isCompleted: false),
  ];

  // A getter method to access the tasks
  List<Task> get tasks => _tasks;

  // A method to add a new task
  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  // A method to toggle the completion status of a task
  void toggleCompleted(int index) {
    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    notifyListeners();
  }
}

// Define a widget for the login screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // A global key for the form
  final _formKey = GlobalKey<FormState>();

  // A controller for the username field
  final _usernameController = TextEditingController();

  // A controller for the password field
  final _passwordController = TextEditingController();

  // A boolean value to show or hide the password
  bool _showPassword = false;

  // A method to validate the username
  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    return null;
  }

  // A method to validate the password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  // A method to authenticate the user
  void _authenticate() {
    // Validate the form fields
    if (_formKey.currentState!.validate()) {
      // Get the username and password values
      String username = _usernameController.text;
      String password = _passwordController.text;

      // Simulate a simple authentication logic
      // In a real app, you would use a service or a database to verify the credentials
      if (username == 'user' && password == 'pass') {
        // Navigate to the main task interface
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainTaskInterface()),
        );
      } else {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid username or password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // A text field for the username
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateUsername,
                ),
                const SizedBox(height: 16.0),
                // A text field for the password
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_showPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                  ),
                  validator: _validatePassword,
                ),
                SizedBox(height: 16.0),
                // A button for the login
                ElevatedButton(
                  onPressed: _authenticate,
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Define a widget for the main task interface
class MainTaskInterface extends StatelessWidget {
  const MainTaskInterface({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today Task'),
        actions: [
          // A button to navigate to the additional feature interface
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdditionalFeatureInterface()),
              );
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          // Get the tasks from the provider
          List<Task> tasks = provider.tasks;

          // Return a list view of tasks
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              // Get the task at the index
              Task task = tasks[index];

              // Return a list tile for the task
              return ListTile(
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    // Toggle the completion status of the task
                    provider.toggleCompleted(index);
                  },
                ),
                title: Text(task.title),
                subtitle: Text(task.description),
                trailing: task.isCompleted
                    ? Icon(Icons.check, color: Colors.green)
                    : Icon(Icons.close, color: Colors.red),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Show a dialog to add a new task
          showDialog(
            context: context,
            builder: (context) {
              // Return a widget for the dialog
              return AddTaskDialog();
            },
          );
        },
      ),
    );
  }
}

// Define a widget for the dialog to add a new task
class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({Key? key}) : super(key: key);

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  // A global key for the form
  final _formKey = GlobalKey<FormState>();

  // A controller for the task title field
  final _titleController = TextEditingController();

  // A controller for the task description field
  final _descriptionController = TextEditingController();

  // A method to validate the task title
  String? _validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title for the task';
    }
    return null;
  }

  // A method to validate the task description
  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a description for the task';
    }
    return null;
  }

  // A method to add a new task
  void _addTask() {
    // Validate the form fields
    if (_formKey.currentState!.validate()) {
      // Get the title and description values
      String title = _titleController.text;
      String description = _descriptionController.text;

      // Create a new task object
      Task task = Task(title: title, description: description);

      // Add the task to the provider
      Provider.of<TaskProvider>(context, listen: false).addTask(task);

      // Close the dialog
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add a new task'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // A text field for the task title
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: _validateTitle,
            ),
            SizedBox(height: 16.0),
            // A text field for the task description
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              validator: _validateDescription,
            ),
          ],
        ),
      ),
      actions: [
        // A button to cancel the dialog
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        // A button to add the task
        ElevatedButton(
          onPressed: _addTask,
          child: Text('Add'),
        ),
      ],
    );
  }
}

// Define a widget for the additional feature interface
class AdditionalFeatureInterface extends StatelessWidget {
  const AdditionalFeatureInterface({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Statistics'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          // Get the tasks from the provider
          List<Task> tasks = provider.tasks;
          // Calculate the number of completed and incomplete tasks
          int completedTasks = tasks.where((task) => task.isCompleted).length;
          int incompleteTasks = tasks.length - completedTasks;

          // Calculate the completion percentage
          double completionPercentage =
              tasks.isEmpty ? 0 : completedTasks / tasks.length * 100;

          // Return a column of widgets to display the statistics
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // A text widget to show the completion percentage
              Text(
                'Completion Percentage: ${completionPercentage.toStringAsFixed(2)}%',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              // A row of widgets to show the number of completed and incomplete tasks
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // A column of widgets to show the number of completed tasks
                  Column(
                    children: [
                      Text(
                        'Completed Tasks',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        '$completedTasks',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // A column of widgets to show the number of incomplete tasks
                  Column(
                    children: [
                      Text(
                        'Incomplete Tasks',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        '$incompleteTasks',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

// Define the main function to run the app
void main() {
  runApp(
    // Use a provider to manage the state of the app
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        // Set the theme of the app
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // Set the home screen of the app
        home: LoginScreen(),
      ),
    ),
  );
}
