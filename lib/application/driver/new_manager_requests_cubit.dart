import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grip/domain/firebase/Firebase_service.dart';
import 'package:grip/domain/user/model/manager_request.dart';

part 'new_manager_requests_state.dart';

class NewManagerRequestsCubit extends Cubit<NewManagerRequestsState> {
  NewManagerRequestsCubit() : super(NewManagerRequestsStateLoading());
  StreamSubscription? _streamSubscription;

  void checkNewRequests(String userId) {
      var statusStream = FirebaseApi.managerRequestsStream(userId);
      var status = statusStream.asyncMap((event) =>
          event.docs.map((e) => ManagerRequest.fromServer(e.data(),docId: e.id)).first);
      _streamSubscription = status.listen((event) {
        emit(NewManagerRequestsStateFetched(request: event));
      });
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
