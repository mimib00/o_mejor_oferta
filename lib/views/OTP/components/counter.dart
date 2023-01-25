import 'dart:async';

import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  /// Time to countdown in seconds.
  final int time;

  /// Display after the timer reach 0 seconds.
  final String label;
  final Function()? onTap;
  const Counter({
    super.key,
    required this.time,
    required this.label,
    this.onTap,
  });

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  late int count;

  late StreamSubscription<int> stream;

  @override
  void initState() {
    count = widget.time;
    stream = Stream<int>.periodic(const Duration(seconds: 1), (value) => widget.time - value).listen(
      (event) {
        if (event < 0) return;
        setState(() {
          count = event;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return count <= 0
        ? TextButton(
            onPressed: () {
              setState(() {
                count = widget.time;
              });
              Stream<int>.periodic(const Duration(seconds: 1), (value) => widget.time - value).listen(
                (event) {
                  if (event < 0) return;
                  setState(() {
                    count = event;
                  });
                },
              );
              widget.onTap?.call();
            },
            child: Text(widget.label),
          )
        : Text('Resend in $count');
  }

  @override
  void dispose() {
    stream.cancel();
    super.dispose();
  }
}
