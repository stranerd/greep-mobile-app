import 'package:get_it/get_it.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/domain/user/model/User.dart';

User currentUser(){
  return GetIt.I<UserCubit>().user;
}
