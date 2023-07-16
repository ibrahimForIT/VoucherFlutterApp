import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyhaa/providers/auth_view_model_provider.dart';
import 'package:fyhaa/screens/dashboard.dart';
import 'package:fyhaa/utils/labels.dart';
import 'package:fyhaa/widgets/background_theme_widget.dart';
import 'package:fyhaa/widgets/snack_bar_error.dart';
import '../widgets/sing_in_form_widget.dart';

class SingIn extends ConsumerWidget {
  static const String screenRoute = Labels.singInScreenRoute;

  SingIn({super.key});
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.read(authViewModelProvider);
    ref.watch(authViewModelProvider.select((value) => value.isLoading));
    return Stack(
      children: [
        Scaffold(
          body: BackgroundTheme(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: SizedBox(
                  width: 500,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 180,
                          child: Image.asset('images/logoI.png'),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        SignInWidget(
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) => model.email = value,
                          validator: (value) => model.emailValidate(value!),
                          labelText: Labels.email,
                          prefixIcon: const Icon(Icons.email),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Consumer(builder: (context, ref, child) {
                          ref.watch(authViewModelProvider
                              .select((value) => value.obscurePassword));
                          return SignInWidget(
                            obscureText: model.obscurePassword,
                            onChanged: (value) => model.password = value,
                            labelText: Labels.password,
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(model.obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                              onPressed: () {
                                model.obscurePassword = !model.obscurePassword;
                              },
                            ),
                          );
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            ref.watch(authViewModelProvider);
                            return TextButton(
                              style: TextButton.styleFrom(
                                elevation: 5,
                                foregroundColor: Colors.blue,
                                backgroundColor: Colors.brown[400],
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.brown, width: 1),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: model.email.isNotEmpty &&
                                      model.password.isNotEmpty
                                  ? () async {
                                      print(model.email);
                                      if (_formKey.currentState!.validate()) {
                                        try {
                                          await model.login(ref);
                                          // ignore: use_build_context_synchronously
                                          Navigator.pushNamed(
                                              context, Dashboard.screenRoute);
                                        } catch (e) {
                                          AppSnackbar(context).error(e);
                                        }
                                      }
                                    }
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Text(
                                  Labels.signIn.toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (model.isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
