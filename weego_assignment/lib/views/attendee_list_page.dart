import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/attendee_list_cubit.dart';
import '../cubit/attendee_list_state.dart';
import '../model/attendee.dart';
import 'edit_attendee_modal.dart';

class AttendeeListPage extends StatelessWidget {
  const AttendeeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendees',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<AttendeeListCubit, AttendeeListState>(
        listener: (context, state) {
          if (state is AttendeeListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          
          if (state is AttendeeUpdateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          
          if (state is AttendeeUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Attendee updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AttendeeListInitial) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<AttendeeListCubit>().fetchAttendees(page: 1);
            });
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AttendeeListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AttendeeListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load attendees',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AttendeeListCubit>().fetchAttendees(page: 1);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is AttendeeUpdateFailure) {
            // I have done this to transition back to list
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AttendeeListLoaded) {
            final attendees = state.attendees;
            final meta = state.meta;

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[100],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Page ${meta.currentPage} of ${meta.totalPages}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Total: ${meta.totalCount} attendees',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: attendees.length,
                    itemBuilder: (context, index) {
                      final attendee = attendees[index];
                      return _buildAttendeeCard(context, attendee);
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed:
                            meta.prevPage != null
                                ? () => context
                                    .read<AttendeeListCubit>()
                                    .fetchAttendees(page: meta.prevPage!)
                                : null,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Previous'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[300],
                          disabledForegroundColor: Colors.grey[600],
                        ),
                      ),

                      Text(
                        '${meta.perPage} items per page',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),

                      ElevatedButton.icon(
                        onPressed:
                            meta.nextPage != null
                                ? () => context
                                    .read<AttendeeListCubit>()
                                    .fetchAttendees(page: meta.nextPage!)
                                : null,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Next'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[300],
                          disabledForegroundColor: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget _buildAttendeeCard(BuildContext context, Attendee attendee) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.deepPurple[100],
                  child: Text(
                    attendee.fullName.split(' ').map((e) => e[0]).join(''),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attendee.fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Age: ${attendee.age} years',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${attendee.completedTripsCount} trips',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.green[700],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                BlocBuilder<AttendeeListCubit, AttendeeListState>(
                  builder: (context, state) {
                    final isUpdating = state is AttendeeUpdating;
                    return IconButton(
                      onPressed: isUpdating ? null : () => _showEditModal(context, attendee),
                      icon: isUpdating 
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.edit, color: Colors.deepPurple),
                      tooltip: isUpdating ? 'Updating...' : 'Edit Attendee',
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildInfoRow(Icons.email, 'Email', attendee.email),
            _buildInfoRow(Icons.phone, 'Phone', attendee.phoneNumber),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.directions_bus,
                        color: Colors.blue[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Vehicle Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildVehicleInfo('Vehicle', attendee.vehicle.name),
                  _buildVehicleInfo(
                    'Type',
                    attendee.vehicle.vehicleType.toUpperCase(),
                  ),
                  _buildVehicleInfo('Plate', attendee.vehicle.numberPlate),
                  _buildVehicleInfo(
                    'Capacity',
                    '${attendee.vehicle.capacity} seats',
                  ),
                  _buildVehicleInfo(
                    'Fuel',
                    attendee.vehicle.fuelType.toUpperCase(),
                  ),
                  _buildVehicleInfo(
                    'Mileage',
                    '${attendee.vehicle.mileage} km/l',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            _buildInfoRow(
              Icons.emergency,
              'Emergency Contact',
              '${attendee.emergencyContactName} (${attendee.emergencyContactPhoneNumber})',
            ),
          ],
        ),
      ),
    );
  }

  void _showEditModal(BuildContext context, Attendee attendee) async {
    final result = await showDialog<Attendee>(
      context: context,
      builder: (BuildContext context) {
        return EditAttendeeModal(attendee: attendee);
      },
    );

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Updating attendee...'),
          backgroundColor: Colors.blue,
        ),
      );
      
      await context.read<AttendeeListCubit>().updateAttendee(result);
      
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildVehicleInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.blue[600],
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
