import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../pages.dart';
import 'components/components.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  const LoginPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    void _hideKeyboard() {
      final currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }

    return Scaffold(
      body: Builder(builder: (context) {
        presenter.isLoadingStream.listen((isLoading) {
          if (isLoading) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
        });

        presenter.mainErrorStream.listen((error) {
          if (error != null) {
            showErrorMessage(context, error);
          }
        });

        presenter.navigateToStream.listen((page) {
          if (page?.isNotEmpty == true) {
            Get.offAllNamed(page);
          }
        });

        return GestureDetector(
          onTap: _hideKeyboard,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginHeader(),
                Headline1(text: 'Login'),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Provider(
                    create: (context) => presenter,
                    child: Form(
                      child: Column(
                        children: [
                          EmailInput(),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 32),
                            child: PasswordInput(),
                          ),
                          LoginButton(),
                          FlatButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.person),
                            label: Text('Criar Conta'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
