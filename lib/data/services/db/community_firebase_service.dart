import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:teeklit/domain/model/community/posts.dart';

class CommunityFirebaseService {
  final postRef = FirebaseFirestore.instance.collection('posts');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// post add 게시글 추가
  Future<void> addPost(Posts post) async {
    await postRef.add(post.toJson());
  }

  /// post read all 게시글 전체 읽기 -> 안쓸거지만 만들어봄
  Future<List<Posts>> readAllPosts() async {
    List<Posts> getPosts = [];

    final querySnapshot = await postRef.get();

    for (var doc in querySnapshot.docs) {
      getPosts.add(Posts.fromJson(doc));
    }

    return getPosts;
  }

  /// post one read 게시글 하나 읽기
  Future<Posts> readOnePosts(String postId) async {
    final documentSnapshot = await postRef.doc(postId).get();

    return Posts.fromJson(documentSnapshot);
  }

  /// post update 게시글 업데이트
  Future<void> updatePost(Posts post) async {
    await postRef.doc(post.postId).set(post.toJson());
  }

  /// post delete 게시글 삭제
  Future<void> deletePost(String postId) async {
    await postRef.doc(postId).delete();
  }

  /// save Image 사진 저장
  Future<String> saveImage(File image, String imageName) async {
    // 저장할 이미지 명
    final String fileName =
        '${DateTime.now().millisecondsSinceEpoch}_$imageName';

    // ref
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('image')
        .child('community')
        .child(fileName);

    // 저장
    await storageRef.putFile(image);

    // 저장 경로 반환
    return fileName;
  }
}
