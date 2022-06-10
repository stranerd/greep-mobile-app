import 'package:bloc/bloc.dart';
import 'package:grip/application/transactions/request/add_trip_request.dart';
import 'package:grip/application/user/driver/add_driver_request.dart';
import 'package:grip/domain/user/UserService.dart';

part 'user_crud_state.dart';

class UserCrudCubit extends Cubit<UserCrudState> {
  UserCrudCubit({required this.userService}) : super(UserCrudInitial());

  final UserService userService;

  void addDriver({required String driverId, required num commission,}) async {
    emit(UserCrudStateLoading());
    var response = await userService.addDriver(AddDriverRequest(driverId: driverId, commission: commission));

    if (response.isError){
      emit(UserCrudStateFailure(errorMessage: response.errorMessage ?? "An error occurred"));
    }

    else {
      emit(UserCrudStateSuccess());
    }
  }


}
