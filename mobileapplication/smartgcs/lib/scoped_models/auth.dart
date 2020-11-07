
import '../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartgcs/scoped_models/main.dart';

import 'package:smartgcs/scoped_models/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class AuthService{
 
  final FirebaseAuth _auth= FirebaseAuth.instance;

  //create user object based on firebase user
  MainModel _userFromFirebaseUser(FirebaseUser user){
    return user!=null ? MainModel(uid:user.uid): null;
  }

  //auth change user stream
  Stream<MainModel> get user{
    return _auth.onAuthStateChanged
      .map(_userFromFirebaseUser);
  }



  //sign in with email and password
  Future signInWithEmailPassword(String email, String password)async{
    try{
      AuthResult result=await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user=result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }


  //register with email and password
  Future registerWithEmailPassword(String email, String password,{Client client, Vendor vendor})async{
    try{
      AuthResult result=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser  user=result.user;
    if (vendor == null) {
        await DatabaseServices(uid: user.uid).updateUserData(client: client);
      } else {
        await DatabaseServices(uid: user.uid).updateUserData(vendor: vendor);
        
      }
     // create a new document for the user with the uid
      

      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign out

  Future signOut()async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
 
}