import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/driver/new_manager_accepts_cubit.dart';
import 'package:grip/application/driver/new_manager_requests_cubit.dart';
import 'package:grip/application/driver/request/accept_manager_request.dart';
import 'package:grip/application/driver/request/add_driver_request.dart';
import 'package:grip/application/driver/drivers_cubit.dart';
import 'package:grip/application/user/request/EditUserRequest.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/domain/firebase/Firebase_service.dart';
import 'package:grip/domain/user/UserService.dart';

part 'user_crud_state.dart';

class UserCrudCubit extends Cubit<UserCrudState> {
  UserCrudCubit({required this.userService}) : super(UserCrudInitial());

  final UserService userService;

  void addDriver({
    required String driverId,
    required String managerId,
    required String managerName,
    required num commission,
  }) async {
    emit(UserCrudStateLoading());
    var response = await userService.addDriver(AddDriverRequest(
        driverId: driverId, commission: commission, add: true));

    if (response.isError) {
      emit(UserCrudStateFailure(
          errorMessage: response.errorMessage ?? "An error occurred"));
    } else {
      emit(UserCrudStateSuccess(isDriverAdd: true));
      FirebaseApi.sendManagerRequest(
          driverId: driverId,
          managerId: managerId,
          managerName: managerName,
          commission: commission.toString());
    }
  }

  void acceptManager(
      {
        required String managerId,
        required String driverId,
      }) async {
    print("accepting manager");
    emit(UserCrudStateLoading(isManagerAdd: true));
    var response = await userService.acceptManager(
        AcceptManagerRequest(managerId: managerId, accept: true));
    sendAccept(managerId);

    if (response.isError) {
      emit(UserCrudStateFailure(
          errorMessage: response.errorMessage ?? "An error occurred"));
    } else {
      emit(UserCrudStateSuccess(isManagerAdd: true));
    }
    clearManagerRequests(driverId);

    GetIt.I<DriversCubit>().fetchUserDrivers();
  }

  void rejectManager(
      {required String managerId, required String driverId}) async {
    print("rejecting manager");

    emit(UserCrudStateLoading(isManagerReject: true));
    var response = await userService.acceptManager(
      AcceptManagerRequest(managerId: managerId, accept: false),
    );

    if (response.isError) {
      emit(UserCrudStateFailure(
          errorMessage: response.errorMessage ?? "An error occurred"));
    } else {
      emit(UserCrudStateSuccess(isManagerReject: true));
    }
    clearManagerRequests(driverId);
  }

  void clearManagerRequests(String driverId) {
    FirebaseApi.clearManagerRequests(driverId);
    GetIt.I<NewManagerRequestsCubit>().makeUnavailable();
  }

  void sendAccept(String managerId) {
    print("accepting request");
    FirebaseApi.sendManagerAccept(managerId: managerId);
    GetIt.I<NewManagerAcceptsCubit>().makeUnavailable();
  }

  void editUser(EditUserRequest request) async {
    emit(UserCrudStateLoading());

    var response = await userService.editUser(request);
    if (response.isError) {
      emit(UserCrudStateFailure(
          errorMessage: response.errorMessage ?? "An error occurred"));
    } else {
      emit(UserCrudStateSuccess(isEditUser: true));
      GetIt.I<UserCubit>().fetchUser();
    }
  }
}
