import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homelyvendor/Home/home_page.dart';
import 'package:homelyvendor/Registration/registration.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:homelyvendor/components/constants.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  var allApi = AllApi();
  var _userEmail = '';
  var _userPassword = '';
  bool loading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),backgroundColor: kgreen,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter email address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      label: Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                    onSaved: (value) {

                      _userPassword = value;

                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.blue,
                      ),
                      label: Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            var token =
                                await FirebaseMessaging.instance.getToken();
                            print('token: $token');
                            final canSignIn = _trySubmit();
                            if (canSignIn) {
                              setState(() {
                                loading = true;
                              });
                              var vendorDetails =
                                  await allApi.getVendor(email: _userEmail);
                              if (vendorDetails != null) {
                                if (_userPassword == vendorDetails.password) {
                                  setState(() {
                                    loading = false;
                                  });
                                  await allApi.putToken(
                                    vendorId: vendorDetails.vendorId,
                                    token: token,
                                  );
                                  Get.to(
                                    MyHomePage(
                                      vendorDetails: vendorDetails,
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    loading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Incorrect password.'),
                                    ),
                                  );
                                }
                              } else {
                                setState(() {
                                  loading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('User does not exist.'),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const Registration());
                    },
                    child: const Text('Register as a vendor'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
