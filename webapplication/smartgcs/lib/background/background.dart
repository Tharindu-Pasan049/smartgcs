import 'package:flutter/material.dart';
import 'dart:ui';

const primaryColor = const Color(0xFF69F0AE);
const primaryLight = const Color(0xFF00E676);
const primaryDark = const Color(0xFF00E676);

const secondaryColor = const Color(0xFF00E676);
const secondaryLight = const Color(0xFF00E676);
const secondaryDark = const Color(0xFF69F0AE);

const Color gradientStart = const Color(0xFF69F0AE);
const Color gradientEnd = const Color(0xFF26A69A);

const primaryGradient = const LinearGradient(
  colors: const [gradientStart, gradientEnd],
  stops: const [0.0, 1.0],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const chatBubbleGradient = const LinearGradient(
  colors: const [Color(0xFF69F0AE), Color(0xFF00E676)],
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
);

const chatBubbleGradient2 = const LinearGradient(
  colors: const [Color(0xFF00E676), Color(0xFF00E676)],
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
);
