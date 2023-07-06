import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roger_that/static/firestore_collections.dart';

class UserModel {
  String email;
  String photo;

  UserModel({email, photo}) {
    this.email = email;
    this.photo = photo;
  }

  @override
  String toString() => email;

  Map<String, String> toJson() => {
        'email': this.email,
        'photo': this.photo
      };

  Future<bool> createUser() async {
    await Firestore.instance.collection(collectionUser).document(email).setData(toJson());
    return true;
  }

  Future<void> getPhoto() async {
    DocumentSnapshot doc = await Firestore.instance.collection(collectionUser).document(email).get();
    if (doc.data != null) {
      this.photo = doc.data['photo'];
    }
  }
}
