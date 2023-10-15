import 'package:hive/hive.dart';
part 'notes_model.g.dart';
// flutter packages pub run build_runner build

@HiveType(typeId: 0)
class NotesModel extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late String createdAt;

  NotesModel(
      {required this.title,
      required this.description,
      required this.createdAt });
}
