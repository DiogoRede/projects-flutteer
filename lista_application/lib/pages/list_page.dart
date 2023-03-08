import 'package:flutter/material.dart';
import 'package:lista_application/models/Todo.dart';
import 'package:lista_application/repositories/todo_repository.dart';
import 'package:lista_application/widgets/todo_list_item.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Todo> todos = [];

  Todo? deletedTodo;
  int? deletedTodoIndex;

  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  String? errorText;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Lista de Tarefas',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: todoController,
                    decoration: InputDecoration(
                      labelText: 'Adicione uma tarefa',
                      border: const OutlineInputBorder(),
                      errorText: errorText,
                    ),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;

                        if (text.isEmpty) {
                          setState(() {
                            errorText = 'Campo deve ser preenchido';
                          });
                          return;
                        }

                        setState(() {
                          Todo newTodo = Todo(
                            title: text,
                            dateTime: DateTime.now(),
                          );
                          todos.add(newTodo);
                          errorText = null;
                        });
                        todoController.clear();
                        todoRepository.saveTodoList(todos);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.all(15),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      )),
                ],
              ),
              const SizedBox(height: 10),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (Todo todo in todos)
                      TodoListItem(
                        todo: todo,
                        onDelete: onDelete,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text('Você possui ${todos.length} pendentes'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDeleteTodosConfirmationDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.all(10),
                    ),
                    child: const Text(
                      'Limpar tudo',
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoIndex = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });

    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.white,
          content: Text(
            'Tarefa ${todo.title}, removido com sucesso!',
            style: const TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.w700,
            ),
          ),
          action: SnackBarAction(
            textColor: Colors.blueAccent,
            label: 'Desfazer',
            onPressed: () {
              setState(() {
                todos.insert(deletedTodoIndex!, deletedTodo!);
              });
              todoRepository.saveTodoList(todos);
            },
          )),
    );
  }

  void showDeleteTodosConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Tudo?'),
        content: const Text('Você deseja limpar todas as suas tarefas?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.purple),
              )),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllTodos();
            },
            child: const Text(
              'Limpar tudo',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void deleteAllTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}
