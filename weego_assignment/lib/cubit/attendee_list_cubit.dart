import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:weego_assignment/utils/constant.dart';
import 'dart:convert';
import 'attendee_list_state.dart';
import '../model/attendee.dart';

class AttendeeListCubit extends Cubit<AttendeeListState> {
  AttendeeListCubit() : super(AttendeeListInitial());

  static const String baseUrl = 'https://api.weego.in';

  Future<void> fetchAttendees({int page = 1}) async {
    try {
      emit(AttendeeListLoading());
      final response = await http.get(
        Uri.parse('$baseUrl/attendees?page=$page'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${JWT}',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final attendeeResponse = AttendeeResponse.fromJson(jsonData);
        emit(AttendeeListLoaded(attendeeResponse.data, attendeeResponse.meta));
      } else {
        emit(
          AttendeeListError('Failed to load attendees: ${response.statusCode}'),
        );
      }
    } catch (e) {
      emit(AttendeeListError('Error: $e'));
    }
  }

  Future<void> updateAttendee(Attendee attendee) async {
    final previousState = state;

    try {
      emit(AttendeeUpdating());

      final response = await http.put(
        Uri.parse('$baseUrl/attendees/${attendee.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${JWT}',
        },
        body: json.encode(attendee.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          _updateAttendeeInLocalState(attendee, previousState);
        } else {
          emit(
            AttendeeUpdateFailure(
              'Failed to update attendee: ${jsonData['message'] ?? 'Unknown error'}',
            ),
          );
          // doin this to restore previous state after showing error
          if (previousState is AttendeeListLoaded) {
            emit(
              AttendeeListLoaded(previousState.attendees, previousState.meta),
            );
          }
        }
      } else {
        emit(
          AttendeeUpdateFailure(
            'Failed to update attendee: ${response.statusCode}',
          ),
        );
        // doin this to restore previous state after showing error
        if (previousState is AttendeeListLoaded) {
          emit(AttendeeListLoaded(previousState.attendees, previousState.meta));
        }
      }
    } catch (e) {
      emit(AttendeeUpdateFailure('Error updating attendee: $e'));
      // Restore previous state after showing error
      if (previousState is AttendeeListLoaded) {
        emit(AttendeeListLoaded(previousState.attendees, previousState.meta));
      }
    }
  }

  void _updateAttendeeInLocalState(
    Attendee updatedAttendee,
    AttendeeListState previousState,
  ) {
    if (previousState is AttendeeListLoaded) {
      final updatedAttendees =
          previousState.attendees.map((attendee) {
            if (attendee.id == updatedAttendee.id) {
              return updatedAttendee;
            }
            return attendee;
          }).toList();
      emit(AttendeeUpdateSuccess(updatedAttendee));
      emit(AttendeeListLoaded(updatedAttendees, previousState.meta));
    }
  }
}
