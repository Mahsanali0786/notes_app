import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes/pages/home/home.dart';
import 'package:notes/services/delete.dart';
import 'package:notes/widgets/edit_dialouge.dart';

import '../../../boxes/boxes.dart';
import '../../../model/notes_model.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key, required this.query});
  final String query;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: Boxes.getData().listenable(),
          builder: (context, box, _) {
            var data = box.values
                .where((task) => task.title == query)
                .toList()
                .cast<NotesModel>();
            return data.isNotEmpty
                ? ListView.builder(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                    })
                : const Center(
                    child: Text('no task found'),
                  );
          }),
    );
  }
}
