import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weego_assignment/model/vehical.dart';
import '../model/attendee.dart';
import '../cubit/attendee_list_cubit.dart';
import '../cubit/attendee_list_state.dart';

class EditAttendeeModal extends StatefulWidget {
  final Attendee attendee;

  const EditAttendeeModal({super.key, required this.attendee});

  @override
  State<EditAttendeeModal> createState() => _EditAttendeeModalState();
}

class _EditAttendeeModalState extends State<EditAttendeeModal> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _emergencyNameController;
  late TextEditingController _emergencyPhoneController;
  late TextEditingController _aadharController;
  late TextEditingController _panController;
  late TextEditingController _vehicleNameController;
  late TextEditingController _vehiclePlateController;
  late TextEditingController _vehicleCapacityController;
  late TextEditingController _vehicleMileageController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.attendee.fullName);
    _emailController = TextEditingController(text: widget.attendee.email);
    _phoneController = TextEditingController(text: widget.attendee.phoneNumber);
    _emergencyNameController = TextEditingController(
      text: widget.attendee.emergencyContactName,
    );
    _emergencyPhoneController = TextEditingController(
      text: widget.attendee.emergencyContactPhoneNumber,
    );
    _aadharController = TextEditingController(
      text: widget.attendee.aadharNumber,
    );
    _panController = TextEditingController(text: widget.attendee.panNumber);
    _vehicleNameController = TextEditingController(
      text: widget.attendee.vehicle.name,
    );
    _vehiclePlateController = TextEditingController(
      text: widget.attendee.vehicle.numberPlate,
    );
    _vehicleCapacityController = TextEditingController(
      text: widget.attendee.vehicle.capacity.toString(),
    );
    _vehicleMileageController = TextEditingController(
      text: widget.attendee.vehicle.mileage.toString(),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _aadharController.dispose();
    _panController.dispose();
    _vehicleNameController.dispose();
    _vehiclePlateController.dispose();
    _vehicleCapacityController.dispose();
    _vehicleMileageController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_fullNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Full name is required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email is required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone number is required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final updatedAttendee = Attendee(
      id: widget.attendee.id,
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      profilePictureUrls: widget.attendee.profilePictureUrls,
      dateOfBirth: widget.attendee.dateOfBirth,
      age: widget.attendee.age,
      aadharNumber: _aadharController.text.trim(),
      panNumber: _panController.text.trim(),
      emergencyContactName: _emergencyNameController.text.trim(),
      emergencyContactPhoneNumber: _emergencyPhoneController.text.trim(),
      completedTripsCount: widget.attendee.completedTripsCount,
      vehicle: Vehicle(
        id: widget.attendee.vehicle.id,
        name: _vehicleNameController.text.trim(),
        vehicleType: widget.attendee.vehicle.vehicleType,
        numberPlate: _vehiclePlateController.text.trim(),
        model: widget.attendee.vehicle.model,
        capacity: int.tryParse(_vehicleCapacityController.text.trim()) ?? 0,
        fuelType: widget.attendee.vehicle.fuelType,
        mileage: int.tryParse(_vehicleMileageController.text.trim()) ?? 0,
        vehiclePhotoUrls: widget.attendee.vehicle.vehiclePhotoUrls,
        parkingLocation: widget.attendee.vehicle.parkingLocation,
      ),
    );

    context.read<AttendeeListCubit>().updateAttendee(updatedAttendee);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AttendeeListCubit, AttendeeListState>(
      listener: (context, state) {
        if (state is AttendeeUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Attendee updated successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            if (context.mounted) {
              Navigator.of(context).pop(state.updatedAttendee);
            }
          });
        } else if (state is AttendeeUpdateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message), 
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Attendee',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[700],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Personal Information'),
                      _buildTextField(
                        'Full Name',
                        _fullNameController,
                        Icons.person,
                      ),
                      _buildTextField('Email', _emailController, Icons.email),
                      _buildTextField(
                        'Phone Number',
                        _phoneController,
                        Icons.phone,
                      ),
                      _buildTextField(
                        'Aadhar Number',
                        _aadharController,
                        Icons.credit_card,
                      ),
                      _buildTextField(
                        'PAN Number',
                        _panController,
                        Icons.credit_card,
                      ),

                      const SizedBox(height: 20),
                      _buildSectionTitle('Emergency Contact'),
                      _buildTextField(
                        'Emergency Contact Name',
                        _emergencyNameController,
                        Icons.emergency,
                      ),
                      _buildTextField(
                        'Emergency Contact Phone',
                        _emergencyPhoneController,
                        Icons.phone,
                      ),

                      const SizedBox(height: 20),
                      _buildSectionTitle('Vehicle Information'),
                      _buildTextField(
                        'Vehicle Name',
                        _vehicleNameController,
                        Icons.directions_bus,
                      ),
                      _buildTextField(
                        'Number Plate',
                        _vehiclePlateController,
                        Icons.confirmation_number,
                      ),
                      _buildTextField(
                        'Capacity',
                        _vehicleCapacityController,
                        Icons.airline_seat_recline_normal,
                        keyboardType: TextInputType.number,
                      ),
                      _buildTextField(
                        'Mileage (km/l)',
                        _vehicleMileageController,
                        Icons.speed,
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 20),
                      BlocBuilder<AttendeeListCubit, AttendeeListState>(
                        builder: (context, state) {
                          final isLoading = state is AttendeeUpdating;

                          return Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _saveChanges,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  child:
                                      isLoading
                                          ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                          : const Text('Save Changes'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed:
                                      isLoading
                                          ? null
                                          : () => Navigator.of(context).pop(),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.deepPurple,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple[700],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          ),
        ),
      ),
    );
  }
}
