import 'package:bloc/bloc.dart';
import 'package:greep/domain/user/UserService.dart';
import 'package:greep/domain/user/model/User.dart';
import 'package:meta/meta.dart';

part 'user_list_state.dart';

class UserListCubit extends Cubit<UserListState> {
  final UserService userService;

  UserListCubit({
    required this.userService,
  }) : super(UserListInitial());

  void fetchUserRankings({
    bool softUpdate = false,required String rankingType
  }) async {
    if (!softUpdate) {
      emit(UserListStateLoading());
    }

    var response = await userService.fetchUserRankings(rankingType: rankingType,);
    if (response.isError) {
      emit(
        UserListStateError(
          errorMessage:
              response.errorMessage ?? "An error occurred, please try again",
        ),
      );
    } else {
      emit(UserListStateRankings(users: response.data ?? []));
    }
  }
}
