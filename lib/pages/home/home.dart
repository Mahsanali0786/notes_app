import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes/model/notes_model.dart';
import 'package:notes/widgets/edit_dialouge.dart';
import 'package:notes/widgets/search_delegate.dart';
import '../../boxes/boxes.dart';
import '../../services/delete.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.query = ''}) : super(key: key);
  final String query;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchWidget());
              },
              icon: const Icon(Icons.search))
        ],
        title: const Text(
          "Notes",
        ),
      ),
      body: ValueListenableBuilder(
          valueListenable: Boxes.getData().listenable(),
          builder: (context, box, _) {
            var data = box.values.toList().cast<NotesModel>();
            return ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      color: Colors.brown.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    data[index].title.toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown.shade800,
                                    ),
                                  ),
                                  Text(
                                    data[index].description.toString(),
                                  ),
                                  Text(
                                    DateFormat.yMMMEd().format(DateTime.parse(data[index].createdAt))
                                        ,style: const TextStyle(color: Colors.black26),

                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            IconButton(
                                onPressed: () {
                                  delete(data[index]);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red.shade400,
                                )),
                            IconButton(
                                onPressed: () {
                                  editDialog(
                                    context,
                                    data[index],
                                    data[index].title.toString(),
                                    data[index].description.toString(),
                                    titleController: titleController,
                                    descriptionController:
                                        descriptionController,
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.brown,
                                )),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showMyDialog(context);
        },
        icon: const Icon(
          Icons.add,
          size: 25,
        ),
        extendedIconLabelSpacing: 10,
        label: const Text(
          "Add",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> showMyDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.brown.shade100,
            title: Text(
              "Add Notes",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown.shade800,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      label: Text("Title"),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLines: 5,
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      label: Text("Description"),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  titleController.clear();
                  descriptionController.clear();
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  final data = NotesModel(
                      title: titleController.text,
                      description: descriptionController.text,
                      createdAt: DateTime.now().toString());

                  final box = Boxes.getData();
                  box.add(data);
                  data.save();
                  titleController.clear();
                  descriptionController.clear();
                  Navigator.pop(context);
                },
                child: Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade800,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
