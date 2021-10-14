import 'package:flutter/material.dart';

class ItemRemovedNotification extends Notification {
  final int itemId;

  const ItemRemovedNotification(this.itemId);
}
