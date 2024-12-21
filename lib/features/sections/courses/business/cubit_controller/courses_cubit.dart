import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../actions/endpoints_actions/base_courses_endpoints_actions.dart';

part 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  final BaseCoursesEndpointsActions baseCoursesEndpointsActions;
  CoursesCubit({required this.baseCoursesEndpointsActions}) : super(CoursesInitial());
}
