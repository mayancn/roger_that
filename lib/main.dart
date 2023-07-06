import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:roger_that/providers/group.dart';
import 'package:roger_that/static/firestore_collections.dart';

import 'blocs/auth/auth_bloc.dart';
import 'ui/login.dart';
import 'ui/components.dart';
import 'ui/home.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('State: Current: ${transition.currentState}, Next: ${transition.nextState}');
    super.onTransition(bloc, transition);
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    print('Event: $event');
    super.onEvent(bloc, event);
  }
}

void main() {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  FlutterDownloader.initialize(debug: kDebugMode);
  appChannel = MethodChannel(methodChannel);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthBloc _authBloc;

  @override
  void initState() {
    _authBloc = AuthBloc();
    _authBloc.add(CheckLogin());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GroupProvider(),
      child: MaterialApp(
        title: 'Roger That',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider<AuthBloc>(
          create: (context) => _authBloc,
          child: BlocBuilder<AuthBloc, AuthState>(
            cubit: _authBloc,
            builder: (context, state) {
              if (state is AuthUnAuthenticated) {
                return LoginPage();
              } else if (state is AuthAuthenticated) {
                Provider.of<GroupProvider>(context, listen: false).getGroups();
                return HomePage();
              }
              return LoadingIndicator();
            },
          ),
        ),
      ),
    );
  }
}
