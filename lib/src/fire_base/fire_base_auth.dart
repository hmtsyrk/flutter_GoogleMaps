import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirAuth {
  final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;

  void signUp(
      String email, String pass, String name, String phone, Function onSuccess, Function(String) onRegisterError)
  {
    _fireBaseAuth
        .createUserWithEmailAndPassword(email: email, password: pass)
        .then((user) {
      print(user.user.email);
      _createUser(user.user.uid, name, phone, onSuccess, onRegisterError);
    }).catchError((err) {
      print("err: " + err.toString());
      _onSignUpErr(err.code, onRegisterError);
    });
  }

  void signIn(String email, String pass, Function onSuccess,
      Function(String) onSignInError) {
    _fireBaseAuth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) {
          print(user.user.uid);
          print("başarılı giriş");
      onSuccess();
    }).catchError((err) {
      print("err: " + err.toString());
      onSignInError("İşlem başarısız oldu. Lütfen tekrar deneyiniz.");
    });
  }

  _createUser(String userId, String name, String phone, Function onSuccess, Function(String) onRegisterError)
  {
    var user = Map<String, String>();
    user["name"] = name;
    user["phone"] = phone;

    var ref = FirebaseDatabase.instance.reference().child("users");
    ref.child(userId).set(user).then((user) {
      // print("on value: SUCCESSED");
      onSuccess();
    }).catchError((err) {
      print("err: " + err.toString());
      onRegisterError("İşlem başarısız oldu. Lütfen tekrar deneyiniz");
    });
    // .whenComplete(() {
    //   print("completed");
    // });
  }

  ///

  void _onSignUpErr(String code, Function(String) onRegisterError) {
    print(code);
    switch (code) {
      case "ERROR_INVALID_EMAIL":
      case "ERROR_INVALID_CREDENTIAL":
        onRegisterError("Geçersiz mail adresi");
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        onRegisterError("Bu mail adresi kullanılmaktadır");
        break;
      case "ERROR_WEAK_PASSWORD":
        onRegisterError("Zayıf parola");
        break;
      default:
        onRegisterError("İşlem başarısız oldu. Lütfen tekrar deneyiniz");
        break;
    }
  }

  Future<void> signOut() async {
    print("signOut");
    return _fireBaseAuth.signOut();
  }
}
