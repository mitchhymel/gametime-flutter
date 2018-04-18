part of gametime;

loggerMiddleware(Store store, action, NextDispatcher next) {
  debugPrint('ACTION: ${action.toString()}');
  debugPrint('STATE BEFORE: ${store.state.toString()}');
  next(action);
  debugPrint('STATE AFTER: ${store.state.toString()}');
}