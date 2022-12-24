import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import '/screens/new_post/new_post_screen.dart';
import '/screens/chats/chats_screen.dart';
import '/screens/feeds/feeds_screen.dart';
import '/screens/settings/settings_screen.dart';
import '/screens/users/users_screen.dart';
import '/constants.dart';
import '/models/user_model.dart';
import '/screens/social_layout/cubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialStates());

  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void getUserData() {
    emit(SocialGetUserLoadingStates());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      print(value.data());
      userModel = UserModel.fromJson(value.data()!);
      emit(SocialGetUserSuccessStates());
    }).catchError((error) {
      emit(SocialGetUserErrorStates(error.toString()));
    });
  }

  int currentIndex = 0;
  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];
  List<String> titles = [
    'Home',
    'Chats',
    'Add post'
        'Users',
    'Settings',
  ];

  void changeBottomNav(int index) {
    if (index == 1) {
      getAllUsers();
    }
    if (index == 2) {
      currentIndex = 0;
      emit(SocialNewPostStates());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavBarStates());
    }
  }

/*
  XFile? profileImage;
  void getImage()async{
    final ImagePicker picker = ImagePicker();
    //final img = await picker.pickImage(source: ImageSource.gallery);
    picker.pickImage(source: ImageSource.gallery).then((value) {
      profileImage = value;
      emit(SocialSuccessGetProfileImageStates());
    }).catchError((error){
      print(error.toString());
      emit(SocialErrorGetProfileImageStates());
    });
    //profileImage = img;

  }
  */
  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialSuccessGetProfileImageStates());
    } else {
      print('no image selected');
      emit(SocialErrorGetProfileImageStates());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialSuccessGetCoverImageStates());
    } else {
      print('no image selected');
      emit(SocialErrorGetCoverImageStates());
    }
  }

  //String profileImageUrl = '';
  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUserUpdateLoadingStates());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print('vallllll  $value');
        //emit(SocialSuccessUploadProfileImageStates());
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          image: value,
        );
      }).catchError((error) {
        print('errrrrr11 ${error.toString()}');
        emit(SocialErrorUploadProfileImageStates());
      });
    }).catchError((error) {
      print('errrrrr  ${error.toString()}');
      emit(SocialErrorUploadProfileImageStates());
    });
  }

  // String coverImageUrl = '';
  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUserUpdateLoadingStates());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print('vallllll  $value');
        //emit(SocialSuccessUploadCoverImageStates());
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          cover: value,
        );
      }).catchError((error) {
        print('errrrrr11 ${error.toString()}');
        emit(SocialErrorUploadCoverImageStates());
      });
    }).catchError((error) {
      print('errrrrr  ${error.toString()}');
      emit(SocialErrorUploadCoverImageStates());
    });
  }

  /*
  void updateUserImages({
    required String name,
    required String phone,
    required String bio,
     String? email,
  }) {
    emit(SocialUserUpdateLoadingStates());
    if(profileImage !=null){
      uploadProfileImage();
    }else if(coverImage !=null){
      uploadCoverImage();
    }else{
      updateUser(name: name,phone: phone,bio: bio,email: email,);
    }

  }

   */

  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? email,
    String? image,
    String? cover,
  }) {
    UserModel model = UserModel(
      name: name,
      email: email ?? userModel!.email,
      phone: phone,
      uId: userModel!.uId,
      bio: bio,
      isEmailVerified: false,
      image: image ?? userModel!.image,
      cover: cover ?? userModel!.cover,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialErrorUserUpdateStates());
    });
  }

  ////////////////////////////////////////////////
  //Create post
  File? postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialSuccessGetPostImageStates());
    } else {
      print('no image selected');
      emit(SocialErrorGetPostImageStates());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageStates());
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  }) {
    emit(SocialCreatePostLoadingStates());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print('va$value');
        createPost(dateTime: dateTime, text: text, postImage: value);
      }).catchError((error) {
        print('errrrrr11 ${error.toString()}');
        emit(SocialCreatePostErrorStates());
      });
    }).catchError((error) {
      print('errrrrr  ${error.toString()}');
      emit(SocialCreatePostErrorStates());
    });
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingStates());
    PostModel model = PostModel(
      name: userModel!.name,
      uId: userModel!.uId,
      image: userModel!.image,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessStates());
    }).catchError((error) {
      emit(SocialCreatePostErrorStates());
    });
  }

  //////get posts
  List<PostModel> posts = [];
  List<String> postId = [];
  List<int> likes = [];
  List<int> comments = [];

  void getPosts() {
    emit(SocialGetPostsLoadingStates());
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);

          postId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
        }).catchError((error) {});
      });
      value.docs.forEach((element) {
        element.reference.collection('comments').get().then((value) {
          comments.add(value.docs.length);
        }).catchError((error) {});
      });
      emit(SocialGetPostsSuccessStates());
    }).catchError((error) {
      emit(SocialGetPostsErrorStates(error.toString()));
    });
  }

  //like post
  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({
      'likes': true,
    }).then((value) {
      emit(SocialLikePostsSuccessStates());
    }).catchError((error) {
      emit(SocialLikePostsErrorStates(error.toString()));
    });
  }

  //comment
  void commentOnPost({
    required String postId,
    required String comment,
  }) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(userModel!.uId)
        .set({
      'comment': comment,
    }).then((value) {
      emit(SocialCommentOnPostsSuccessStates());
    }).catchError((error) {
      emit(SocialCommentOnPostPostsErrorStates(error.toString()));
    });
  }

  //get all users
  List<UserModel> users = [];

  void getAllUsers() {
    emit(SocialGetAllUserLoadingStates());
    if (users.isEmpty) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userModel!.uId) {
            users.add(UserModel.fromJson(element.data()));
          }
        });
        emit(SocialGetAllUserSuccessStates());
      }).catchError((error) {
        emit(SocialGetAllUserErrorStates(error.toString()));
      });
    }
  }

//chat
  void sendMessage({
    required String text,
    required String dateTime,
    required String receiverId,
  }) {
    MessageModel model = MessageModel(
      text: text,
      dateTime: dateTime,
      receiverId: receiverId,
      senderId: userModel!.uId,
    );

    //set my chat
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessStates());
    }).catchError((error) {
      emit(SocialSendMessageErrorStates(error.toString()));
    });

    //set reciver chat
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('message')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessStates());
    }).catchError((error) {
      emit(SocialSendMessageErrorStates(error.toString()));
    });
  }

  List<MessageModel> messages = [];

  void getMessage({required String receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      emit(SocialGetMessageSuccessStates());
    });
  }
}
