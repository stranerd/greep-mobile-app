import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/domain/user/model/User.dart';
import 'package:greep/ioc.dart';

User getUser(){
  return getIt<UserCubit>().user;
}
