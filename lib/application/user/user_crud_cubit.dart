import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/user/driver/accept_manager_request.dart';
import 'package:grip/application/user/driver/add_driver_request.dart';
import 'package:grip/application/user/drivers_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/domain/user/UserService.dart';

part 'user_crud_state.dart';

class UserCrudCubit extends Cubit<UserCrudState> {
  UserCrudCubit({required this.userService}) : super(UserCrudInitial());

  final UserService userService;

  void addDriver({
    required String driverId,
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
    }
  }

  void acceptManager({
    required String managerId,
  }) async {
    print("accepting manager");
    emit(UserCrudStateLoading(isManagerAdd: true));
    var response = await userService.acceptManager(
        AcceptManagerRequest(managerId: managerId, accept: true));

    if (response.isError) {
      emit(UserCrudStateFailure(
          errorMessage: response.errorMessage ?? "An error occurred"));
    } else {
      emit(UserCrudStateSuccess(isManagerAdd: true));
    }

    GetIt.I<DriversCubit>().fetchUserDrivers();

  }
  void rejectManager({
    required String managerId,
  }) async {
    print("rejecting manager");

    emit(UserCrudStateLoading(isManagerReject: true));
    var response = await userService.acceptManager(
        AcceptManagerRequest(managerId: managerId, accept: false));

    if (response.isError) {
      emit(UserCrudStateFailure(
          errorMessage: response.errorMessage ?? "An error occurred"));
    } else {
      emit(UserCrudStateSuccess(isManagerReject: true));
    }
  }
}
