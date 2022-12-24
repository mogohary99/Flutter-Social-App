import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/screens/login_screen/cubit/states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialStates());

  static LoginCubit get(context) => BlocProvider.of(context);




  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingStates());
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password,).then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      emit(LoginSuccessStates(value.user!.uid));
    }).catchError((error){
      emit(LoginErrorStates(error.toString()));
    });


  }


  bool isPassword=true;
  IconData suffix= Icons.visibility;
  void changePasswordVisibility(){
    isPassword = !isPassword;
    suffix= isPassword ? Icons.visibility : Icons.visibility_off;
    emit(LoginChangePasswordVisibilityStates());
  }
}
