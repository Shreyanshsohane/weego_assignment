import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
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
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIyIiwic2NwIjoidXNlciIsImV4cCI6MTc1MjkxMjAyOSwiaWF0IjoxNzUxNzAyNDI5LCJqdGkiOiJhNjEyOTA0ZS1kMDVlLTRkMWEtOWFmYy03MGVjN2ZlNDcxNzEifQ.eQ9P0URb-Vpz9VXm8otRQTp-1fcS4qD8bVnHyttJSuk',
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
    try {
      final previousState = state;
      emit(AttendeeUpdating());

      final response = await http.put(
        Uri.parse('$baseUrl/attendees/${attendee.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIyIiwic2NwIjoidXNlciIsImV4cCI6MTc1MjkxMjAyOSwiaWF0IjoxNzUxNzAyNDI5LCJqdGkiOiJhNjEyOTA0ZS1kMDVlLTRkMWEtOWFmYy03MGVjN2ZlNDcxNzEifQ.eQ9P0URb-Vpz9VXm8otRQTp-1fcS4qD8bVnHyttJSuk',
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
      }
    } catch (e) {
      emit(AttendeeUpdateFailure('Error updating attendee: $e'));
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
