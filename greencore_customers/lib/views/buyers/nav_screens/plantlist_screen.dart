import 'package:flutter/material.dart';
import 'package:greencore_1/models/plant.dart';
import 'package:greencore_1/services/services.dart';
import 'package:greencore_1/views/buyers/inner_screens/plantdetail.dart';

// Import your service to fetch data

class PlantListView extends StatefulWidget {
  @override
  _PlantListViewState createState() => _PlantListViewState();
}

class _PlantListViewState extends State<PlantListView> {
  final ScrollController _scrollController = ScrollController();
  late List<Plant> _plants = [];
  int _pageCount = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPlants();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchPlants() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final List<Plant> newPlants = await TrefleService.fetchPlants(_pageCount);
      setState(() {
        _plants.addAll(newPlants);
        _pageCount++;
      });
    } catch (error) {
      // Handle error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchPlants();
    }
  }

  Widget _buildList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _plants.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _plants.length) {
          final Plant plant = _plants[index];
          String? defaultImageOriginalUrl = plant.defaultImage['original_url'];
          String? defaultImageRegularUrl = plant.defaultImage['regular_url'];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlantDetailPage(plant: plant),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(defaultImageRegularUrl ?? ''),
                      radius: 32,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plant.commonName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            plant.scientificName.join(', '),
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Plant Library',
            style: TextStyle(
              color: Colors.green.shade600,
            ),
          ),
        ),
      ),
      body: _buildList(),
    );
  }
}
