class Plant {
  final int id;
  final String commonName;
  final List<String> scientificName;
  final List<String> otherNames;
  final String cycle;
  final String watering;
  final List<String> sunlight;
  final Map<String, dynamic> defaultImage;

  Plant({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.otherNames,
    required this.cycle,
    required this.watering,
    required this.sunlight,
    required this.defaultImage,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      commonName: json['common_name'] ?? '',
      scientificName: List<String>.from(json['scientific_name'] ?? []),
      otherNames: List<String>.from(json['other_name'] ?? []),
      cycle: json['cycle'] ?? '',
      watering: json['watering'] ?? '',
      sunlight: List<String>.from(json['sunlight'] ?? []),
      defaultImage: json['default_image'] ?? {},
    );
  }
}
