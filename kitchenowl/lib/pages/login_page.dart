import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:kitchenowl/styles/themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kitchenowl/app.dart';
import 'package:kitchenowl/cubits/auth_cubit.dart';
import 'package:kitchenowl/cubits/server_info_cubit.dart';
import 'package:kitchenowl/enums/oidc_provider.dart';
import 'package:kitchenowl/services/api/api_service.dart';
import 'package:kitchenowl/kitchenowl.dart';
import 'package:kitchenowl/styles/color_mapper.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:kitchenowl/pages/splash_page.dart';

class LoginPage extends StatefulWidget {
  final String? launch;
  const LoginPage({super.key, this.launch});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.launch != null) {
      var provider = OIDCProivder.parse(widget.launch as String);
      if (provider != null && _providerEnabled(provider)) {
        provider.login(context);
        return const SplashPage();
      }
    }

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (getValueForScreenType(
            context: context,
            mobile: false,
            tablet: false,
            desktop: true,
          ))
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 24, 14, 24),
                child: Container(
                  child: SvgPicture(
                    SvgAssetLoader(
                      "assets/illustrations/shopping_app.svg",
                      colorMapper: KitchenOwlColorMapper(
                        accentColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    fit: BoxFit.scaleDown,
                  ),
                  padding: const EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: App.settings.accentColor == null &&
                              Theme.of(context).brightness == Brightness.dark
                          ? [
                              Theme.of(context).colorScheme.surfaceBright.withAlpha(200),
                              Color.alphaBlend(
                                  Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withAlpha(24),
                                  Theme.of(context).colorScheme.surfaceBright),
                            ]
                          : [
                              Color.alphaBlend(
                                  Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                      .withAlpha(150),
                                  Theme.of(context).colorScheme.surfaceContainer),
                              Color.alphaBlend(
                                  Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer
                                      .withAlpha(90),
                                  Theme.of(context).colorScheme.surfaceContainer),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.xl + 8),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outlineVariant
                          .withAlpha(70),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: CustomScrollView(
              primary: true,
              slivers: [
                if (!kIsWeb)
                  SliverAppBar(
                    actions: [
                      PopupMenuButton(
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<int>>[
                          PopupMenuItem<int>(
                            value: 0,
                            child: ListTile(
                              leading: const Icon(Icons.swap_horiz_rounded),
                              title: Text(
                                  AppLocalizations.of(context)!.serverChange),
                            ),
                          ),
                        ],
                        onSelected: (_) {
                          BlocProvider.of<AuthCubit>(context).removeServer();
                        },
                      ),
                    ],
                  ),
                SliverCrossAxisConstrained(
                  maxCrossAxisExtent: 600,
                  child: SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AutofillGroup(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Color.alphaBlend(
                                        Theme.of(context)
                                            .colorScheme
                                            .tertiary
                                            .withAlpha(90),
                                        Theme.of(context).colorScheme.primary),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(
                                    AppRadius.lg + 6),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withAlpha(60),
                                    blurRadius: 18,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.shopping_basket_rounded,
                                size: 30,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              AppLocalizations.of(context)!.welcomeBack,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 10),
                            if (!App.isDefaultServer)
                              Text(
                                '${AppLocalizations.of(context)!.loginTo} ${Uri.parse(ApiService.getInstance().baseUrl).authority}',
                              ),
                            if (_displayUsernamePassword()) ...[
                              const SizedBox(height: 24),
                              TextField(
                                controller: usernameController,
                                autofocus: true,
                                autofillHints: const [
                                  AutofillHints.username,
                                  AutofillHints.email,
                                ],
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText:
                                      AppLocalizations.of(context)!.username,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: passwordController,
                                obscureText: true,
                                textInputAction: TextInputAction.go,
                                autofillHints: const [AutofillHints.password],
                                keyboardType: TextInputType.visiblePassword,
                                onSubmitted: (value) =>
                                    BlocProvider.of<AuthCubit>(context).login(
                                  usernameController.text,
                                  passwordController.text,
                                  () => showSnackbar(
                                    context: context,
                                    content: Text(AppLocalizations.of(context)!
                                        .wrongUsernameOrPassword),
                                    width: null,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  labelText:
                                      AppLocalizations.of(context)!.password,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 16, bottom: 10),
                                child: LoadingFilledButton(
                                  onPressed: () =>
                                      BlocProvider.of<AuthCubit>(context).login(
                                    usernameController.text,
                                    passwordController.text,
                                    () => showSnackbar(
                                      context: context,
                                      content: Text(
                                          AppLocalizations.of(context)!
                                              .wrongUsernameOrPassword),
                                      width: null,
                                    ),
                                  ),
                                  child:
                                      Text(AppLocalizations.of(context)!.login),
                                ),
                              ),
                            ],
                            if (_displayRegister())
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 100,
                                    child: Divider(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child:
                                        Text(AppLocalizations.of(context)!.or),
                                  ),
                                  const SizedBox(
                                    width: 100,
                                    child: Divider(),
                                  ),
                                ],
                              ),
                            if (_displayRegister())
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 8),
                                child: ElevatedButton(
                                  onPressed: () => context.push("/register"),
                                  child: Text(
                                      AppLocalizations.of(context)!.signup),
                                ),
                              ),
                            if (_displayUsernamePassword()) const Spacer(),
                            if (App.serverInfo is ConnectedServerInfoState &&
                                (App.serverInfo as ConnectedServerInfoState)
                                    .emailMandatory)
                              TextButton.icon(
                                icon: const Icon(Icons.lock_reset_rounded),
                                label: Text(AppLocalizations.of(context)!
                                    .passwordForgot),
                                onPressed: () =>
                                    context.push("/forgot-password"),
                              ),
                            if (_displayOIDC()) ...[
                              if (_displayUsernamePassword())
                                const Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Divider(),
                                )
                              else
                                SizedBox(height: 10),
                              if (_providerEnabled(OIDCProivder.custom))
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, bottom: 2),
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        OIDCProivder.custom.login(context),
                                    icon: OIDCProivder.custom.toIcon(context),
                                    label: Text(AppLocalizations.of(context)!
                                        .signInWith(OIDCProivder.custom
                                            .toLocalizedString())),
                                  ),
                                ),
                              if (_providerEnabled(OIDCProivder.google))
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, bottom: 2),
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        OIDCProivder.google.login(context),
                                    icon: OIDCProivder.google.toIcon(context),
                                    label: Text(AppLocalizations.of(context)!
                                        .signInWith(OIDCProivder.google
                                            .toLocalizedString())),
                                  ),
                                ),
                              if (!kIsWeb &&
                                  (Platform.isIOS || Platform.isMacOS) &&
                                  _providerEnabled(OIDCProivder.apple))
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, bottom: 2),
                                  child: LoadingElevatedButtonIcon(
                                    onPressed: () =>
                                        OIDCProivder.apple.login(context),
                                    icon: OIDCProivder.apple.toIcon(context),
                                    label: Text(AppLocalizations.of(context)!
                                        .signInWith(OIDCProivder.apple
                                            .toLocalizedString())),
                                  ),
                                ),
                            ],
                            SizedBox(
                                height:
                                    MediaQuery.paddingOf(context).bottom + 16),
                            if (!_displayUsernamePassword()) const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _displayRegister() =>
      App.serverInfo is ConnectedServerInfoState &&
      (App.serverInfo as ConnectedServerInfoState).openRegistration;

  bool _displayOIDC() =>
      App.serverInfo is ConnectedServerInfoState &&
      (App.serverInfo as ConnectedServerInfoState).oidcProvider.isNotEmpty;

  bool _providerEnabled(OIDCProivder provider) =>
      (App.serverInfo as ConnectedServerInfoState)
          .oidcProvider
          .contains(provider);

  bool _displayUsernamePassword() =>
      App.serverInfo is ConnectedServerInfoState &&
      !(App.serverInfo as ConnectedServerInfoState)
          .disableUsernamePasswordLogin;
}
