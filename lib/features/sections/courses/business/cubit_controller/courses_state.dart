part of 'courses_cubit.dart';

@immutable
sealed class CoursesState {}

final class CoursesInitial extends CoursesState {}

final class GetCoursesState extends CoursesState {
  final bool isLoaded;
  final int statusCode;
  final bool isSuccess;
  final String message;
  final PaginationModel<CourseModel>? coursesPaginated;
  GetCoursesState({required this.statusCode, required this.isLoaded, required this.isSuccess, required this.message, required this.coursesPaginated,});
}

