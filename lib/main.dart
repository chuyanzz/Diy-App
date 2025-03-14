import 'package:flutter/material.dart';
import 'database_helper.dart';

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
                    return Card(
                      child: ListTile(
                        title: Text(project["title"]),
                        subtitle: Text(project["description"]),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ProjectDetailScreen(project),
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

class ProjectDetailScreen extends StatelessWidget {
  final Map<String, dynamic> project;
  ProjectDetailScreen(this.project);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(project["title"])),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(project["steps"]),
      ),
    );
  }
}
