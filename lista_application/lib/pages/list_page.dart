import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<String> todos = [];

  TextEditingController todoController = TextEditingController();

  int tarefas = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const Expanded(
                    child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Adicione uma tarefa',
                    border: OutlineInputBorder(),
                  ),
                )),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        todos.add(todoController.text);
                        tarefas++;
                      });
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
            ListView(
              shrinkWrap: true,
              children: [
                for (String todo in todos)
                  ListTile(
                    title: Text('Tarefa $tarefas'),
                    subtitle: Text(todo),
                    leading: const Icon(Icons.person_2),
                    onTap: () {
                      print('tarefa $tarefas');
                    },
                  )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text('Você possui $tarefas pendentes'),
                ),
                ElevatedButton(
                  onPressed: () {},
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
    );
  }
}
