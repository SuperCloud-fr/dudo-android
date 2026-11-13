import 'package:flutter/widgets.dart';

/// Raw bottom system inset (navigation bar), in logical pixels, read
/// straight from the FlutterView.
///
/// On 3-button-nav phones the edge-to-edge nav bar floats over the app:
/// docked bars and modal sheets need breathing room above it. MediaQueries
/// and SafeAreas get rewritten along the way (and modal sheets routinely
/// lose the bottom inset entirely), but the view's own inset cannot be
/// stripped by any wrapper — it is the only source every context trusts.
double bottomSystemInsetOf(BuildContext context) {
  final view = View.of(context);
  return view.padding.bottom / view.devicePixelRatio;
}
