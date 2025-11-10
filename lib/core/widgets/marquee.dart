import 'package:flutter/material.dart';

class MarqueeWidget extends StatefulWidget {
  const MarqueeWidget({
    super.key,
    required this.child,
    this.direction = Axis.horizontal,
    this.animationDuration = const Duration(milliseconds: 6000),
    this.backDuration = const Duration(milliseconds: 800),
    this.pauseDuration = const Duration(milliseconds: 800),
    this.manualScrollEnabled = true,
  });

  final Widget child;
  final Axis direction;
  final Duration animationDuration, backDuration, pauseDuration;
  final bool manualScrollEnabled;

  @override
  State<MarqueeWidget> createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;
  bool _isAnimating = false;
  bool _isDisposed = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAnimation());
  }

  @override
  void didUpdateWidget(covariant MarqueeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAnimation());
  }

  @override
  void dispose() {
    _isDisposed = true;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RepaintBoundary(
      child: SingleChildScrollView(
        scrollDirection: widget.direction,
        controller: _scrollController,
        physics: widget.manualScrollEnabled
            ? const BouncingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        child: widget.direction == Axis.horizontal
            ? IntrinsicWidth(child: widget.child)
            : IntrinsicHeight(child: widget.child),
      ),
    );
  }

  Future<void> _startAnimation() async {
    if (_isAnimating || _isDisposed) return;
    _isAnimating = true;

    while (_scrollController.hasClients && !_isDisposed) {
      if (_scrollController.position.maxScrollExtent <= 0) {
        await Future.delayed(const Duration(seconds: 1));
        continue;
      }

      await Future.delayed(widget.pauseDuration);
      if (!_scrollController.hasClients || _isDisposed) break;

      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: widget.animationDuration,
        curve: Curves.linear,
      );

      await Future.delayed(widget.pauseDuration);
      if (!_scrollController.hasClients || _isDisposed) break;

      await _scrollController.animateTo(0, duration: widget.backDuration, curve: Curves.easeOut);
    }

    _isAnimating = false;
  }
}
