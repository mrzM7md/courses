part of 'app_cubit.dart';

@immutable
sealed class AppState {}

final class AppInitial extends AppState {}

final class RunOperationsState extends AppState {
  final String message;
  final OperationsEnum operation;
  RunOperationsState({required this.message, required this.operation});
}

final class ChangeDashboardSectionsState extends AppState {
  final DashboardSectionsEnum section;
  ChangeDashboardSectionsState({required this.section});
}
