import 'package:flutter/material.dart';

/// Helper untuk mempermudah penggunaan EdgeInsets pada padding dan margin
extension AppSpacing on num {
  /// Spasi vertikal (top dan bottom)
  EdgeInsets get v => EdgeInsets.symmetric(vertical: toDouble());

  /// Spasi horizontal (left dan right)
  EdgeInsets get h => EdgeInsets.symmetric(horizontal: toDouble());

  /// Spasi di semua sisi (top, bottom, left, right)
  EdgeInsets get all => EdgeInsets.all(toDouble());

  /// Spasi hanya di bagian atas
  EdgeInsets get t => EdgeInsets.only(top: toDouble());

  /// Spasi hanya di bagian bawah
  EdgeInsets get b => EdgeInsets.only(bottom: toDouble());

  /// Spasi hanya di bagian kiri
  EdgeInsets get l => EdgeInsets.only(left: toDouble());

  /// Spasi hanya di bagian kanan
  EdgeInsets get r => EdgeInsets.only(right: toDouble());

  /// Spasi simetris dengan vertikal dan horizontal custom
  EdgeInsets s(double h) => EdgeInsets.symmetric(vertical: toDouble(), horizontal: h);
}
