import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../core/enums/operations_enums.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(context) => BlocProvider.of(context);

  void runAnOption({required OperationsEnums operations, String successMessage = "", String errorMessage = ""}){
    switch(operations){
      case OperationsEnums.ADD:
        {
          emit(RunOperationsState(message: "جار الإضافة", operation: operations));
          break;
        }
      case OperationsEnums.EDIT:
        {
          emit(RunOperationsState(message: "جار التعديل", operation: operations));
          break;
        }
      case OperationsEnums.DELETE:
        {
          emit(RunOperationsState(message: "جار الحذف", operation: operations));
          break;
        }
      case OperationsEnums.SUCCESS:
        {
          emit(RunOperationsState(message: successMessage, operation: operations));
          break;
        }
      case OperationsEnums.FAIL:
        {
          emit(RunOperationsState(message: errorMessage, operation: operations));
          break;
        }
    }
  }
}
