import 'dart:async';

import 'package:arogyam/bloc/app_effect.dart';

abstract class SideEffectProvider<T extends AppEffect> {
  Stream<T> get effectStream;

  void produceSideEffect(T effect);
}

mixin SideEffectProviderMixin<T extends AppEffect> implements SideEffectProvider<T> {
  final _streamController = StreamController<T>();

  @override
  Stream<T> get effectStream => _streamController.stream;

  @override
  void produceSideEffect(effect) => _streamController.sink.add(effect);
}
