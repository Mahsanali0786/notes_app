import 'package:flutter/material.dart';
import 'package:notes/model/notes_model.dart';

Future<void> editDialog(BuildContext context, NotesModel notesModel,
    String title, String description,
    {required TextEditingController titleController,
    required TextEditingController descriptionController}) async {
  titleController.text = title;
  descriptionController.text = description;
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.brown.shade100,
          title: Text(
            "Edit Note",
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
                )),
            TextButton(
              onPressed: () async {
                notesModel.title = titleController.text.toString();
                notesModel.description = descriptionController.text.toString();

                await notesModel.save();

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
