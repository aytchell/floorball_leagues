import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FloorballIcons {
  static final _ios = Platform.isIOS;
  static final settings = _ios ? CupertinoIcons.settings : Icons.settings;
  static final home = _ios ? CupertinoIcons.home : Icons.home;
  static final history = _ios ? CupertinoIcons.clock : Icons.history;

  static final pin = _ios ? CupertinoIcons.pin_fill : Icons.push_pin;
  static final pinBorder = _ios ? CupertinoIcons.pin : Icons.push_pin_outlined;
  static final heart = _ios ? CupertinoIcons.heart_fill : Icons.favorite;
  static final heartBorder = _ios
      ? CupertinoIcons.heart
      : Icons.favorite_outline;
  static final star = _ios ? CupertinoIcons.star_fill : Icons.star;
  static final starBorder = _ios ? CupertinoIcons.star : Icons.star_outline;
  static final bookmark = _ios ? CupertinoIcons.bookmark_solid : Icons.bookmark;
  static final bookmarkBorder = _ios
      ? CupertinoIcons.bookmark
      : Icons.bookmark_outline;

  static final check = _ios ? CupertinoIcons.check_mark : Icons.check;
  static final trashCan = _ios ? CupertinoIcons.trash : Icons.delete_outlined;
}
