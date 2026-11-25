import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_reviewer/src/shared/utils/stack_layout.dart';

void main() {
  group('computeStackLayout', () {
    test('fits a card to available height when width allows', () {
      final layout = computeStackLayout(
        available: const Size(200, 200),
        count: 1,
        cardAspectRatio: 1,
      );

      expect(layout.cardSize, const Size(192, 192));
      expect(layout.poses, hasLength(1));
    });

    test('fits a card to available width when it is too narrow', () {
      final layout = computeStackLayout(
        available: const Size(100, 300),
        count: 1,
        cardAspectRatio: 2,
      );

      expect(layout.cardSize, const Size(92, 46));
    });

    test('returns no poses for an empty stack', () {
      final layout = computeStackLayout(
        available: const Size(100, 100),
        count: 0,
        cardAspectRatio: 1,
      );

      expect(layout.poses, isEmpty);
    });

    test('places two cards back-to-front', () {
      final layout = computeStackLayout(
        available: const Size(200, 200),
        count: 2,
        cardAspectRatio: 1,
      );

      expect(layout.poses, hasLength(2));
      expect(layout.poses[0].angle, -0.1);
      expect(layout.poses[0].offset, const Offset(-8, 6));
      expect(layout.poses[1].angle, 0);
      expect(layout.poses[1].offset, Offset.zero);
    });

    test('places three cards back-to-front', () {
      final layout = computeStackLayout(
        available: const Size(200, 200),
        count: 3,
        cardAspectRatio: 1,
      );

      expect(layout.poses, hasLength(3));
      expect(layout.poses[0].angle, -0.1);
      expect(layout.poses[1].angle, 0.08);
      expect(layout.poses[1].offset, const Offset(8, 6));
      expect(layout.poses[2].angle, 0);
      expect(layout.poses[2].offset, Offset.zero);
    });

    test('caps visible poses when count exceeds the visible-card limit', () {
      final layout = computeStackLayout(
        available: const Size(200, 200),
        count: 1000000,
        cardAspectRatio: 1,
      );

      expect(layout.poses, hasLength(3));
    });

    test('returns zero-sized cards when available dimensions are zero', () {
      final layout = computeStackLayout(
        available: Size.zero,
        count: 1,
        cardAspectRatio: 1,
      );

      expect(layout.cardSize, Size.zero);
    });

    test('throws a range error for a negative card count', () {
      expect(
        () => computeStackLayout(
          available: const Size(100, 100),
          count: -1,
          cardAspectRatio: 1,
        ),
        throwsA(isA<RangeError>()),
      );
    });
  });

  group('CardPose.lerpTo', () {
    const start = CardPose(angle: -1, offset: Offset(0, 2));
    const end = CardPose(angle: 1, offset: Offset(10, 6));

    test('returns the starting pose at zero', () {
      expect(start.lerpTo(end, 0).angle, -1);
      expect(start.lerpTo(end, 0).offset, const Offset(0, 2));
    });

    test('returns the ending pose at one', () {
      expect(start.lerpTo(end, 1).angle, 1);
      expect(start.lerpTo(end, 1).offset, const Offset(10, 6));
    });

    test('interpolates angle and offset at the midpoint', () {
      expect(start.lerpTo(end, 0.5).angle, 0);
      expect(start.lerpTo(end, 0.5).offset, const Offset(5, 4));
    });
  });
}
