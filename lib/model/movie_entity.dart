import 'package:objectbox/objectbox.dart';

@Entity()
class MovieEntity {
  @Id()
  int id = 0;

  String? title;
  String? imagePath;
  String? imageUrl;
}
