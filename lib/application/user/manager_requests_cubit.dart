import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:grip/application/user/user_crud_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/application/user/user_state.dart';
import 'package:grip/domain/user/UserService.dart';
import 'package:grip/domain/user/model/manager_request.dart';
import 'package:meta/meta.dart';

part 'manager_requests_state.dart';

class ManagerRequestsCubit extends Cubit<ManagerRequestsState> {
  final UserCubit userCubit;
  final UserService userService;
  late StreamSubscription streamSubscription;

  ManagerRequestsCubit({required this.userCubit, required this.userService})
      : super(ManagerRequestsInitial()) {
    streamSubscription = userCubit.stream.listen((event) {
      if (event is UserStateFetched) {
        fetchManagerRequests(event.user.id);
      }
    });
  }

  void fetchManagerRequests(String userId) async {
    var response = await userService.getManagerRequests(userId);
    if (response.isError) {
      emit(ManagerRequestsUnAvailable());
    } else {
      emit(ManagerRequestsAvailable(response.data!));
    }
  }
}
