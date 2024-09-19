class Post{
  final String? description;
  final String? uid;
  final String? username;
  final likes;
  final DateTime datePublished;
  final String? profImage;
  final String? postUrl;
  final String? postId;
  const Post(
      {required this.description,
        required this.uid,
        required this.username,
        required this.likes,
        required this.postId,
        required this.datePublished,
        required this.postUrl,
        required this.profImage,
      });
  Map<String,dynamic> toJson()=>{
    "description": description,
    "uid": uid,
    "likes": likes,
    "username": username,
    "postId": postId,
    "datePublished": datePublished,
    'postUrl': postUrl,
    'profImage': profImage
  };

}