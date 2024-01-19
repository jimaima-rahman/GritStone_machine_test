import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final fontFamilyProvider = Provider<List<TextStyle>>((ref) {
  return [
    GoogleFonts.pacifico(),
    GoogleFonts.grapeNuts(),
    GoogleFonts.poppins(),
  ];
});

final fontIndexProvider = StateProvider<int>((ref) => 0);
