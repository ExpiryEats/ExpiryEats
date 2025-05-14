import 'package:flutter_test/flutter_test.dart';

String formatItemName(String name) {
  return name
      .trim()
      .split(' ')
      .map((word) => word.isNotEmpty
          ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
          : '')
      .join(' ');
}

void main() {
  group('formatItemName', () {
    test('Capitalises each word and trims whitespace', () {
      final result = formatItemName('  green apples  ');
      expect(result, 'Green Apples');
    });

    test('Works with single word', () {
      final result = formatItemName('banana');
      expect(result, 'Banana');
    });

    test('Empty input returns empty string', () {
      final result = formatItemName('');
      expect(result, '');
    });
  });
}