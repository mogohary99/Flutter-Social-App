import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/screens/chats/chats_details_screen.dart';
import 'package:social_app/screens/social_layout/cubit/cubit.dart';
import 'package:social_app/screens/social_layout/cubit/states.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);
        return ListView.builder(
          itemCount: cubit.users.length,
          itemBuilder: (context, index) {
            return buildUserCard(cubit.users[index],context);
          },
        );
      },
    );
  }

  InkWell buildUserCard(UserModel model,context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatsDetailsScreen(userModel: model)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(model.image),
                ),
                const SizedBox(width: 10),
                Text(
                  model.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 0.7,
            )
          ],
        ),
      ),
    );
  }
}
