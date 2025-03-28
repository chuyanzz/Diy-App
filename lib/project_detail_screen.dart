import 'package:flutter/material.dart';
import 'dart:convert';

class ProjectDetailScreen extends StatefulWidget {
  final Map<String, dynamic> project;
  ProjectDetailScreen(this.project);

  @override
  _ProjectDetailScreenState createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  List<String> toolsNeeded = [];
  List<Map<String, dynamic>> steps = [];

  // Updated project step images map to include 14 projects
  final Map<int, List<String>> projectStepImages = {
    1: [
      'assets/images/wooden_box_step1.jpg',
      'assets/images/wooden_box_step2.jpg',
      'assets/images/wooden_box_step3.jpg',
    ],
    2: [
      'assets/images/paper_airplane_step1.jpg',
      'assets/images/paper_airplane_step2.jpg',
      'assets/images/paper_airplane_step3.jpg',
    ],
    3: [
      'assets/images/photo_frame_step1.jpg',
      'assets/images/photo_frame_step2.jpg',
      'assets/images/photo_frame_step3.jpg',
    ],
    4: [
      'assets/images/bookshelf_step1.jpg',
      'assets/images/bookshelf_step2.jpg',
      'assets/images/bookshelf_step3.jpg',
    ],
    5: [
      'assets/images/cardboard_rocket_step1.jpg',
      'assets/images/cardboard_rocket_step2.jpg',
      'assets/images/cardboard_rocket_step3.jpg',
    ],
    6: [
      'assets/images/bird_feeder_step1.jpg',
      'assets/images/bird_feeder_step2.jpg',
      'assets/images/bird_feeder_step3.jpg',
    ],
    7: [
      'assets/images/wire_sculpture_step1.jpg',
      'assets/images/wire_sculpture_step2.jpg',
      'assets/images/wire_sculpture_step3.jpg',
    ],
    8: [
      'assets/images/no_sew_pillow_step1.jpg',
      'assets/images/no_sew_pillow_step2.jpg',
      'assets/images/no_sew_pillow_step3.jpg',
    ],
    9: [
      'assets/images/bottle_planter_step1.jpg',
      'assets/images/bottle_planter_step2.jpg',
      'assets/images/bottle_planter_step3.jpg',
    ],
    10: [
      'assets/images/paper_mache_mask_step1.jpg',
      'assets/images/paper_mache_mask_step2.jpg',
      'assets/images/paper_mache_mask_step3.jpg',
    ],
    11: [
      'assets/images/wind_chimes_step1.jpg',
      'assets/images/wind_chimes_step2.jpg',
      'assets/images/wind_chimes_step3.jpg',
    ],
    12: [
      'assets/images/picture_frame_step1.jpg',
      'assets/images/picture_frame_step2.jpg',
      'assets/images/picture_frame_step3.jpg',
    ],
    13: [
      'assets/images/paper_lantern_step1.jpg',
      'assets/images/paper_lantern_step2.jpg',
      'assets/images/paper_lantern_step3.jpg',
    ],
    14: [
      'assets/images/wooden_coasters_step1.jpg',
      'assets/images/wooden_coasters_step2.jpg',
      'assets/images/wooden_coasters_step3.jpg',
    ],
  };

  // Updated project final images map to include 14 projects
  final Map<int, String> projectFinalImages = {
    1: 'assets/images/wooden_box_final.jpg',
    2: 'assets/images/paper_airplane_final.jpg',
    3: 'assets/images/photo_frame_final.jpg',
    4: 'assets/images/bookshelf_final.jpg',
    5: 'assets/images/cardboard_rocket_final.jpg',
    6: 'assets/images/bird_feeder_final.jpg',
    7: 'assets/images/wire_sculpture_final.jpg',
    8: 'assets/images/no_sew_pillow_final.jpg',
    9: 'assets/images/bottle_planter_final.jpg',
    10: 'assets/images/paper_mache_mask_final.jpg',
    11: 'assets/images/wind_chimes_final.jpg',
    12: 'assets/images/picture_frame_final.jpg',
    13: 'assets/images/paper_lantern_final.jpg',
    14: 'assets/images/wooden_coasters_final.jpg',
  };

  @override
  void initState() {
    super.initState();
    _parseProjectData();
  }

  void _parseProjectData() {
    // Parse tools (stored as JSON string)
    if (widget.project["tools"] != null && widget.project["tools"].isNotEmpty) {
      try {
        toolsNeeded = List<String>.from(jsonDecode(widget.project["tools"]));
      } catch (e) {
        print("Error parsing tools: $e");
        toolsNeeded = ["Tools information not available"];
      }
    } else {
      toolsNeeded = ["Tools information not available"];
    }

    // Create steps using step descriptions and hardcoded images
    final String stepsText = widget.project["steps"] ?? "";
    final List<String> stepLines = stepsText.split('\n');
    final int projectId = widget.project["id"];
    final List<String> stepImages = projectStepImages[projectId] ?? [];

    steps = [];
    for (int i = 0; i < stepLines.length; i++) {
      String description = stepLines[i].replaceFirst(RegExp(r'^\d+\.\s*'), '');
      String imagePath =
          i < stepImages.length
              ? stepImages[i]
              : 'assets/images/default_step.jpg';

      steps.add({"description": description, "image": imagePath});
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectImage =
        widget.project["imagePath"] ?? 'assets/images/default.jpg';
    final projectId = widget.project["id"];
    final finalImage =
        projectFinalImages[projectId] ?? 'assets/images/default_final.jpg';

    return Scaffold(
      appBar: AppBar(title: Text(widget.project["title"])),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Image
            Image.asset(
              projectImage,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: Center(child: Icon(Icons.image, size: 50)),
                );
              },
            ),

            SizedBox(height: 16),
            // Project title and description
            Text(
              widget.project["title"],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(widget.project["description"], style: TextStyle(fontSize: 16)),

            // Tools Section
            SizedBox(height: 24),
            Text(
              "Tools Needed:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  toolsNeeded
                      .map(
                        (tool) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Icon(Icons.arrow_right, size: 20),
                              SizedBox(width: 4),
                              Text(tool, style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
            ),

            // Step-by-Step Instructions
            SizedBox(height: 24),
            Text(
              "Step-by-Step Instructions:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: steps.length,
              itemBuilder: (context, index) {
                final step = steps[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Step ${index + 1}: ${step["description"]}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          step["image"],
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback if image doesn't exist
                            return Container(
                              width: double.infinity,
                              height: 180,
                              color: Colors.grey[300],
                              child: Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 40,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Final Result Section
            SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Final Result:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    finalImage,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback if image doesn't exist
                      return Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[300],
                        child: Center(
                          child: Icon(Icons.image_not_supported, size: 40),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "This is how your finished ${widget.project["title"].toLowerCase()} should look!",
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ],
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
