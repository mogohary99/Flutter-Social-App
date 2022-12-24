import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import '/screens/register_screen/cubit/states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialStates());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String email,
    required String password,
    required String phone,
    required String name,
  }) {
    emit(RegisterLoadingStates());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      userCreate(
        email: email,
        uId: value.user!.uid,
        phone: phone,
        name: name,
      );
      print(value.user!.email);
      //emit(RegisterSuccessStates());
    }).catchError((error) {
      emit(RegisterErrorStates(error.toString()));
    });
  }

  void userCreate({
    required String email,
    required String uId,
    required String phone,
    required String name,
  }) {
    //emit(CreateUserLoadingStates());
    UserModel model = UserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      bio: 'write you bio...',
      isEmailVerified: false,
      image: 'https://img.freepik.com/free-photo/successful-child-with-graduation-cap-backpack-full-books_1098-3455.jpg?w=900&t=st=1664135363~exp=1664135963~hmac=2f9157831a9d02958ba4785ad19c494ec8f6edb7c78be7739ab6f820017fb349',
      cover: 'https://img.freepik.com/free-photo/front-view-male-student-wearing-black-backpack-holding-copybooks-files-blue-wall_140725-42636.jpg?w=996&t=st=1664137296~exp=1664137896~hmac=60e9685d445b63f50c3d65aa9dd3621d2f78d57fe8d843eb2749bd09448017fc',
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(CreateUserSuccessStates());
    }).catchError((error) {
      print(error.toString());
      emit(CreateUserErrorStates(error.toString()));
    });
  }

  bool isPassword = true;
  IconData suffix = Icons.visibility;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(RegisterChangePasswordVisibilityStates());
  }
}
