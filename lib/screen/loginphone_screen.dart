import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_intermediate/screen/beranda_screen.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ScaffoldSnackbar {
  ScaffoldSnackbar(this._context);
  final BuildContext _context;

  /// The scaffold of current context.
  factory ScaffoldSnackbar.of(BuildContext context) {
    return ScaffoldSnackbar(context);
  }

  /// Helper method to show a SnackBar.
  void show(String message) {
    ScaffoldMessenger.of(_context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }
}

class LoginPhoneScreen extends StatefulWidget {
  static String id = "phone";
  const LoginPhoneScreen({Key? key}) : super(key: key);

  @override
  _LoginPhoneScreenState createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends State<LoginPhoneScreen> {
  final _phoneNumberController = TextEditingController();
  final _smsController = TextEditingController();

  String _message = '';
  late String _verificationId;
  ConfirmationResult? webConfirmationResult;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(bottom: 16),
                alignment: Alignment.center,
                child: const Text(
                  'Test sign in with phone number',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Phone number (+x xxx-xxx-xxxx)',
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Phone number (+x xxx-xxx-xxxx)';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: SignInButtonBuilder(
                  padding: const EdgeInsets.only(top: 16),
                  icon: Icons.contact_phone,
                  backgroundColor: Colors.deepOrangeAccent[700]!,
                  text: 'Verify Number',
                  onPressed: _verifyWebPhoneNumber,
                ),
              ),
              TextField(
                controller: _smsController,
                decoration:
                    const InputDecoration(labelText: 'Verification code'),
              ),
              Container(
                padding: const EdgeInsets.only(top: 16),
                alignment: Alignment.center,
                child: SignInButtonBuilder(
                  icon: Icons.phone,
                  backgroundColor: Colors.deepOrangeAccent[400]!,
                  onPressed: _confirmCodeWeb,
                  text: 'Sign In',
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: const Text(
                'Test sign in with phone number',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone number (+x xxx-xxx-xxxx)',
              ),
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Phone number (+x xxx-xxx-xxxx)';
                }
                return null;
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: SignInButtonBuilder(
                icon: Icons.contact_phone,
                backgroundColor: Colors.deepOrangeAccent[700]!,
                text: 'Verify Number',
                onPressed: _verifyPhoneNumber,
              ),
            ),
            TextField(
              controller: _smsController,
              decoration: const InputDecoration(labelText: 'Verification code'),
            ),
            Container(
              padding: const EdgeInsets.only(top: 16),
              alignment: Alignment.center,
              child: SignInButtonBuilder(
                icon: Icons.phone,
                backgroundColor: Colors.deepOrangeAccent[400]!,
                onPressed: _signInWithPhoneNumber,
                text: 'Sign In',
              ),
            ),
            Visibility(
              visible: _message.isNotEmpty,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _message,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _verifyWebPhoneNumber() async {
    ConfirmationResult confirmationResult =
        await _auth.signInWithPhoneNumber(_phoneNumberController.text);

    webConfirmationResult = confirmationResult;
  }

  Future<void> _confirmCodeWeb() async {
    if (webConfirmationResult != null) {
      try {
        await webConfirmationResult!.confirm(_smsController.text);
      } catch (e) {
        ScaffoldSnackbar.of(context).show('Failed to sign in: ${e.toString()}');
      }
    } else {
      ScaffoldSnackbar.of(context)
          .show('Please input sms code received after verifying phone number');
    }
  }

  // Example code of how to verify phone number
  Future<void> _verifyPhoneNumber() async {
    setState(() {
      _message = '';
    });

    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      ScaffoldSnackbar.of(context).show(
          'Phone number automatically verified and user signed in: $phoneAuthCredential');
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      setState(() {
        _message =
            'Phone number verification failed. Code: ${authException.code}. '
            'Message: ${authException.message}';
      });
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      ScaffoldSnackbar.of(context)
          .show('Please check your phone for the verification code.');

      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: _phoneNumberController.text,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      ScaffoldSnackbar.of(context).show('Failed to Verify Phone Number: $e');
    }
  }

  // Example code of how to sign in with phone.
  Future<void> _signInWithPhoneNumber() async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );
      final User user = (await _auth.signInWithCredential(credential)).user!;
      ScaffoldSnackbar.of(context)
          .show('Successfully signed in UID: ${user.uid}');
      Navigator.pushNamed(context, BerandaScreen.id);
    } catch (e) {
      print(e);
      ScaffoldSnackbar.of(context).show('Failed to sign in');
    }
  }
}
