import 'package:flutter/material.dart';
import 'package:greencore_1/models/plant.dart';

class PlantDetailPage extends StatelessWidget {
  final Plant plant;

  PlantDetailPage({required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
                image: DecorationImage(
                  image: NetworkImage(plant.defaultImage['regular_url'] ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        plant.commonName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        plant.scientificName.join(', '),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.green.shade100,
                        Colors.green.shade300,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.eco),
                            SizedBox(width: 8),
                            Text(
                              'Common Name:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          plant.commonName,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        Divider(
                          height: 1,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.science),
                            SizedBox(width: 8),
                            Text(
                              'Scientific Name:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          plant.scientificName.join(', '),
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        Divider(
                          height: 1,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.tag),
                            SizedBox(width: 8),
                            Text(
                              'Other Names:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          plant.otherNames.join(', '),
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        Divider(
                          height: 1,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.circle),
                            SizedBox(width: 8),
                            Text(
                              'Cycle:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          plant.cycle,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        Divider(
                          height: 1,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.water_drop),
                            SizedBox(width: 8),
                            Text(
                              'Watering:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          plant.watering,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        Divider(
                          height: 1,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.wb_sunny),
                            SizedBox(width: 8),
                            Text(
                              'Sunlight:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          plant.sunlight.join(', '),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
