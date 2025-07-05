class Vehicle {
  final int id;
  final String name;
  final String vehicleType;
  final String numberPlate;
  final String model;
  final int capacity;
  final String fuelType;
  final int mileage;
  final Map<String, dynamic> vehiclePhotoUrls;
  final String parkingLocation;

  Vehicle({
    required this.id,
    required this.name,
    required this.vehicleType,
    required this.numberPlate,
    required this.model,
    required this.capacity,
    required this.fuelType,
    required this.mileage,
    required this.vehiclePhotoUrls,
    required this.parkingLocation,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      name: json['name'],
      vehicleType: json['vehicle_type'],
      numberPlate: json['number_plate'],
      model: json['model'],
      capacity: json['capacity'],
      fuelType: json['fuel_type'],
      mileage: json['mileage'],
      vehiclePhotoUrls: Map<String, dynamic>.from(json['vehicle_photo_urls']),
      parkingLocation: json['parking_location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'vehicle_type': vehicleType,
      'number_plate': numberPlate,
      'model': model,
      'capacity': capacity,
      'fuel_type': fuelType,
      'mileage': mileage,
      'vehicle_photo_urls': vehiclePhotoUrls,
      'parking_location': parkingLocation,
    };
  }

  @override
  String toString() => 'Vehicle(name: $name, numberPlate: $numberPlate)';
}
