import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'project_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initializeSampleData();
  runApp(DIYApp());
}

class DIYApp extends StatefulWidget {
  @override
  _DIYAppState createState() => _DIYAppState();
}

class _DIYAppState extends State<DIYApp> {
  List<Map<String, dynamic>> materials = [];
  List<int> selectedMaterials = [];
  List<Map<String, dynamic>> projects = [];

  // Updated project images map to include 14 projects
  final Map<int, String> projectImages = {
    1: 'assets/images/box.jpg',
    2: 'assets/images/paper_airplane.jpg',
    3: 'assets/images/photo_frame.jpg',
    4: 'assets/images/bookshelf.jpg',
    5: 'assets/images/cardboard_rocket.jpg',
    6: 'assets/images/bird_feeder.jpg',
    7: 'assets/images/wire_sculpture.jpg',
    8: 'assets/images/no_sew_pillow.jpg',
    9: 'assets/images/bottle_planter.jpg',
    10: 'assets/images/paper_mache_mask.jpg',
    11: 'assets/images/wind_chimes.jpg',
    12: 'assets/images/picture_frame.jpg',
    13: 'assets/images/paper_lantern.jpg',
    14: 'assets/images/wooden_coasters.jpg',
  };

  @override
  void initState() {
    super.initState();
    _loadMaterials();
  }

  Future<void> _loadMaterials() async {
    final db = await DatabaseHelper.instance.database;
    final materialData = await db.query('materials');

    setState(() {
      materials = materialData;
    });
  }

  Future<void> _filterProjects() async {
    final data = await DatabaseHelper.instance.getProjects(selectedMaterials);
    setState(() {
      projects = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("DIY Project Finder")),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  'Select Materials',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              ...materials.map((material) {
                return CheckboxListTile(
                  title: Text(material['name']),
                  value: selectedMaterials.contains(material['id']),
                  onChanged: (bool? selected) {
                    setState(() {
                      if (selected == true) {
                        selectedMaterials.add(material['id']);
                      } else {
                        selectedMaterials.remove(material['id']);
                      }
                    });
                    _filterProjects();
                  },
                );
              }).toList(),
            ],
          ),
        ),
        body:
            projects.isEmpty
                ? Center(child: Text('Select materials to see projects'))
                : ListView.builder(
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    final projectId = project["id"];

                    return Card(
                      child: ListTile(
                        leading: Image.asset(
                          projectImages[projectId] ??
                              'assets/images/default.jpg',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.broken_image);
                          },
                        ),
                        title: Text(project["title"]),
                        subtitle: Text(project["description"]),
                        onTap: () {
                          // Add the image path to the project map
                          final projectWithImage = Map<String, dynamic>.from(
                            project,
                          );
                          projectWithImage['imagePath'] =
                              projectImages[projectId];

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      ProjectDetailScreen(projectWithImage),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
