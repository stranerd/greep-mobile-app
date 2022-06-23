import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/domain/firebase/Firebase_service.dart';
import 'package:grip/domain/user/model/manager_request.dart';
import 'package:grip/domain/user/model/manager_request.dart';

part 'new_manager_accepts_state.dart';

class NewManagerAcceptsCubit extends Cubit<NewManagerAcceptsState> {
  NewManagerAcceptsCubit({required this.userCubit})
      : super(NewManagerAcceptsStateInitial()) {
    _userSubscription = userCubit.stream.listen((event) {
      if (event is UserStateFetched) {
        print("checking manager requests");
        checkNewAccepts(event.user.id);
      }
    });
  }

  final UserCubit userCubit;
  StreamSubscription? _streamSubscription;
  late StreamSubscription _userSubscription;

  void checkNewAccepts(String driverId) {
    var statusStream = FirebaseApi.managerAcceptsStream(driverId);
    var status = statusStream.asyncMap((event) {
      return event.docs.first;
    });
    _streamSubscription = status.listen((event) {
      emit(NewManagerAcceptsStateAccepted());
    });
  }

  void makeUnavailable() {
    emit(NewManagerAcceptsStateInitial());
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    _userSubscription.cancel();
    return super.close();
  }
}
