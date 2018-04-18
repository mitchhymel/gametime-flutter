part of gametime;

class AppLifeCycleWatcher extends StatefulWidget {
  const AppLifeCycleWatcher(this.child,{
    this.onPause,
    this.onResume,
    this.onInactive,
    this.onSuspended
  });

  final Widget child;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onInactive;
  final VoidCallback onSuspended;


  @override
  AppLifeCycleWatcherState createState() => new AppLifeCycleWatcherState();
}

class AppLifeCycleWatcherState extends State<AppLifeCycleWatcher> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (widget.onPause != null) {
        widget.onPause();
      }
    }
    else if (state == AppLifecycleState.resumed) {
      if (widget.onResume != null) {
        widget.onResume();
      }
    }
    else if (state == AppLifecycleState.inactive) {
      if (widget.onInactive == null) {
        widget.onInactive();
      }
    }
    else if (state == AppLifecycleState.suspending) {
      if (widget.onSuspended == null) {
        widget.onSuspended();
      }
    }
    else {
      debugPrint('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}