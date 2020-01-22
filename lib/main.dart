// Import MaterialApp and other widgets which we can use to
// quickly create a material app
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Code written in Dart starts executing from the main function. runApp is part
// of Flutter, and requies the component which will be our app's container.
// In Flutter, every component is known as a 'widget'.
void main() => runApp(new TodoApp());

// Every component in Flutter is a widget, even the whole app itself
class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
          primaryColor: Colors.deepPurple
      ),
      home: new TodoList()
    );
  }// build
} // TodoApp

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  List<String> _todoItems = [];

  // This will be called each time the + button is pressed
  void _addTodoItem(String task) {
    // Putting our code inside "setState" tells the app that our state has
    // changed, and it will automatically re-render the List

    // Only add the task if the user actually entered something
    if (task.length > 0) {
      setState(() => _todoItems.add(task));
      _save();
    }
  }

  // Like _addTodoItem, this modifies the array of to-do strings and notifies
  // the app that the state has changed using setState
  void _removeTodoItem(int index) {
    setState(() => _todoItems.removeAt(index));
  }

  //Show an alert dialog asking the user to confirm that the task is done
  void _promptRemoveTodoItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mark "${_todoItems[index]}" as done?'),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop()
            ),
            FlatButton(
              child: Text('MARK AS DONE'),
              onPressed: () {
                _removeTodoItem(index);
                Navigator.of(context).pop();
              }
            )
          ],
        );
      } // builder
    ); // showDialog
  }

  // Build the whole list of to-do items
  Widget _buildTodoList() {
    _read();
    return new ListView.builder(
      itemBuilder: (context, index) {
        // itemBuilder will be automatcally called as many times as it takes
        // for the list to fill up its available space, which is most likely
        // more than the number of to-do items we have. So, we need to check
        // that the index is ok.
        if (index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index], index);
        }
        // ignore: missing_return
      }, // itemBuilder
    ); // ListView.builder
  }

  //Build a single to-do item
  Widget _buildTodoItem(String todoText, int index) {
    return new ListTile(
      title: new Text(todoText),
      onTap: () => _promptRemoveTodoItem(index)
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('To-do List')
      ),
      body: _buildTodoList(),
      floatingActionButton: new FloatingActionButton(
        onPressed: _pushAddTodoScreen, //pressing this button opens new screen
        tooltip: 'Add task',
        child: new Icon(Icons.add)
      )
    );
  } // build

  void _pushAddTodoScreen() {
    // Push this page onto the stack
    Navigator.of(context).push(
      // MaterialPageRoute will automatically animate the screen entry, as well
      // as adding a back button to close it
      new MaterialPageRoute(
        builder: (context) {
          return new Scaffold(
            appBar: AppBar(
              title: Text('Add a new task')
            ),
            body: TextField(
              autofocus: true,
              onSubmitted: (val) {
                _addTodoItem(val);
                Navigator.pop(context); //Close the add to-do screen
              },
              decoration: InputDecoration(
                hintText: 'Enter something to do...',
                contentPadding: const EdgeInsets.all(16.0)
              ),
            )
          );
        } // builder
      )
    ); // push
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_string_list_key';
    final myStringList = prefs.getStringList(key) ?? [];
    _todoItems = myStringList;
  }

  _save() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_string_list_key';
    prefs.setStringList(key, _todoItems);
  }

}// TodoListState