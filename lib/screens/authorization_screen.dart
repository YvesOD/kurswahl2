import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/authorization_exception.dart';
import '../models/http_exception.dart';
import '../providers/authorization.dart';
import '../widgets/app_drawer.dart';

class AuthorizationScreen extends StatefulWidget {
  static const routeName = '/authorization';

  @override
  _AuthorizationScreenState createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _authorizationCode = {
    'blockOne': '',
    'blockTwo': '',
    'blockThree': '',
    'blockFour': '',
  };
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Autorisierungscode'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Container(
          width: 250,
          height: 150,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        maxLength: 4,
//              decoration: InputDecoration(labelText: 'E-Mail'),
//              keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.length != 4) {
                            return '';
                          }
                        },
                        onSaved: (value) {
                          _authorizationCode['blockOne'] = value;
                        },
                      ),
                    ),
                    Text(' - '),
                    Flexible(
                      child: TextFormField(
                        maxLength: 4,
//              decoration: InputDecoration(labelText: 'E-Mail'),
//              keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.length != 4) {
                            return '';
                          }
                        },
                        onSaved: (value) {
                          _authorizationCode['blockTwo'] = value;
                        },
                      ),
                    ),
                    Text(' - '),
                    Flexible(
                      child: TextFormField(
                        maxLength: 4,
//              decoration: InputDecoration(labelText: 'E-Mail'),
//              keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.length != 4) {
                            return '';
                          }
                        },
                        onSaved: (value) {
                          _authorizationCode['blockThree'] = value;
                        },
                      ),
                    ),
                    Text(' - '),
                    Flexible(
                      child: TextFormField(
                        maxLength: 4,
//              decoration: InputDecoration(labelText: 'E-Mail'),
//              keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.length != 4) {
                            return '';
                          }
                        },
                        onSaved: (value) {
                          _authorizationCode['blockFour'] = value;
                        },
                      ),
                    ),
                  ],
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child: Text('absenden'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Es ist ein Fehler aufgetreten.'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: null,
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Authorization>(context, listen: false).authorize(
        '${_authorizationCode['blockOne']}${_authorizationCode['blockTwo']}${_authorizationCode['blockThree']}${_authorizationCode['blockFour']}',
      );
    } on HttpException catch (error) {
      var errorMessage = 'Autorisierung fehlgeschlagen.';
      _showErrorDialog(errorMessage);
    } on AuthorizationException catch (error) {
      _showErrorDialog(error.message);
    } catch (error) {
      const errorMessage =
          'Autorisierung nicht erfolgreich. Bitte versuchen Sie es später noch einmal.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }
}
