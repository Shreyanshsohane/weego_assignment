import 'package:weego_assignment/model/meta.dart';
import 'package:weego_assignment/model/vehical.dart';

class AttendeeResponse {
  final bool success;
  final List<Attendee> data;
  final Meta meta;

  AttendeeResponse({
    required this.success,
    required this.data,
    required this.meta,
  });

  factory AttendeeResponse.fromJson(Map<String, dynamic> json) {
    return AttendeeResponse(
      success: json['success'],
      data: List<Attendee>.from(
        json['data'].map((item) => Attendee.fromJson(item)),
      ),
      meta: Meta.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((e) => e.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }

  @override
  String toString() => 'AttendeeResponse(data: $data)';
}

class Attendee {
  final int id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final Map<String, dynamic> profilePictureUrls;
  final String dateOfBirth;
  final int age;
  final String aadharNumber;
  final String panNumber;
  final String emergencyContactName;
  final String emergencyContactPhoneNumber;
  final int completedTripsCount;
  final Vehicle vehicle;

  Attendee({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.profilePictureUrls,
    required this.dateOfBirth,
    required this.age,
    required this.aadharNumber,
    required this.panNumber,
    required this.emergencyContactName,
    required this.emergencyContactPhoneNumber,
    required this.completedTripsCount,
    required this.vehicle,
  });

  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      profilePictureUrls: Map<String, dynamic>.from(json['profile_picture_urls']),
      dateOfBirth: json['date_of_birth'],
      age: json['age'],
      aadharNumber: json['aadhar_number'],
      panNumber: json['pan_number'],
      emergencyContactName: json['emergency_contact_name'],
      emergencyContactPhoneNumber: json['emergency_contact_phone_number'],
      completedTripsCount: json['completed_trips_count'],
      vehicle: Vehicle.fromJson(json['vehicle']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'profile_picture_urls': profilePictureUrls,
      'date_of_birth': dateOfBirth,
      'age': age,
      'aadhar_number': aadharNumber,
      'pan_number': panNumber,
      'emergency_contact_name': emergencyContactName,
      'emergency_contact_phone_number': emergencyContactPhoneNumber,
      'completed_trips_count': completedTripsCount,
      'vehicle': vehicle.toJson(),
    };
  }

  @override
  String toString() => 'Attendee(fullName: $fullName, email: $email)';
}


