import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/screens/social_layout/cubit/cubit.dart';
import 'package:social_app/screens/social_layout/cubit/states.dart';

class ChatsDetailsScreen extends StatelessWidget {
  UserModel userModel;

  ChatsDetailsScreen({super.key, required this.userModel});

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getMessage(receiverId: userModel.uId);
      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  CircleAvatar(
                    //radius: 30,
                    backgroundImage: NetworkImage(userModel.image),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    userModel.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                if(SocialCubit.get(context).messages.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: SocialCubit.get(context).messages.length,
                    itemBuilder: (context,index){
                      var message=SocialCubit.get(context).messages[index];
                      if(SocialCubit.get(context).userModel!.uId == message.senderId) {
                        return buildMyMessage(message);
                      }
                      return buildMessage(message);
                    },
                  ),
                ),
                Container(
                  //padding: EdgeInsets.symmetric(horizontal: 5),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: TextFormField(
                            controller: messageController,
                            decoration: const InputDecoration(
                              hintText: 'Write your message here',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.blue,
                        child: IconButton(
                          onPressed: () {
                            if (messageController.text.isNotEmpty) {
                              SocialCubit.get(context).sendMessage(
                                text: messageController.text,
                                dateTime: DateTime.now().toString(),
                                receiverId: userModel.uId,
                              );
                            }
                            messageController.text = '';
                          },
                          icon: const Icon(Icons.send),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );
    });
  }

  Align buildMyMessage(MessageModel model) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
        ),
        child: Text(
          model.text!,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Align buildMessage(MessageModel model) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
        ),
        child: Text(
          model.text!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
