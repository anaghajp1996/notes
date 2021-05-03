import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes/models/authentication.dart';

class AuthenticationViewModel {
  Future<Authentication> signInUser(String email, String password) async {
    final authentication = Authentication();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential != null) {
        authentication.isAuthenticated = true;
      }
    } on FirebaseAuthException catch (e) {
      authentication.isAuthenticated = false;
      authentication.errorMessage = e.message;
    } catch (e) {
      authentication.isAuthenticated = false;
      authentication.errorMessage = 'Something went wrong. Please try again.';
    }
    return authentication;
  }

  Future<Authentication> createUser(String email, String password) async {
    final authentication = Authentication();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential != null) {
        authentication.isAuthenticated = true;
      }
    } on FirebaseAuthException catch (e) {
      authentication.isAuthenticated = false;
      authentication.errorMessage = e.message;
    } catch (e) {
      authentication.isAuthenticated = false;
      authentication.errorMessage = 'Something went wrong. Please try again.';
    }
    return authentication;
  }

  Future<Authentication> signInWithGoogle() async {
    final authentication = Authentication();
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential != null) {
        authentication.isAuthenticated = true;
      }
    } on FirebaseAuthException catch (e) {
      authentication.isAuthenticated = false;
      authentication.errorMessage = e.message;
    } catch (e) {
      authentication.isAuthenticated = false;
      authentication.errorMessage = 'Something went wrong. Please try again.';
    }
    return authentication;
  }
}
