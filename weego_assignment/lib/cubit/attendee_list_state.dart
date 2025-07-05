import 'package:weego_assignment/model/attendee.dart';
import 'package:weego_assignment/model/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AttendeeListState extends Equatable {
  const AttendeeListState();

  @override
  List<Object?> get props => [];
}

class AttendeeListInitial extends AttendeeListState {}

class AttendeeListLoading extends AttendeeListState {}

class AttendeeListLoaded extends AttendeeListState {
  final List<Attendee> attendees;
  final Meta meta;

  const AttendeeListLoaded(this.attendees, this.meta);

  @override
  List<Object?> get props => [attendees, meta];
}

class AttendeeListError extends AttendeeListState {
  final String message;

  const AttendeeListError(this.message);

  @override
  List<Object?> get props => [message];
}

class AttendeeUpdating extends AttendeeListState {}

class AttendeeUpdateSuccess extends AttendeeListState {
  final Attendee updatedAttendee;

  const AttendeeUpdateSuccess(this.updatedAttendee);

  @override
  List<Object?> get props => [updatedAttendee];
}

class AttendeeUpdateFailure extends AttendeeListState {
  final String message;

  const AttendeeUpdateFailure(this.message);

  @override
  List<Object?> get props => [message];
}
