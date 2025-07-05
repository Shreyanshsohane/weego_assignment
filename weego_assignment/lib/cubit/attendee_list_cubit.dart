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

      await Future.delayed(const Duration(seconds: 10));

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
        // print('API Response: $jsonData');
        final attendeeResponse = AttendeeResponse.fromJson(jsonData);
        emit(AttendeeListLoaded(attendeeResponse.data, attendeeResponse.meta));
      } else {
        emit(
          AttendeeListError('Failed to load attendees: ${response.statusCode}'),
        );
      }
    } catch (e) {
      print(e);
      emit(AttendeeListError('Error: $e'));
    }
  }

  Future<void> updateAttendee(Attendee attendee) async {
    try {
      emit(AttendeeUpdating());

      await Future.delayed(const Duration(seconds: 1));

      emit(AttendeeUpdateSuccess(attendee));
    } catch (e) {
      emit(AttendeeUpdateFailure('Error updating attendee: $e'));
    }
  }
}
