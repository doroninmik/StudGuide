import 'package:flutter/material.dart';

class DescriptionNote extends StatefulWidget {
  var tittle;
  var description;

  DescriptionNote({super.key, required this.tittle, required this.description});

  @override
  State<DescriptionNote> createState() => _DescriptionNoteState();
}

class _DescriptionNoteState extends State<DescriptionNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Описание заметки'),
        backgroundColor: const Color.fromARGB(200, 90, 10, 104),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(widget.tittle),
                      subtitle: Text(widget.description),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}