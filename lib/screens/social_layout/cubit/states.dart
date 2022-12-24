abstract class SocialStates{}

class SocialInitialStates extends SocialStates{}

/////////get user
class SocialGetUserLoadingStates extends SocialStates{}

class SocialGetUserSuccessStates extends SocialStates{}

class SocialGetUserErrorStates extends SocialStates{
  final String error;

  SocialGetUserErrorStates(this.error);
}

/////////get posts
class SocialGetPostsLoadingStates extends SocialStates{}

class SocialGetPostsSuccessStates extends SocialStates{}

class SocialGetPostsErrorStates extends SocialStates{
  final String error;

  SocialGetPostsErrorStates(this.error);
}

/////////////////////
class SocialChangeBottomNavBarStates extends SocialStates{}

class SocialNewPostStates extends SocialStates{}

class SocialSuccessGetProfileImageStates extends SocialStates{}

class SocialErrorGetProfileImageStates extends SocialStates{}

class SocialSuccessGetCoverImageStates extends SocialStates{}

class SocialErrorGetCoverImageStates extends SocialStates{}

class SocialSuccessUploadProfileImageStates extends SocialStates{}

class SocialErrorUploadProfileImageStates extends SocialStates{}

class SocialSuccessUploadCoverImageStates extends SocialStates{}

class SocialErrorUploadCoverImageStates extends SocialStates{}

class SocialErrorUserUpdateStates extends SocialStates{}

class SocialUserUpdateLoadingStates extends SocialStates{}


class SocialSuccessGetPostImageStates extends SocialStates{}

class SocialErrorGetPostImageStates extends SocialStates{}
//create post
class SocialCreatePostLoadingStates extends SocialStates{}

class SocialCreatePostSuccessStates extends SocialStates{}

class SocialCreatePostErrorStates extends SocialStates{}

class SocialRemovePostImageStates extends SocialStates{}

//like post
class SocialLikePostsSuccessStates extends SocialStates{}

class SocialLikePostsErrorStates extends SocialStates{
  final String error;

  SocialLikePostsErrorStates(this.error);
}

//Comment on post
class SocialCommentOnPostsSuccessStates extends SocialStates{}

class SocialCommentOnPostPostsErrorStates extends SocialStates{
  final String error;

  SocialCommentOnPostPostsErrorStates(this.error);
}


/////////get all users
class SocialGetAllUserLoadingStates extends SocialStates{}

class SocialGetAllUserSuccessStates extends SocialStates{}

class SocialGetAllUserErrorStates extends SocialStates{
  final String error;

  SocialGetAllUserErrorStates(this.error);
}

// chat
class SocialSendMessageSuccessStates extends SocialStates{}

class SocialSendMessageErrorStates extends SocialStates{
  final String error;

  SocialSendMessageErrorStates(this.error);
}

class SocialGetMessageSuccessStates extends SocialStates{}

class SocialGetMessageErrorStates extends SocialStates{
  final String error;

  SocialGetMessageErrorStates(this.error);
}




