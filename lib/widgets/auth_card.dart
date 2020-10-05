import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/providers/auth.dart';

enum AuthMode {
  SignUp,
  SignIn,
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _form = GlobalKey();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.SignIn;
  final _passController = TextEditingController();

  AnimationController _animationController;
  Animation<double> _opacityAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
    _slideAnimation = Tween(begin: Offset(0, -1.5), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  final Map<String, String> _authData = {
    'email': '',
    'pass': '',
  };

  void _showErroDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ocorreu um erro'),
        content: Text(msg),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Fechar'),
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_form.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _form.currentState.save();

    Auth _auth = Provider.of(context, listen: false);

    try {
      if (_authMode == AuthMode.SignIn) {
        await _auth.signIn(
          _authData['email'],
          _authData['pass'],
        );
      } else {
        await _auth.signUp(
          _authData['email'],
          _authData['pass'],
        );
      }
    } on AuthException catch (error) {
      _showErroDialog(error.toString());
    } catch (error) {
      _showErroDialog('Ocorreu um erro inesperado.');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _swithAuthMode() {
    if (_authMode == AuthMode.SignIn) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
      _animationController.forward();
    } else {
      setState(() {
        _authMode = AuthMode.SignIn;
      });
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
        height: _authMode == AuthMode.SignIn ? 290 : 371,
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  //Criar classe validator e criar funções que validam e reaproveita-las
                  if (value.isEmpty || !value.contains('@')) {
                    return 'E-mail é obrigatório.';
                  }
                  return null;
                },
                onSaved: (value) => _authData['email'] = value,
              ),
              TextFormField(
                controller: _passController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  //Criar classe validator e criar funções que validam e reaproveita-las
                  if (value.isEmpty || value.length < 5) {
                    return 'Informe uma senha válida, maior que 5 letras.';
                  }
                  return null;
                },
                onSaved: (value) => _authData['pass'] = value,
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.linear,
                constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                    maxHeight: _authMode == AuthMode.SignUp ? 120 : 0),
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Confirmar Senha'),
                      obscureText: true,
                      keyboardType: TextInputType.emailAddress,
                      validator: _authMode == AuthMode.SignUp
                          ? (value) {
                              //Criar classe validator e criar funções que validam e reaproveita-las
                              if (value != _passController.text) {
                                return 'As senhas não conferem.';
                              }
                              return null;
                            }
                          : null,
                    ),
                  ),
                ),
              ),
              Spacer(),
              if (_isLoading)
                CircularProgressIndicator()
              else
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryTextTheme.button.color,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  child: Text(
                    _authMode == AuthMode.SignUp ? 'Cadastrar' : 'Entrar',
                  ),
                  onPressed: _submit,
                ),
              FlatButton(
                onPressed: _swithAuthMode,
                child: Text(_authMode == AuthMode.SignUp
                    ? 'Voltar'
                    : 'Não tem cadastro?'),
                textColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
