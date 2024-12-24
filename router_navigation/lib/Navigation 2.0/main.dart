import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: MyRouterDelegate(),
      routeInformationParser: MyRouteInformationParser(),
    );
  }
}

class MyRouterDelegate extends RouterDelegate<RouteSettings>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteSettings> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  RouteSettings? _currentConfiguration;

  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  RouteSettings? get currentConfiguration => _currentConfiguration;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: ValueKey('HomePage'),
          child: HomeScreen(
            onTapped: (id) {
              _currentConfiguration =
                  RouteSettings(name: '/details', arguments: id);
              notifyListeners();
            },
          ),
        ),
        if (_currentConfiguration?.name == '/details')
          MaterialPage(
            key: ValueKey('DetailPage'),
            child: DetailScreen(id: _currentConfiguration?.arguments as int),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        _currentConfiguration = null;
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RouteSettings configuration) async {
    _currentConfiguration = configuration;
  }
}

class MyRouteInformationParser extends RouteInformationParser<RouteSettings> {
  @override
  Future<RouteSettings> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'details') {
      final id = int.tryParse(uri.pathSegments[1]);
      if (id != null) {
        return RouteSettings(name: '/details', arguments: id);
      }
    }
    return RouteSettings(name: '/');
  }

  @override
  RouteInformation? restoreRouteInformation(RouteSettings configuration) {
    if (configuration.name == '/details') {
      final id = configuration.arguments as int;
      return RouteInformation(location: '/details/$id');
    }
    return RouteInformation(location: '/');
  }
}

class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onTapped;

  const HomeScreen({super.key, required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => onTapped(42), // 예시 ID 값
          child: Text('Go to Detail Screen'),
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final int id;

  const DetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail')),
      body: Center(
        child: Text('Detail Screen with ID: $id'),
      ),
    );
  }
}
