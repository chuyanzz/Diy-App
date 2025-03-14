import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('diy.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE materials (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE diy_projects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        steps TEXT NOT NULL,
        image TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE project_materials (
        project_id INTEGER,
        material_id INTEGER,
        FOREIGN KEY (project_id) REFERENCES diy_projects(id),
        FOREIGN KEY (material_id) REFERENCES materials(id)
      )
    ''');
  }

  Future<void> initializeSampleData() async {
    final db = await database;

    final count =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM materials'),
        ) ??
        0;
    if (count > 0) return; // Prevent duplicate inserts

    // Insert materials
    await db.insert('materials', {'name': 'Wood'});
    await db.insert('materials', {'name': 'Nails'});
    await db.insert('materials', {'name': 'Glue'});
    await db.insert('materials', {'name': 'Paper'});
    await db.insert('materials', {'name': 'Tape'});

    // Insert DIY projects
    await db.insert('diy_projects', {
      'title': 'Simple Wooden Box',
      'description': 'A small box made of wood.',
      'steps': '1. Cut the wood\n2. Assemble with nails\n3. Apply glue',
      'image': '',
    });

    await db.insert('diy_projects', {
      'title': 'Paper Airplane',
      'description': 'A simple paper airplane.',
      'steps': '1. Fold the paper\n2. Shape the wings\n3. Throw it!',
      'image': '',
    });

    await db.insert('diy_projects', {
      'title': 'Photo Frame',
      'description': 'Make a simple wooden photo frame.',
      'steps':
          '1. Cut wood to size\n2. Assemble frame with glue\n3. Attach photo',
      'image': '',
    });

    await db.insert('diy_projects', {
      'title': 'Mini Bookshelf',
      'description': 'A small bookshelf for organizing books.',
      'steps': '1. Cut wood\n2. Assemble shelves with nails\n3. Paint it!',
      'image': '',
    });

    // Associate projects with materials
    await db.insert('project_materials', {
      'project_id': 1,
      'material_id': 1,
    }); // Wood
    await db.insert('project_materials', {
      'project_id': 1,
      'material_id': 2,
    }); // Nails
    await db.insert('project_materials', {
      'project_id': 1,
      'material_id': 3,
    }); // Glue
    await db.insert('project_materials', {
      'project_id': 2,
      'material_id': 4,
    }); // Paper
    await db.insert('project_materials', {
      'project_id': 3,
      'material_id': 1,
    }); // Wood
    await db.insert('project_materials', {
      'project_id': 3,
      'material_id': 3,
    }); // Glue
    await db.insert('project_materials', {
      'project_id': 4,
      'material_id': 1,
    }); // Wood
    await db.insert('project_materials', {
      'project_id': 4,
      'material_id': 2,
    }); // Nails
  }

  Future<List<Map<String, dynamic>>> getProjects(List<int> materialIds) async {
    final db = await database;
    if (materialIds.isEmpty) return [];

    final placeholders = List.filled(materialIds.length, '?').join(',');
    final result = await db.rawQuery('''
      SELECT DISTINCT diy_projects.* FROM diy_projects
      JOIN project_materials ON diy_projects.id = project_materials.project_id
      WHERE project_materials.material_id IN ($placeholders)
    ''', materialIds.map((id) => id.toString()).toList());

    return result;
  }
}
