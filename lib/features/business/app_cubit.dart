import 'package:bloc/bloc.dart';
import 'package:course_dashboard/core/enums/dashboard_sections_enum.dart';
import 'package:course_dashboard/core/enums/operations_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(context) => BlocProvider.of(context);

  void runAnOption({required OperationsEnum operations, String successMessage = "", String errorMessage = ""}) {
    switch(operations){
      case OperationsEnum.ADD:
        {
          emit(RunOperationsState(message: "جار الإضافة", operation: operations));
          break;
        }
      case OperationsEnum.EDIT:
        {
          emit(RunOperationsState(message: "جار التعديل", operation: operations));
          break;
        }
      case OperationsEnum.DELETE:
        {
          emit(RunOperationsState(message: "جار الحذف", operation: operations));
          break;
        }
      case OperationsEnum.SUCCESS:
        {
          emit(RunOperationsState(message: successMessage, operation: operations));
          break;
        }
      case OperationsEnum.FAIL:
        {
          emit(RunOperationsState(message: errorMessage, operation: operations));
          break;
        }
    }
  }

  Future<void> changeDashboardSection({required DashboardSectionsEnum section}) async {
    emit(AppInitial());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(ChangeDashboardSectionsState(section: section));
  }
}
