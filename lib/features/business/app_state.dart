part of 'app_cubit.dart';

@immutable
sealed class AppState {}

final class AppInitial extends AppState {}

final class RunOperationsState extends AppState {
  final String message;
  final OperationsEnums operation;
  RunOperationsState({required this.message, required this.operation});
}
