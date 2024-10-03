import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AppLifecycleDisplay extends StatefulWidget {
  const AppLifecycleDisplay({super.key});

  @override
  State<AppLifecycleDisplay> createState() => _AppLifecycleDisplayState();
}

class _AppLifecycleDisplayState extends State<AppLifecycleDisplay> {
  late final AppLifecycleListener _listener;
  final ScrollController _scrollController = ScrollController();
  final List<String> _states = <String>[];
  late AppLifecycleState? _state;

  @override
  void initState() {
    super.initState();
    _state = SchedulerBinding.instance.lifecycleState;
    _listener = AppLifecycleListener(
        // Event handlers...
        onShow: () => _handleTransition('show'),
        onResume: () => _handleTransition('resume'),
        onHide: () => _handleTransition('hide'),
        onInactive: () => _handleTransition('inactive'),
        onPause: () => _handleTransition('pause'),
        onDetach: () => _handleTransition('detach'),
        onRestart: () => _handleTransition('restart'),
        onStateChange: _handleStateChange);
    if (_state != null) {
      _states.add(_state!.name);
    }
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  void _handleTransition(String name) {
    setState(() {
      _states.add(name);
    });
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void _handleStateChange(AppLifecycleState state) {
    setState(() {
      _state = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('App LifeCycle State'),
        ),
        body: Center(
          child: SizedBox(
            width: 300,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: <Widget>[
                  Text('Current State: ${_state ?? 'Not initialized yet'}'),
                  const SizedBox(height: 30),
                  Text('State History:\n  ${_states.join('\n  ')}'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}