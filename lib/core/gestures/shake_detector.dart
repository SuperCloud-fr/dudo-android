import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Detects a deliberate shake (acceleration peaks above [threshold], with a
/// cool-down so a single gesture fires once) so the dice cup can be mixed
/// before it is lifted.
///
/// The sensor stream is best-effort: on desktop, in tests, or when the
/// platform channel is unavailable, [start] simply does nothing and the
/// caller keeps its tap fallback.
class ShakeDetector {
  ShakeDetector({
    required this.onShake,
    this.threshold = 12.5,
    this.coolDown = const Duration(milliseconds: 300),
  });

  final VoidCallback onShake;

  /// Acceleration magnitude (m/s², gravity excluded) that counts as a shake.
  final double threshold;

  /// Minimum gap between two triggers.
  final Duration coolDown;

  StreamSubscription<UserAccelerometerEvent>? _subscription;
  DateTime _lastTrigger = DateTime.fromMillisecondsSinceEpoch(0);

  void start() {
    _subscription?.cancel();
    try {
      _subscription =
          userAccelerometerEventStream(
            samplingPeriod: const Duration(milliseconds: 60),
          ).listen(
            (event) {
              final magnitude = math.sqrt(
                event.x * event.x + event.y * event.y + event.z * event.z,
              );
              if (magnitude < threshold) return;
              final now = DateTime.now();
              if (now.difference(_lastTrigger) < coolDown) return;
              _lastTrigger = now;
              onShake();
            },
            onError: (Object _) {
              // Sensor unavailable: the tap fallback still works.
            },
            cancelOnError: false,
          );
    } catch (_) {
      // No sensor stream on this platform.
    }
  }

  void dispose() {
    unawaited(_subscription?.cancel());
    _subscription = null;
  }
}
