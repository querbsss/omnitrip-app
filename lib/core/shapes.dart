import 'package:flutter/material.dart';

// LuxeTravel radii.
// Cards 24, hero/featured 28-32, badges 8-12, pill = full stadium.
class AppRadii {
  static const double card = 24;
  static const double hero = 32;
  static const double featured = 28;
  static const double tile = 20;
  static const double badge = 12;
  static const double inner = 16;

  static BorderRadius get cardRadius => BorderRadius.circular(card);
  static BorderRadius get heroRadius => BorderRadius.circular(hero);
  static BorderRadius get featuredRadius => BorderRadius.circular(featured);
  static BorderRadius get tileRadius => BorderRadius.circular(tile);
  static BorderRadius get badgeRadius => BorderRadius.circular(badge);
  static BorderRadius get innerRadius => BorderRadius.circular(inner);
}

// LuxeTravel spacing scale.
class AppSpacing {
  static const double stackXs = 4;
  static const double stackSm = 8;
  static const double stackMd = 16;
  static const double stackLg = 24;
  static const double stackXl = 32;
  static const double gutter = 16;
  static const double marginMain = 24;
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: 24);
}
