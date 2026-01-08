import 'package:flutter/material.dart';

// Sometimes we need the BuildContext inside the onPressed callback but
// Widgets don't provide it. By using this higher level function
// one can use the BuildContext of Widget inside the onPressed callback.
typedef OnPressedFactory = void Function() Function(BuildContext);
