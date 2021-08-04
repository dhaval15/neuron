import 'package:d3_force_flutter/d3_force_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class NodeHitTester extends SingleChildRenderObjectWidget {
  const NodeHitTester(
    this.node, {
    required Widget child,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onTap,
    required this.onLongTap,
    required this.onDoubleTap,
    Key? key,
  }) : super(key: key, child: child);

  final Node node;

  final GestureDragUpdateCallback onDragUpdate;
  final GestureDragEndCallback onDragEnd;
  final GestureTapCallback onTap;
  final GestureTapCallback onDoubleTap;
  final GestureTapCallback onLongTap;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderNodeHitTester(
      node,
      onDragUpdate: onDragUpdate,
      onDragEnd: onDragEnd,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongTap: onLongTap,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderNodeHitTester renderObject) {
    renderObject
      ..node = node
      ..onDragUpdate = onDragUpdate
      ..onDragEnd = onDragEnd;
  }
}

class RenderNodeHitTester extends RenderProxyBox {
  RenderNodeHitTester(
    this._node, {
    required GestureDragUpdateCallback onDragUpdate,
    required GestureDragEndCallback onDragEnd,
    required GestureTapCallback onTap,
    required GestureTapCallback onDoubleTap,
    required GestureTapCallback onLongTap,
  })  : _onDragUpdate = onDragUpdate,
        _onDragEnd = onDragEnd,
        _onTap = onTap,
        _onDoubleTap = onDoubleTap,
        _onLongTap = onLongTap;

  late final PanGestureRecognizer _panGestureRecognizer;
  late final TapGestureRecognizer _tapGestureRecognizer;
  late final DoubleTapGestureRecognizer _doubleTapGestureRecognizer;
  late final LongPressGestureRecognizer _longTapGestureRecognizer;

  Node _node;
  Node get node => node;
  set node(Node node) {
    if (node == _node) return;
    _node = node;
  }

  GestureTapCallback _onTap;
  set onTap(GestureTapCallback onTap) {
    if (_onTap == onTap) return;
    _tapGestureRecognizer.onTap = _onTap = onTap;
  }

  GestureTapCallback _onDoubleTap;
  set onDoubleTap(GestureTapCallback onDoubleTap) {
    if (_onDoubleTap == onDoubleTap) return;
    _doubleTapGestureRecognizer.onDoubleTap = _onDoubleTap = onDoubleTap;
  }

  GestureTapCallback _onLongTap;
  set onLongTap(GestureTapCallback onLongTap) {
    if (_onLongTap == onLongTap) return;
    _longTapGestureRecognizer.onLongPress = _onLongTap = onLongTap;
  }

  GestureDragUpdateCallback _onDragUpdate;
  GestureDragUpdateCallback get onDragUpdate => _onDragUpdate;
  set onDragUpdate(GestureDragUpdateCallback onDragUpdate) {
    if (_onDragUpdate == onDragUpdate) return;
    _panGestureRecognizer.onUpdate = _onDragUpdate = onDragUpdate;
  }

  GestureDragEndCallback _onDragEnd;
  GestureDragEndCallback get onDragEnd => _onDragEnd;
  set onDragEnd(GestureDragEndCallback onDragEnd) {
    if (_onDragEnd == onDragEnd) return;
    _panGestureRecognizer.onEnd = _onDragEnd = onDragEnd;
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);

    _panGestureRecognizer = PanGestureRecognizer(debugOwner: this)
      ..onUpdate = _onDragUpdate
      ..onEnd = _onDragEnd;
    _tapGestureRecognizer = TapGestureRecognizer(debugOwner: this)
      ..onTap = _onTap;
    _doubleTapGestureRecognizer = DoubleTapGestureRecognizer(debugOwner: this)
      ..onDoubleTap = _onDoubleTap;
    _longTapGestureRecognizer = LongPressGestureRecognizer(debugOwner: this)
      ..onLongPress = _onLongTap;
  }

  @override
  void detach() {
    _panGestureRecognizer.dispose();
    _tapGestureRecognizer.dispose();
    _doubleTapGestureRecognizer.dispose();
    _longTapGestureRecognizer.dispose();
    super.detach();
  }

  @override
  bool hitTestSelf(Offset position) {
    return size.contains(position);
  }

  @override
  void handleEvent(PointerEvent event, covariant HitTestEntry entry) {
    assert(debugHandleEvent(event, entry));

    if (event is PointerDownEvent) {
      _panGestureRecognizer.addPointer(event);
      _tapGestureRecognizer.addPointer(event);
      _doubleTapGestureRecognizer.addPointer(event);
      _longTapGestureRecognizer.addPointer(event);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();
    context.paintChild(child!, offset);
    canvas.restore();
  }
}
