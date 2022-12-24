import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/screens/chats/chats_screen.dart';
import '/screens/social_layout/cubit/cubit.dart';
import '/screens/social_layout/cubit/states.dart';

class EditProfileScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        var profileImage = SocialCubit.get(context).profileImage;
        var coverImage = SocialCubit.get(context).coverImage;
        nameController.text = userModel!.name;
        bioController.text = userModel.bio;
        phoneController.text = userModel.phone;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
            actions: [
              TextButton(
                  onPressed: () {
                    SocialCubit.get(context).updateUser(
                      name: nameController.text,
                      phone: phoneController.text,
                      bio: bioController.text,
                    );
                  },
                  child: const Text('Update')),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (state is SocialUserUpdateLoadingStates)
                    const LinearProgressIndicator(),
                  if (state is SocialUserUpdateLoadingStates)
                    const SizedBox(height: 10),
                  SizedBox(
                    height: 250,
                    child: Stack(
                      children: [
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            image: coverImage != null
                                ? DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(File(coverImage.path)))
                                : DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(userModel.cover)),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.white,
                            child: Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: profileImage != null
                                    ? DecorationImage(
                                        fit: BoxFit.cover,
                                        image:
                                            FileImage(File(profileImage.path)))
                                    : DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(userModel.image)),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: buildCameraButton(press: () {
                            SocialCubit.get(context).getCoverImage();
                          }),
                        ),
                        Positioned(
                          bottom: 0,
                          right: MediaQuery.of(context).size.width / 2 + 10,
                          child: buildCameraButton(press: () {
                            SocialCubit.get(context).getProfileImage();
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (SocialCubit.get(context).profileImage != null ||
                      SocialCubit.get(context).coverImage != null)
                    Row(
                      children: [
                        if (SocialCubit.get(context).profileImage != null)
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                SocialCubit.get(context).uploadProfileImage(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  bio: bioController.text,
                                );
                              },
                              height: 40,
                              color: Colors.blue,
                              child: const Text(
                                'Update profile',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(width: 5),
                        if (SocialCubit.get(context).coverImage != null)
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                SocialCubit.get(context).uploadCoverImage(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  bio: bioController.text,
                                );
                              },
                              height: 40,
                              color: Colors.blue,
                              child: const Text(
                                'Update Cover',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name must not be empty!';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: bioController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'bio must not be empty!';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'bio',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: phoneController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Phone must not be empty!';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Padding buildCameraButton({required VoidCallback press}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 20,
        child: IconButton(
          icon: const Icon(
            Icons.camera_alt_outlined,
          ),
          color: Colors.blue,
          onPressed: press,
          iconSize: 20,
        ),
      ),
    );
  }
}
