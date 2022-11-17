import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/domain/firebase/Firebase_service.dart';
import 'package:greep/domain/user/model/manager_request.dart';
import 'package:greep/domain/user/model/manager_request.dart';

part 'new_manager_requests_state.dart';

class NewManagerRequestsCubit extends Cubit<NewManagerRequestsState> {
  NewManagerRequestsCubit({required this.userCubit})
      : super(NewManagerRequestsStateInitial()) {
    _userSubscription = userCubit.stream.listen((event) {
      if (event is UserStateFetched) {
        print("checking manager requests");
        checkNewRequests(event.user.id);
      }
    });
  }

  final UserCubit userCubit;
  StreamSubscription? _streamSubscription;
  late StreamSubscription _userSubscription;

  void checkNewRequests(String driverId) {
    var statusStream = FirebaseApi.managerRequestsStream(driverId);
    var status = statusStream.asyncMap((event) => event.docs
        .map((e) => ManagerRequest.fromServer(e.data(), docId: e.id))
        .first);
    _streamSubscription = status.listen((event) {
      emit(NewManagerRequestsStateAvailable(request: event));
    });
  }

  void makeUnavailable() {
    emit(NewManagerRequestsStateUnAvailable());
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    _userSubscription.cancel();
    return super.close();
  }
}
