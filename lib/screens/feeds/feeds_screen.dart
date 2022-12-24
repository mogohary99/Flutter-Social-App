import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/screens/social_layout/cubit/cubit.dart';
import 'package:social_app/screens/social_layout/cubit/states.dart';

class FeedsScreen extends StatelessWidget {
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);
        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'https://img.freepik.com/free-photo/aerial-view-business-team_53876-124515.jpg?w=1060&t=st=1664118515~exp=1664119115~hmac=4b5dc0e934a19dc2010bcea5b55adcc8b40cc13cb3534b125ec652c92986c6f4',
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Communicate With your friends.',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
              if (cubit.posts.isEmpty)
                const Center(child: CircularProgressIndicator()),
              if (cubit.posts.isNotEmpty)
                ListView.builder(
                  itemCount: cubit.posts.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return buildPostCard(
                      context: context,
                      model: cubit.posts[index],
                      index: index,
                    );
                  },
                ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        );
      },
    );
  }

  Container buildPostCard(
      {required PostModel model,
      required BuildContext context,
      required int index}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 10),
            blurRadius: 30,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  model.image!,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        model.name!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(
                        Icons.verified,
                        color: Colors.blue,
                        size: 18,
                      )
                    ],
                  ),
                  Text(
                    model.dateTime!,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
                color: Colors.black54,
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              color: Colors.grey,
              thickness: 0.6,
            ),
          ),
          Text(
            model.text!,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Wrap(
              children: [
                SizedBox(
                  height: 30,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('#flutter'),
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('#flutter'),
                  ),
                ),
              ],
            ),
          ),
          if (model.postImage != null && model.postImage!.isNotEmpty)
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(model.postImage!),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                const Icon(
                  Icons.favorite_border,
                  color: Colors.redAccent,
                ),
                const SizedBox(width: 5),
                Text(
                  '${SocialCubit.get(context).likes[index]}',
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        fontSize: 14,
                      ),
                ),
                const Spacer(),
                const Icon(
                  Icons.comment_outlined,
                  color: Colors.redAccent,
                ),
                const SizedBox(width: 5),
                Text(
                  '${SocialCubit.get(context).comments[index]} Comment',
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        fontSize: 14,
                      ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage:
                    NetworkImage(SocialCubit.get(context).userModel!.image),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Write a comment...',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (commentController.text.isNotEmpty) {
                    SocialCubit.get(context).commentOnPost(
                      postId: SocialCubit.get(context).postId[index],
                      comment: commentController.text,
                    );
                    commentController.text='';
                  }
                },
                child: const Text(
                  'Comment',
                  style: TextStyle(fontSize: 10),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  SocialCubit.get(context)
                      .likePost(SocialCubit.get(context).postId[index]);
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                    ),
                    Text(
                      'Like',
                      style: TextStyle(color: Colors.black54),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
