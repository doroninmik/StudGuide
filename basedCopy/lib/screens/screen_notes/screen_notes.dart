import 'package:flutter/material.dart';
import '../../db/database_provider.dart';
import 'description_note.dart';


class ScreenNotes extends StatefulWidget {
  const ScreenNotes({super.key});

  @override
  State<ScreenNotes> createState() => _ScreenNotesState();
}

class _ScreenNotesState extends State<ScreenNotes> {
  ///////////////////////////insert database/////////////////////////////
  insertdatabase(tittle, description) {
    NoteDbHelper.instance.insert({
      NoteDbHelper.coltittle: tittle,
      NoteDbHelper.coldescription: description,
      NoteDbHelper.coldate: DateTime.now().toString(),
    });
  }

  updatedatabase(snap, index, tittle, description) {
    NoteDbHelper.instance.update({
      NoteDbHelper.colid: snap.data![index][NoteDbHelper.colid],
      NoteDbHelper.coltittle: tittle,
      NoteDbHelper.coldescription: description,
      NoteDbHelper.coldate: DateTime.now().toString(),
    });
  }

  deletedatabase(snap, index) {
    NoteDbHelper.instance.delete(snap.data![index][NoteDbHelper.colid]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: FutureBuilder(
            future: NoteDbHelper.instance.queryAll(),
            builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snap) {
              if (snap.hasData) {
                return ListView.builder(
                  itemCount: snap.data!.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        deletedatabase(snap, index);
                      },
                      background: Container(
                          color: Colors.red, child: const Icon(Icons.delete)),
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return DescriptionNote(
                                    tittle: snap.data![index]
                                        [NoteDbHelper.coltittle],
                                    description: snap.data![index]
                                        [NoteDbHelper.coldescription]);
                              },
                            ));

                            
                          },
                          leading: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                var title = snap.data![index][NoteDbHelper.coltittle];
                                var description = snap.data![index][NoteDbHelper.coldescription];
                                var titleController = TextEditingController(text: title);
                                var descriptionController = TextEditingController(text: description);

                                return AlertDialog(
                                  title: const Text('Изменение заметки'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: titleController,
                                        decoration: InputDecoration(
                                          labelText: 'Заголовок',
                                        ),
                                      ),
                                      TextField(
                                        controller: descriptionController,
                                        decoration: InputDecoration(
                                          labelText: 'Заметка',
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Отмена'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        var updatedTitle = titleController.text;
                                        var updatedDescription = descriptionController.text;
                                        updatedatabase(snap, index, updatedTitle, updatedDescription);
                                        Navigator.pop(context);
                                         setState(() {});
                                      },
                                      child: const Text('Сохранить'),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.edit),
                        ),


                                    title:
                                        Text(snap.data![index][NoteDbHelper.coltittle]),
                                    subtitle: Text(
                                        snap.data![index][NoteDbHelper.coldescription]),
                                    trailing: Text(snap.data![index][NoteDbHelper.coldate]
                                        .toString()
                                        .substring(0, 10)),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Center(
                              child: CircularProgressIndicator(),
                              );
                        }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              var tittle = '';
              var description = '';
              return AlertDialog(
                title: const Text('Добавить заметку'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                        onChanged: (value) {
                          tittle = value;
                        },
                        decoration: const InputDecoration(hintText: 'Заголовок'),
                        obscureText: false,
                        ),
                        
                    TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onChanged: (value) {
                          description = value;
                        },
                        decoration:
                            const InputDecoration(hintText: 'Описание'),
                        obscureText: false,    
                            ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Отмена')),
                  TextButton(
                      onPressed: () {
                        insertdatabase(tittle, description);
                        Navigator.pop(context);
                        setState(() {});

                      },
                      child: const Text('Сохранить'))
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 90, 10, 104),
      ),
    );
  }
}


