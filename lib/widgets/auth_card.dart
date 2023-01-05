import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../const_data.dart';
import '../models/http_exception.dart';
import '../provider/auth.dart';
import '../screens/auth_screen.dart';
import '../const_data.dart';
import '../screens/products_overview_screen.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

// void _errorDialogBox( String errorMessage) {
//   showDialog(
//     context: context,
//     builder: ((ctx) => AlertDialog(
//           title: const Text('ERROR'),
//           content: Text(errorMessage),
//           actions: [
//             IconButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               icon: const Icon(Icons.check),
//             )
//           ],
//         )),
//   );
// }
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        /*when use stateless widget try this
        / final navigator = Navigator.of(context);*/
        //final isRegister =
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email']!, _authData['password']!);

        // if (isRegister) {
        //if (!mounted) return;
        // Navigator.of(context).pushNamed(ProductsOverviewScreen.routeName);
        // }
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['email']!, _authData['password']!);
      }
    } on HttpException catch (errorHttp) {
      var errorMessage = 'Authentication failed';

      if (errorHttp.toString().contains('EMAIL_EXISTS')) {
        errorMessage =
            'The email address is already in use by another account.';
      } else if (errorMessage.toString().contains('OPERATION_NOT_ALLOWED')) {
        errorMessage = 'Password sign-in is disabled for this project.';
      } else if (errorHttp.toString().contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
        errorMessage =
            'We have blocked all requests from this device due to unusual activity. Try again later';
      } else if (errorHttp.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage =
            'There is no user record corresponding to this identifier. The user may have been deleted';
      } else if (errorMessage.toString().contains('INVALID_PASSWORD')) {
        errorMessage =
            'The password is invalid or the user does not have a password';
      } else if (errorMessage.toString().contains('USER_DISABLED')) {
        errorMessage = 'The user account has been disabled by an administrator';
      } else if (errorMessage.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      }
      errorDialogBox(context, errorMessage);
    } catch (error) {
      const errorMessage = 'Could not authenticate you, please try again later';
      errorDialogBox(context, errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      color: Colors.teal[50],
      shape: RoundedRectangleBorder(
        side: const BorderSide(
            color: Colors.deepOrange,
            width: 2,
            strokeAlign: StrokeAlign.outside),
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 10.0,
      child: Container(
        height: _authMode == AuthMode.Signup
            ? deviceSize.height - 300
            : deviceSize.height - 390,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 380 : 260),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: textFormFieldEdit.copyWith(
                      labelText: 'E-Mail', hintText: 'Enter Your Valid Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7.0, bottom: 7.0),
                  child: TextFormField(
                    decoration: textFormFieldEdit.copyWith(
                        labelText: 'Password', hintText: 'Enter Your Password'),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                    },
                    onSaved: (value) {
                      _authData['password'] = value!;
                    },
                  ),
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: textFormFieldEdit.copyWith(
                        labelText: 'Confirm Password',
                        hintText: 'Enter Your Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                          }
                        : null,
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    style: authCardBTN,
                    onPressed: _submit,
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                  ),
                TextButton(
                  style: authCardBTN,
                  onPressed: _switchAuthMode,
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
