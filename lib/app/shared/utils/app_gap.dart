import 'package:flutter/widgets.dart';

/// Class untuk memberikan gap atau jarak antar widget dengan mudah.
class AppGap {
  /// Gap vertikal 5px
  static const v5 = SizedBox(height: 5);

  /// Gap vertikal 10px
  static const v10 = SizedBox(height: 10);

  /// Gap vertikal 15px
  static const v15 = SizedBox(height: 15);

  /// Gap vertikal 20px
  static const v20 = SizedBox(height: 20);

  /// Gap vertikal 30px
  static const v30 = SizedBox(height: 30);

  /// Gap horizontal 5px
  static const h5 = SizedBox(width: 5);

  /// Gap horizontal 10px
  static const h10 = SizedBox(width: 10);

  /// Gap horizontal 15px
  static const h15 = SizedBox(width: 15);

  /// Gap horizontal 20px
  static const h20 = SizedBox(width: 20);

  /// Gap horizontal 30px
  static const h30 = SizedBox(width: 30);

  /// Gap fleksibel (bisa digunakan untuk memisahkan elemen dengan space di antara)
  static const flex = Expanded(child: SizedBox());

  /// Gap custom vertikal dengan ukuran bebas
  static SizedBox v(double value) => SizedBox(height: value);

  /// Gap custom horizontal dengan ukuran bebas
  static SizedBox h(double value) => SizedBox(width: value);
}
