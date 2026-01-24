import 'package:flutter_test/flutter_test.dart';
import 'package:floorball/api/models/game_date_time.dart';

void main() {
  group('GameDateTime.isBefore', () {
    test('returns true when game date is dqys before the given timestamp', () {
      final gameDateTime = GameDateTime('2026-01-15', '14:30');
      final timestamp = DateTime(2026, 1, 20, 10, 0);

      expect(gameDateTime.isBefore(timestamp), isTrue);
    });

    test(
      'returns true when game date is minutes before the given timestamp',
      () {
        final gameDateTime = GameDateTime('2026-01-15', '14:30');
        final timestamp = DateTime(2026, 1, 15, 14, 33);

        expect(gameDateTime.isBefore(timestamp), isTrue);
      },
    );

    test(
      'returns false when game date is minutes after the given timestamp',
      () {
        final gameDateTime = GameDateTime('2026-01-25', '18:00');
        final timestamp = DateTime(2026, 1, 25, 17, 56);

        expect(gameDateTime.isBefore(timestamp), isFalse);
      },
    );

    test('returns false when game date is days after the given timestamp', () {
      final gameDateTime = GameDateTime('2026-01-25', '18:00');
      final timestamp = DateTime(2026, 1, 20, 19, 56);

      expect(gameDateTime.isBefore(timestamp), isFalse);
    });
  });

  group('GameDateTime.isCloseToToday', () {
    test('indicates today if timestamp is today before game', () {
      final gameDateTime = GameDateTime('2026-01-25', '18:00');
      final timestamp = DateTime(2026, 1, 25, 10, 34);

      final around = gameDateTime.isCloseToToday(timestamp);
      expect(around.today, isTrue);
      expect(around.tomorrow, isFalse);
      expect(around.beyond, isFalse);
    });

    test('indicates today if timestamp is today after game', () {
      final gameDateTime = GameDateTime('2026-01-25', '18:00');
      final timestamp = DateTime(2026, 1, 25, 19, 34);

      final around = gameDateTime.isCloseToToday(timestamp);
      expect(around.today, isTrue);
      expect(around.tomorrow, isFalse);
      expect(around.beyond, isFalse);
    });

    test('indicates tomorrow if timestamp is one day ahead', () {
      final gameDateTime = GameDateTime('2026-01-25', '18:00');
      final timestamp = DateTime(2026, 1, 24, 20, 34);

      final around = gameDateTime.isCloseToToday(timestamp);
      expect(around.today, isFalse);
      expect(around.tomorrow, isTrue);
      expect(around.beyond, isFalse);
    });

    test('indicates tomorrow if timestamp is one day and hours ahead', () {
      final gameDateTime = GameDateTime('2026-01-25', '18:00');
      final timestamp = DateTime(2026, 1, 24, 10, 34);

      final around = gameDateTime.isCloseToToday(timestamp);
      expect(around.today, isFalse);
      expect(around.tomorrow, isTrue);
      expect(around.beyond, isFalse);
    });

    test('indicates beyond if timestamp is two days ahead', () {
      final gameDateTime = GameDateTime('2026-01-25', '18:00');
      final timestamp = DateTime(2026, 1, 23, 23, 34);

      final around = gameDateTime.isCloseToToday(timestamp);
      expect(around.today, isFalse);
      expect(around.tomorrow, isFalse);
      expect(around.beyond, isTrue);
    });
  });

  group('GameDateTime.isCloseToToday on list', () {
    test('indicates today if all timestamps are today', () {
      final gameDateTimes = [
        GameDateTime('2026-01-25', '18:00'),
        GameDateTime('2026-01-25', '16:00'),
        GameDateTime('2026-01-25', '14:00'),
      ];
      final timestamp = DateTime(2026, 1, 25, 15, 34);

      final around = gameDateTimes.isCloseToToday(date: timestamp);
      expect(around.today, isTrue);
      expect(around.tomorrow, isFalse);
      expect(around.beyond, isFalse);
    });

    test('indicates tomorrow if all timestamps are tomorrow', () {
      final gameDateTimes = [
        GameDateTime('2026-01-25', '18:00'),
        GameDateTime('2026-01-25', '14:00'),
        GameDateTime('2026-01-25', '16:00'),
      ];
      final timestamp = DateTime(2026, 1, 24, 16, 34);

      final around = gameDateTimes.isCloseToToday(date: timestamp);
      expect(around.today, isFalse);
      expect(around.tomorrow, isTrue);
      expect(around.beyond, isFalse);
    });

    test('indicates tomorrow if timestamp is one day ahead', () {
      final gameDateTime = GameDateTime('2026-01-25', '18:00');
      final timestamp = DateTime(2026, 1, 24, 20, 34);

      final around = gameDateTime.isCloseToToday(timestamp);
      expect(around.today, isFalse);
      expect(around.tomorrow, isTrue);
      expect(around.beyond, isFalse);
    });

    test('indicates tomorrow if timestamp is one day and hours ahead', () {
      final gameDateTime = GameDateTime('2026-01-25', '18:00');
      final timestamp = DateTime(2026, 1, 24, 10, 34);

      final around = gameDateTime.isCloseToToday(timestamp);
      expect(around.today, isFalse);
      expect(around.tomorrow, isTrue);
      expect(around.beyond, isFalse);
    });

    test('indicates beyond if timestamp is two days ahead', () {
      final gameDateTime = GameDateTime('2026-01-25', '18:00');
      final timestamp = DateTime(2026, 1, 23, 23, 34);

      final around = gameDateTime.isCloseToToday(timestamp);
      expect(around.today, isFalse);
      expect(around.tomorrow, isFalse);
      expect(around.beyond, isTrue);
    });
  });
}
