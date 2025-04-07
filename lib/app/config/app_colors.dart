import 'package:flutter/material.dart';

class AppColors {
  /// Warna utama (coklat keemasan batik)
  static const Color primary = Color(0xFFC89B3C);

  /// Warna sekunder (putih tulang / background)
  static const Color secondary = Color(0xFFFFFBF5);

  /// Warna ketiga / tombol action utama
  static const Color tertiary = Color(0xFF1A1A1A);

  /// Warna aksen (ikon di dalam tombol)
  static const Color accent = Color(0xFFFFFFFF);

  // 🔹 Text Colors
  static const Color textPrimary = Color(0xFF1C1C1C);
  static const Color textSecondary = Color(0xFF757575);

  // 🔹 Background Colors
  /// Warna latar belakang utama aplikasi (default: abu-abu terang)
  static const Color background = Color(0xFFFFFFFF);

  /// Warna permukaan elemen UI (default: putih)
  static const Color surface = Color(0xFFFFFFFF);

  // // 🔹 Text Colors
  // /// Warna teks utama (default: hitam)
  // static const Color textPrimary = Color(0xFF000000);
  //
  // /// Warna teks sekunder (default: abu-abu gelap)
  // static const Color textSecondary = Color(0xFF757575);

  /// Warna teks yang dinonaktifkan (default: abu-abu muda)
  static const Color textDisabled = Color(0xFFBDBDBD);

  // 🔹 Success, Warning, Error Colors
  /// Warna untuk status sukses (default: hijau)
  static const Color success = Color(0xFF4CAF50);

  /// Warna untuk status peringatan (default: kuning)
  static const Color warning = Color(0xFFFFC107);

  /// Warna untuk status error (default: merah)
  static const Color error = Color(0xFFD32F2F);

  // 🔹 Utility Function
  /// Mengembalikan warna dengan tingkat transparansi (opacity)
  ///
  /// * `color` = warna yang ingin diubah transparansinya
  /// * `opacity` = nilai transparansi (0.0 - 1.0)
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
}
