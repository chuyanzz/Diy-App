import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

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
    return await openDatabase(path, version: 2, onCreate: _createDB);
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
        tools TEXT NOT NULL
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

    // Additional materials
    await db.insert('materials', {'name': 'Cardboard'});
    await db.insert('materials', {'name': 'Paint'});
    await db.insert('materials', {'name': 'Wire'});
    await db.insert('materials', {'name': 'Fabric'});
    await db.insert('materials', {'name': 'Plastic Bottle'});

    // Existing projects
    List<String> woodenBoxTools = [
      "Saw",
      "Hammer",
      "Measuring tape",
      "Sandpaper",
    ];

    List<String> paperAirplaneTools = ["Scissors", "Paper (8.5 x 11 inch)"];

    List<String> photoFrameTools = ["Saw", "Sandpaper", "Wood Glue", "Clamps"];

    List<String> bookshelfTools = [
      "Saw",
      "Hammer",
      "Nails",
      "Measuring tape",
      "Paintbrush",
    ];

    // Insert existing DIY projects
    await db.insert('diy_projects', {
      'title': 'Simple Wooden Box',
      'description': 'A small box made of wood.',
      'steps': '1. Cut the wood\n2. Assemble with nails\n3. Apply glue',
      'tools': jsonEncode(woodenBoxTools),
    });

    await db.insert('diy_projects', {
      'title': 'Paper Airplane',
      'description': 'A simple paper airplane.',
      'steps': '1. Fold the paper\n2. Shape the wings\n3. Throw it!',
      'tools': jsonEncode(paperAirplaneTools),
    });

    await db.insert('diy_projects', {
      'title': 'Photo Frame',
      'description': 'Make a simple wooden photo frame.',
      'steps':
          '1. Cut wood to size\n2. Assemble frame with glue\n3. Attach photo',
      'tools': jsonEncode(photoFrameTools),
    });

    await db.insert('diy_projects', {
      'title': 'Mini Bookshelf',
      'description': 'A small bookshelf for organizing books.',
      'steps': '1. Cut wood\n2. Assemble shelves with nails\n3. Paint it!',
      'tools': jsonEncode(bookshelfTools),
    });

    // New projects
    List<String> cardboardRocketTools = [
      "Scissors",
      "Craft knife",
      "Ruler",
      "Marker",
      "Tape",
    ];
    await db.insert('diy_projects', {
      'title': 'Cardboard Rocket Ship',
      'description': 'Create a fun play rocket from cardboard.',
      'steps':
          '1. Draw rocket outline\n2. Cut out rocket parts\n3. Assemble with tape\n4. Add decorative details',
      'tools': jsonEncode(cardboardRocketTools),
    });

    List<String> birdFeederTools = [
      "Saw",
      "Sandpaper",
      "Paintbrush",
      "Drill",
      "Rope",
    ];
    await db.insert('diy_projects', {
      'title': 'Painted Wooden Bird Feeder',
      'description': 'Make a colorful bird feeder for your garden.',
      'steps':
          '1. Cut wood pieces\n2. Sand smooth\n3. Paint decoratively\n4. Assemble with nails\n5. Attach hanging rope',
      'tools': jsonEncode(birdFeederTools),
    });

    List<String> wireSculptureTools = [
      "Wire cutters",
      "Pliers",
      "Gloves",
      "Wire",
    ];
    await db.insert('diy_projects', {
      'title': 'Abstract Wire Sculpture',
      'description': 'Create an artistic wire sculpture.',
      'steps':
          '1. Plan your design\n2. Bend wire carefully\n3. Connect wire sections\n4. Shape final form',
      'tools': jsonEncode(wireSculptureTools),
    });

    List<String> noSewPillowTools = [
      "Fabric scissors",
      "Measuring tape",
      "Fabric marker",
    ];
    await db.insert('diy_projects', {
      'title': 'No-Sew Fleece Pillow',
      'description': 'Make a cozy pillow without sewing.',
      'steps':
          '1. Cut two equal fabric squares\n2. Create fringe edges\n3. Tie fringe knots\n4. Stuff with filling',
      'tools': jsonEncode(noSewPillowTools),
    });

    List<String> bottlePlanterTools = [
      "Sharp scissors",
      "Paint",
      "Paintbrush",
      "Drill (optional)",
    ];
    await db.insert('diy_projects', {
      'title': 'Recycled Bottle Planter',
      'description': 'Transform a plastic bottle into a garden planter.',
      'steps':
          '1. Clean bottle thoroughly\n2. Cut bottle to desired height\n3. Paint exterior\n4. Add drainage holes\n5. Plant seeds',
      'tools': jsonEncode(bottlePlanterTools),
    });

    List<String> paperMacheMaskTools = [
      "Newspaper",
      "Flour",
      "Water",
      "Balloon",
      "Paint",
      "Paintbrush",
    ];
    await db.insert('diy_projects', {
      'title': 'Paper Mache Decorative Mask',
      'description': 'Create a unique artistic mask using paper mache.',
      'steps':
          '1. Inflate balloon\n2. Mix paper mache paste\n3. Layer newspaper strips\n4. Let dry completely\n5. Paint and decorate',
      'tools': jsonEncode(paperMacheMaskTools),
    });

    List<String> windChimesTools = [
      "Drill",
      "String or Fishing Line",
      "Metal Pipes or Wooden Dowels",
      "Wooden Base",
    ];
    await db.insert('diy_projects', {
      'title': 'Backyard Wind Chimes',
      'description': 'Craft beautiful wind chimes for outdoor decoration.',
      'steps':
          '1. Cut hanging elements\n2. Drill holes in base\n3. Attach strings\n4. Hang and balance',
      'tools': jsonEncode(windChimesTools),
    });

    List<String> pictureFrameTools = [
      "Saw",
      "Wood Glue",
      "Sandpaper",
      "Paint or Varnish",
      "Picture Frame Stand",
    ];
    await db.insert('diy_projects', {
      'title': 'Rustic Wooden Picture Frame',
      'description': 'Create a personalized wooden picture frame.',
      'steps':
          '1. Measure and cut wood\n2. Sand edges smooth\n3. Glue frame pieces\n4. Finish with paint or varnish',
      'tools': jsonEncode(pictureFrameTools),
    });

    List<String> paperLanternTools = [
      "Colored Paper",
      "Scissors",
      "Glue",
      "LED Candle or String Lights",
    ];
    await db.insert('diy_projects', {
      'title': 'Decorative Paper Lantern',
      'description': 'Make a beautiful paper lantern for ambient lighting.',
      'steps':
          '1. Cut paper into geometric shapes\n2. Fold and create lantern structure\n3. Glue edges\n4. Insert light source',
      'tools': jsonEncode(paperLanternTools),
    });

    List<String> woodenCoastersTools = [
      "Wood Slices",
      "Sandpaper",
      "Paint or Wood Stain",
      "Clear Sealant",
      "Felt Pads",
    ];
    await db.insert('diy_projects', {
      'title': 'Wooden Drink Coasters',
      'description': 'Craft personalized wooden coasters.',
      'steps':
          '1. Sand wood slices\n2. Decorate with paint or stain\n3. Apply sealant\n4. Attach felt bottom',
      'tools': jsonEncode(woodenCoastersTools),
    });

    // Existing project material associations
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

    // New project material associations
    await db.insert('project_materials', {
      'project_id': 5,
      'material_id': 6,
    }); // Cardboard

    await db.insert('project_materials', {
      'project_id': 6,
      'material_id': 1,
    }); // Wood
    await db.insert('project_materials', {
      'project_id': 6,
      'material_id': 7,
    }); // Paint

    await db.insert('project_materials', {
      'project_id': 7,
      'material_id': 8,
    }); // Wire

    await db.insert('project_materials', {
      'project_id': 8,
      'material_id': 9,
    }); // Fabric

    await db.insert('project_materials', {
      'project_id': 9,
      'material_id': 10,
    }); // Plastic Bottle

    await db.insert('project_materials', {
      'project_id': 10,
      'material_id': 4,
    }); // Paper

    await db.insert('project_materials', {
      'project_id': 11,
      'material_id': 1,
    }); // Wood

    await db.insert('project_materials', {
      'project_id': 12,
      'material_id': 1,
    }); // Wood

    await db.insert('project_materials', {
      'project_id': 13,
      'material_id': 4,
    }); // Paper

    await db.insert('project_materials', {
      'project_id': 14,
      'material_id': 1,
    }); // Wood
  }

  // Existing getProjects method remains the same
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
