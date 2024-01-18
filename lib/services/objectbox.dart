import 'package:machine_test_gritstone/model/movie_entity.dart';
import 'package:machine_test_gritstone/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ObjectBox {
  late final Store store;
  static ObjectBox? _instance;

  late Box<MovieEntity> movieBox;

  static ObjectBox get instance {
    return _instance!;
  }

  ObjectBox._create(this.store) {
    movieBox = store.box<MovieEntity>();
  }

  static Future<void> create() async {
    if (_instance == null) {
      final docsDir = await getApplicationDocumentsDirectory();
      final store =
          await openStore(directory: p.join(docsDir.path, "machine_test"));
      _instance = ObjectBox._create(store);
    }
  }
}
